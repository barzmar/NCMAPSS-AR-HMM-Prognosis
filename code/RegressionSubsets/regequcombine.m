function [vars1,coef1,sdcoef1,sdres1,info1]=  ...
    regequcombine(vars0,coef0,sdres0,info0,varargin)
% equcombine  Combine multiple regression equations into one equation
%  2017-09-28  Matlab9.3  Copyright (c) 2017, W J Whiten  BSD License 
%
% [equcoef,equchol]=equcombine(coef,vars,varargin)
%  vars0    Variables as numbers for each regression equation
%  coef0    Matrix of coeficient rows
%  sdres0   Stardad error of residues
%  info0    Info from regreorder
%  wghts    Weight for each equation  (optional default ones)
%  nvars    Number of variables (optional default max(vars(:))
%            wghts, nvars can be given as name value pairs
%
%  vars1   Variables as numbers for combined regression equation
%  coef1   Row vector of equation coefficients
%  sdcoef1 Estimated standard deviations of coeficients
%  sdres1  Estimated standard deviation of residues of combined equation
%  info1   info1.chol{1} is lower Cholesky matrix for combined equation
%
% This function uses the results from regreorder as input

mequ=size(vars0,1);
nvars=max(vars0(:));

optn=optndfts(varargin,{'wghts','nvars'},  ...
    'wghts',ones(mequ,1),'nvars',nvars);
wghts=optn.wghts;
nvars=optn.nvars;
vars1=1:nvars;

sdres1=1/rms(1./sdres0(1:mequ));
wghts=(wghts(1:mequ)/sum(wghts(1:mequ)))./sdres0(1:mequ);
wghts=wghts/sum(wghts);

% add weighted coefficients and inverse normal matrices
coef1=zeros(1,nvars);
invmat=zeros(nvars,nvars);
varcnt=false(1,nvars);
for i=1:mequ
    mv=sum(vars0(i,:)>0);
    varsmv=vars0(i,1:mv);
    varcnt(varsmv)=true;
    coef1(varsmv)=coef1(varsmv)+wghts(i)*coef0(i,1:mv);
    invchol=inv(info0.chol{i});
    invmat(varsmv,varsmv)=invmat(varsmv,varsmv)+wghts(i)*  ...
        (invchol*invchol');
end

vars1=vars1(varcnt);
coef1=coef1(varcnt);

% L=inv(chol(invmat(varcnt,varcnt),'lower'));
L=linsolve(chol(invmat(varcnt,varcnt),'lower'),eye(sum(varcnt)),  ...
    struct('LT',true));
info1.chol={L};
sdcoef1=sqrt(sum(linsolve(L,eye(sum(varcnt)),struct('LT',true)).^2))  ...
    *sdres1;
            
return
end
