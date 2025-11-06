function [x,xse,rse,L]=linfit(A,b)
% linfit  Linear regression, solves min((Ax-b)'*(Ax-b)) wrt A, for x
%  2013-07-28  Matlab8  Copyright (c) 2017, W J Whiten  BSD License 
%
% [x,xse,rse,L]=linfit(A,b)
%  A   Matrix of coefficients
%  b   Vector of right hand sides
%
%  x   Regression solution
%  xse Standard errors of solution
%  rse Standard error of residuals  sqrt(ssq/(nerr-nv))
%  L   Lower triangular Cholesky matrix L*L'==A'*A

[nerr,nv]=size(A);

L=chol(A'*A,'lower');
y=linsolve(L,A'*b,struct('LT',true));
x=linsolve(L',y,struct('UT',true));
ssq=max(0,b'*b-y'*y);

rse=sqrt(ssq/(nerr-nv));
xse=sqrt(sum(linsolve(L,eye(nv),struct('LT',true)).^2))'*rse;

return
end
