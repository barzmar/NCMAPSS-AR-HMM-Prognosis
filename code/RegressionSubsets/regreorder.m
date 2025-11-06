function [vars,coef,sdcoef,sdres,info]=regreorder(A,nerr,vars,varargin)
% regreorder  Reorder regression candidates from regsubsets
%  2017-09-28  Matlab9.3  Copyright (c) 2017, W J Whiten  BSD License 
%
% z=regreorder(A,nerr,vars,nerr)
%  A     Augmented normal matrix [X y]'*[X y]
%  nerr  Number of error terms used to form A
%  vars  Matrix with term numbers in rows for selected regressions
%  optn  Optional values: struct or name value pairs
%         .maxout       Maximum number of output equations
%         .coefmin      Minimum value(s) for coefficients, 0 for +ve
%         .coefmax      Maximum value(s) for coefficients
%         .chol         Save Cholesky factors (default true)
%         .minprobssq   Probability for minimum sum of squared errors
%         .stderrratio  Ratio for rejecting larger error std
%         .probssqmin   Lower limit for ssq probability
%         .probcoefmin  Upper limit for coefficient probability
%         .cholratiomin Lower limit for cholration test
%         .ssqprob      Probability base for ssq probabilities
%
%  vars   Matrix with term numbers in rows
%  coef   Matrix with coefficients in rows sorted according to prob
%  sdcoef Standard errors for coefficients
%  sdres  Standard errors of residuals
%  info   Information on ordering criteria
%         .nerr      Number of error terms
%         .crit      Criteria for each eqution used to order equations
%         .ssq       Residue sum of squares for each equation
%         .probcoef  Probability for min t-ratio of coefficients
%         .cholratio Ratio smallest/largest of cholesky diagonal
%         .chol      Cell array of lower triangular Cholesky matrices
%
% Uses results from regsubsets as input
% Prediction for ith equations is coef(i,:)*x(vars(i,sum(vars(i,:)>0)), 
%  Standard deviation of prediction is sdr(i)*sqrt(sum(
%  linsolve(info.chol,x(vars(i,sum(vars(i,:)>0)),struct('LT',true)).^2)
% Probabilities at best are nominal

m=size(vars,1);

if(nargin<5)
    varargin=struct();
end

optn=optndfts(varargin,'maxout',1000,'ssqprob',0.99,  ...
    'coefmin',-Inf,'coefmax',Inf,'chol',true,'probssqmin',0,  ...
    'stderrratio',1.5,'probcoefmin',0.9,'cholratiomin',0.1);

nv=size(vars,2);

% number of variables in each equation and std of equation errors
nvars=sum(vars~=0,2);

% update critera for each equation
ssq=zeros(m,1);
coef=zeros(m,nv);
sdcoef=zeros(m,nv);
probcoef=zeros(m,1);
cholratio=zeros(m,1);
if(optn.chol)
    lchol=cell(m,1);
end

for i=1:m
    nvari=nvars(i);
    vari=vars(i,1:nvari);
    ndf=nerr-nvari;
    
    % solve for coefficients and their standard deviations
    if(nvari>0)
        try
            L=chol(A(vari,vari),'lower');
            t=diag(L);
            cholratio(i)=min(t)/max(t);
            t1=linsolve(L,A(vari,end),struct('LT',true));
            ssq(i)=A(end,end)-sum(t1.^2);
            x=linsolve(L',t1,struct('UT',true));
            sd1=sqrt(sum(linsolve(L,eye(nvari),  ...
                struct('LT',true)).^2)*ssq(i)/ndf);
        catch
            cholratio(i)=0;
            L=[];
            x=[];
            sd1=[];
        end
    else
        cholratio(i)=0;
        L=[];
        x=[];
        sd1=[];
    end
    
    if(optn.chol)
        lchol{i}=L;
    end
    coef(i,1:nvari)=x;
    sdcoef(i,1:nvari)=sd1;
    
    % probability for worst coefficient, note power of nvari
    if(any(x>optn.coefmax) || any(x<optn.coefmin) || nvari==0)
        probcoef(i)=-1;
    else
        t=min(abs(x./sd1'));
        t=t^2;
        probcoef(i)=betainc(t./(ndf+t),1/2,ndf/2)^nvari;
    end
    
end

% a nominal probability for sum of squared residuals
probssq=regssqprob(vars,ssq,nerr,'maxprob',optn.ssqprob);

% select on sdres probssq probcoef cholratio via options
sdres=sqrt(ssq./(nerr-nvars));
sdresmin=min(sdres);
if(sdresmin<=0)
    indzero=sdres<=0;
    sdres(indzero)=NaN;
    sdresmin=min(sdres);
    sdres(indzero)=0;
end
indsel=sdres<optn.stderrratio*sdresmin & probssq>=optn.probssqmin &  ...
    probcoef>=optn.probcoefmin & cholratio>=optn.cholratiomin;

% sort according to smallest sdres first then on number of terms
[~,ind1]=sort(sdres(indsel));
cnt=1:m;
cnt=cnt(indsel);
ind1=cnt(ind1);
[~,ind2]=sort(nvars(ind1));
ind=ind1(ind2);

% retain only those with small criteria
n=min(optn.maxout,length(ind));
ind=ind(1:n);

coef=coef(ind,:);
sdcoef=sdcoef(ind,:);
vars=vars(ind,:);
sdres=sdres(ind);

if(nargout>4)
    info.nerr=nerr;
    info.ssq=ssq(ind);
    info.probssq=probssq(ind);
    info.probcoef=probcoef(ind);
    info.cholratio=cholratio(ind);

    if(optn.chol)
        info.chol=lchol(ind(1:n));
    end

end

return
end
