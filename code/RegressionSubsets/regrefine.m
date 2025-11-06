function [vars,ssq,varprob]=regrefine(vars0,ssq0,nerr,varargin)
% regrefine  Remove regression cases not significant by comparing ssq
%  2017-09-28  Matlab9.3  Copyright (c) 2017, W J Whiten  BSD License 
%
% [ssq,vars,ssqwratio,ssqratio]=regrefine(ssq,vars0)
%  vars0    Matrix with rows of variable numbers used in equations
%  ssq0     Vector of sum of squares values, sorted
%  nerr     Number of error terms used in this regresion
%  optn     Optional values: struct or name value pairs
%            .prob     Prob of selecting random variable column (0.05)
%            .probfi   Prob for testing coefficients (default from .prob)
%            .ssqratio Ratio for removing large sums of squares (2)
%
%  vars     Variable numbers for equations in new order
%  ssq      Sum of squares in new order
%  varprob  Approx probability of same effect as random data column

optn=optndfts(varargin,'prob',0.05,'ssqratio',3,'probfi',[]);

ssq=ssq0;
vars=vars0;
nssq=length(ssq);
nvar=max(vars(:));

% remove equations with large sums of squared residuals
zcnt=sum(ssq==0);
if(zcnt<nssq)
    indequs=ssq<optn.ssqratio*mean(ssq(zcnt+1:min(length(ssq),zcnt+5)));
    ssq=ssq(indequs);
    vars=vars(indequs,:);
end

% F-test values for equation rejection power of i for i coefficients
if(isempty(optn.probfi))
    probfi=regpvalues(nerr,nvar,optn.prob);
else
    probfi=optn.probfi;
end

% sort into order of variables then number of variables in equations
[vars,indx1]=sortrows(vars);
ssq=ssq(indx1);
nvars=sum(vars~=0,2);
[nvars,indx2]=sort(nvars);
vars=vars(indx2,:);
ssq=ssq(indx2);

% indices for groups of equations with same number of variables
j=1;
indvars=zeros(1,nvars(end)+1);
indvars(1)=1;
for i=1:length(nvars)
    while(nvars(i)>j-1)
        j=j+1;
        indvars(j)=i;
    end
end
indvars(j+1)=length(nvars)+1;
%ind=[0;find(diff(nvars));length(nvars)]+1;
endind=length(indvars);

indremove=false(length(ssq),1);
mvars=max(vars(:));
ssqratio=Inf(1,mvars);
ssqnbr=zeros(1,mvars);

% loop from most terms first
for i=endind:-1:3
    i0=indvars(i-2);
    i1=indvars(i-1)-1;
    i2=indvars(i-1);
    i3=indvars(i)-1;
    
    % mask to remove diagonal elements
    if(i3>0)
        nvarsi3=nvars(i3);
    else
        nvarsi3=0;
    end
    ind1=false(nvarsi3,nvarsi3);
    for k=1:nvarsi3
        ind1(k,k)=true;
    end
    
    % equations with one less variable
    vars01=vars(i0:i1,1:max(1,nvarsi3-1));
    
    % loop over equations of current size
    for j=i2:i3
        
        ssq0j=ssq(j);
        
        % remove variables one at a time
        t1=repmat(vars(j,1:nvarsi3),nvarsi3,1)';
        if(nvarsi3>1)
            t1(ind1)=[];
            t1=reshape(t1,nvarsi3-1,nvarsi3)';
        else
            t1=0;
        end
        
        % find matches with one variable less
        ib=zeros(nvarsi3,1);
        for k=1:nvarsi3
            ib(k)=binsearchrows(t1(k,:),vars01);
            vjk=vars(j,k);
            if(ib(k)>0)  % record maximum reduction in ssq
                ssqrat=ssq0j/ssq(ib(k)+i0-1)/probfi(nvarsi3);
                if(ssqrat<ssqratio(vjk))
                    ssqratio(vjk)=ssqrat;
                    ssqnbr(vjk)=nvarsi3;
                end
            else
                ssqratio(vjk)=1/optn.ssqratio/probfi(nvarsi3);
                ssqnbr(vjk)=nvarsi3;
            end
               
        end
        ib=ib(ib>0);
        %[~,~,ib]=intersect(t1,vars01,'rows'); too slow
        
        % test for better equation with one less variable
        if(~isempty(ib))
            ssq1=min(ssq(ib+i0-1));
%            ssq1=max(ssq0(ib+i0-1));
%            if(ssq1<ssq0(j)*1.03)  % replace with F-test ?
%            if(ssq1<ssq0(j)*(nerr-nvarsi3)/(nerr-nvarsi3-1))
            if(ssq1<ssq(j)/probfi(nvarsi3)^nvarsi3)
                indremove(j)=true;
            end
        end
        
    end
end

ssq(indremove)=[];
vars(indremove,:)=[];

varprob=ones(1,nvar);
ind=ssqnbr>0;
varprob(ind)=betainc(ssqratio(ind).*probfi(ssqnbr(ind)),  ...
    (nerr-ssqnbr(ind))/2,0.5);

return
end

    
