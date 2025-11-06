function probwt=regpvalues(nerr,nvar,prob)
% regprvalues  Probabilities for ssq comparison with one less parameters
%  2017-09-28  Matlab9.3  Copyright (c) 2017, W J Whiten  BSD License 
%
% probwt=regpvalues(nerr,nvar,prob)
%  nerr     Number of error terms in regression
%  nvar     Maximum number of variabless needed
%  prob     Probability to use
%
%  probwt   vector of probabilities to compare ssq with
%
% Power corrects for number of terms in regression
% Inverse of regwtfactors calculation

probwt=ones(1,nvar);
for i=2:nvar
    probwt(i)=betaincinv(prob^(i-1),(nerr-i+1)/2,1/2);
end

return
end
