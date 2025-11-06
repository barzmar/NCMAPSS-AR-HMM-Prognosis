function [vars,ssq]=regsubsets(A,nerr,sel0,sel1,nvar,varargin)
% regsubsets  Best of all regression subsets up to size nvar
%  2017-09-28  Matlab9.3  Copyright (c) 2017, W J Whiten  BSD License 
%
% [ssq,vars]=regsubsets(A,sel0,sel1,nvar,nerr,optn)
%  A     Augmented normal matrix [X y]'*[X y]
%  nerr  Number of error terms used to form A
%  sel0  Row vector of variables to always include
%  sel1  Row vector of variables to select from
%  nvar   of variables to select from sel1 list
%  optn  (varargin) Struct or name,value pairs giving optional values
%         .wts   Row vector of length(sel0)+nvar weights (default [])
%         .prob  Probability of selecting random variable column (0.4)
%         .nsave Number of equations to save (default max 10000)
%
%  vars  Matrix with rows giving variables used
%  ssq   Vector of regression sum of squares
%
% The weights (.wts) can be given as a vector or are estimated from 
%  the given probability value (.prob). The probability is nominally
%  that of including an additional random predictor variable.

% progress message times
tocnbr=1;
toctab=[10,50,[2,7,20,30,60]*60];
%toctab=[10,50,[2,7,20,30,60]*60]/100;
tocnext=toctab(1);
ticvalue=tic;
cntmax=nbrequs(length(sel1),nvar);

% defaults for weights and number saved
optn=optndfts(varargin,'wts',[],'prob',0.4,'nsave',10000);
wts=optn.wts;
if(isempty(wts))
    wts=regwtfactors(length(sel0)+nvar,nerr,optn.prob);
end

% terms to select from
sel=[sel0,sel1];
nsel=length(sel0);
msel=length(sel);
nvar=nsel+nvar;
A=A([sel,end],[sel,end]);

% values for regression inputs
Ad=diag(A);
Ae=A(end,:);
Aee=Ae(end);

mL=msel+1;
L=zeros(mL,mL);

% variables for saving best results
ncrit=optn.nsave;
mcrit=2*ncrit;
crit=zeros(mcrit,1);
vars=zeros(mcrit,nvar);
if(nsel==0)
    crit(1)=Aee;
    icrit=1;
else
    icrit=0;
end
critmax=inf;

% loop through combinations
nvar=nvar-1;
seq=zeros(1,nvar);
iseq=1;
seq(1)=1;

cnt=0;
while(true)
    cnt=cnt+1;
    
    if(nvar==0)
        si=0;
        iseq=0;
    else
        % add one variable at a time
        si=seq(iseq);
        si1=seq(1:iseq-1);
        sse=si+1:mL;
        Li=L(si,si1);
        Lii=Ad(si)-Li*Li';
        if(Lii>0)
            Lii=sqrt(Lii);
        else
            Lii=1e100;
        end
        L(sse,si)=(A(si+1:end,si)-L(sse,si1)*Li')/Lii;
        L(si,si)=Lii;
        s1i=seq(1:iseq);
        Li=L(end,s1i);
        er=max(0,Aee-Li*Li');

        % calculate and save criteria
        tcrit=er/wts(iseq);
        if(tcrit<=critmax && iseq>=nsel)
            if(icrit==mcrit)
                [crit,indx]=sort(crit);
                vars=vars(indx,:);
                icrit=ncrit;
                critmax=crit(icrit);
                vars(icrit+1:end,:)=0;
            end
            if(tcrit<=critmax)
                icrit=icrit+1;
                crit(icrit)=tcrit;
                vars(icrit,1:iseq)=sel(seq(1:iseq));
            end
        end
    end

    if(iseq==nvar && (iseq==0 || seq(iseq)<msel))
        
        % add each of remaining variables individually
        si1m=si+1:msel;
        if(nvar==0)
            xer=max(0,Aee-(Ae(si1m)').^2./Ad(si1m));
        else
            Lpi=L(si1m,s1i); % end-1=p
            xer=max(0,er-(Ae(si1m)'-Lpi*Li').^2./  ...
                (Ad(si1m)-sum(Lpi.^2,2)));
        end
        for j=si1m
            
            %disp([xer(j-si),s1i,j])
    
            % calculate and save criteria
            tcrit=xer(j-si)/wts(iseq+1);
            if(icrit==mcrit)
                [crit,indx]=sort(crit);
                vars=vars(indx,:);
                icrit=ncrit;
                critmax=crit(icrit);
                vars(icrit+1:end,:)=0;
            end
            if(tcrit<=critmax)
                icrit=icrit+1;
                crit(icrit)=tcrit;
                vars(icrit,1:iseq+1)=sel([seq(1:iseq),j]);
            end
        end
    end
    
    % update sequence of solution
    if(iseq<nvar && seq(iseq)<msel)
        iseq=iseq+1;
        seq(iseq)=seq(iseq-1)+1;
    elseif(iseq==nvar && (iseq==0 || seq(iseq)<msel))
        if(iseq<=nsel);break;end
        seq(iseq)=seq(iseq)+1;
    else
        iseq=iseq-1;
        if(iseq<=nsel);break;end
        seq(iseq)=seq(iseq)+1;
    end
    
    % progress message
    if(toc(ticvalue)>tocnext)
        disp(['regsubsets Seconds ',sprintf('%#.1f',toc(ticvalue)),  ...
            '  Progress ',num2str(cnt),' of ',num2str(cntmax),  ...
            '  ',sprintf('%#.1f',100*cnt/cntmax),'%'])
        if(tocnbr<length(toctab))
        	tocnbr=tocnbr+1;
        end
        tocnext=tocnext+toctab(tocnbr);
    end
end

% sort criteria and truncate
[crit,indx]=sort(crit(1:icrit));
vars=vars(indx,:);

icrit=min(icrit,ncrit);
crit=crit(1:icrit);
vars=vars(1:icrit,:);

% convert crit back to ssq
mvars=sum(vars>0,2);
mvars(mvars==0)=1;
ssq=crit.*wts(mvars')';

return
end
