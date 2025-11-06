function [y,ysd]=regequvalue(x,vars,coef,sdres,lchol)
% regequvalue  Evaluate multiple linear regression equations at x
%  2017-09-28  Matlab9.3  Copyright (c) 2017, W J Whiten  BSD License 
%
% [y,sd]=regequvalue(x,coef,var,sdres,lchol)
%  x     Full row vector or matrix of values to be used for evaluation
%  vars  Matrix rows giving index of selected coefficients
%  coef  Matrix with rows of selected coefficients
%  sdres Vector of standard errors for equation residues (for sd calc)
%  lchol Cell array of lower triangular Cholesky factors (for sd calc)
%
%  y     Matrix of equation values, rows from coef, columns from x
%  ysd   Matrix of standard errors, rows from coef, columns from x
%          var, sdres and lchol must be present for sd calc
%
% Rows in x become rows in y & sd  x(i,:) -> y(i,:) sd(i,:)
%  columns in y & sd correspond to the different equations from rows in
%  vars coef sdres & lchol
%

m=size(x,1);
n=size(coef,1);

y=zeros(m,n);
ysd=zeros(m,n);

strLT=struct('LT',true);
for i=1:n
    n=sum(vars(i,:)>0);
    xvari=x(:,vars(i,1:n));
    y(:,i)=xvari*coef(i,1:n)';
    if(nargout>1)
        ysd(:,i)=sqrt(sum(linsolve(lchol{i},xvari',strLT).^2,1))*sdres(i)';
    end
end

return
end
