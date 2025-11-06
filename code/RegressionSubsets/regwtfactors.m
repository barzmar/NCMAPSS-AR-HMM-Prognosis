function w=regwtfactors(nvar,nerr,prob)
% regwtfactors  Weight factor for comparing regression var with 1 to nvar
%  2017-09-28  Matlab9.3  Copyright (c) 2017, W J Whiten  BSD License 
%
% w=regwtfactors(nvar,nerr,prob)
%  nvar   Number of variables to calculate ratio for
%  nerr   Number of error terms in regression
%  prob   Probability level to reject random variables
%
%  w      Vector of weight values for increasing variable in regression
%
% For random variables
%  prob of SSQn/SSQn-1 being less than x is betainc(x,n/2,1/2)
%  so for a proportion of random samples p, x=betaincinv(p,n/2,1/2)
%  and proportion p of random SSQn/SSQn-1 are less than x
% This corresponds to adding a random variable to regression 
%  and thus the random ratio SSQn/SSQn-1 is less than x with proportion p
%
% Power added for the number of variables in the equation
% Inverse of regprvalues calculation

w=ones(1,nvar);
for i=2:nvar
    w(i)=betaincinv(prob,(nerr-i+1)/2,1/2)^i;
end

w=cumprod(w);

return
end
