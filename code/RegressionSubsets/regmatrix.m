function [AA,nerr,w]=regmatrix(A,b,ind)
% regmatrix Calculate regression matrix for regression programs
%  2017-09-28  Matlab9.3  Copyright (c) 2017, W J Whiten  BSD License 
%
% [AA,nerr]=regmatrix(A,b,ind)
%  A    Matrix of columns of independent variables
%  b    Column vector ofr dependent variables
%  ind  Optional indicator, 1 for bootstrap sample
%        0 no weights, 1 weighted likelihood, 2 selection bootstrap
%        or a vector of weight values
%
%  AA   Matrix for use in regression programs
%  nerr Number of error terms in equation
%  w    Weights used in bootstrap
%
% If ind is 1 matrix is perturbed by a weighted likelihood values, and
%  if ind is 2 matrix is purturbed by classical selection bootstrap
%  These hould give variation in results typical of expected variation
%  from repeated data collection

nerr=size(b,1);
if(nerr~=size(A,1))
    error('regmatrix:  Sizes if A and b must agree')
end

if(nargin<3)
    ind=0;
elseif(length(ind)>1)
    w=ind(:);
    ind=3;
end

switch(ind)
    case(0)  % no random perturbation
    AA=[A,b]'*[A,b];
    w=[];

    case(1)  % apply weighted likelihood random perturbation
    %w=sqrt(diff([0,sort(rand(1,nerr-1)),1]));
    w=-log(rand(nerr,1));
    Abw=[A,b].*sqrt(w);
    AA=Abw'*Abw;
    
    case(2)  % apply clasic bootstrap random perturbation
        t=ceil(rand(nerr,1)*nerr);
        w=zeros(nerr,1);
        for i=1:nerr
            w(t(i))=w(t(i))+1;
        end
        Abw=[A,b].*sqrt(w);
        AA=Abw'*Abw;

    case(3)  % given weights
        Abw=[A,b].*w;
        AA=Abw'*Abw;
        
    otherwise
        error('regmatrix: ind argument not valid')
end

return
end
