function [prob,ssq0]=regssqprob(vars,ssq,nerr,varargin)
% regssqprob  Estimated probabilityies based on sum of squared residues
%  2017-09-28  Matlab9.3  Copyright (c) 2017, W J Whiten  BSD License 
%
% prob=regssqprob(vars,ssq,nerr)
%  vars   Matrix of rows giving variable in each equation
%  ssq    Vector of sum of squared errors for each equation
%  nerr   Number of error terms
%  optn   (varargin) Struct or name,value pairs giving optional values
%          .maxprob  Probabiliy for smallest non zero ssq
%          .ssq0     Alternative to calculated base sum of squares
%
%  prob   Vector of 0 to 1 values with 1 indicating good values
%  ssq0   Calculated base sum of squares for F-test clculation
%
%  Prob vector values depend on ssq0 value calculated from maxprob 
%   (default 0.95) or given directly.
%  For larger number of errors prob values are very sensive to small 
%   changes in sum of squares and ssq0.
%  Unless repeat data values are available actual equation probabilities 
%   can not be calculated

optn=optndfts(varargin,'maxprob',0.99,'ssq0',[]);
nvars=sum(vars>0,2);

if(isempty(optn.ssq0))
    % find smallest sum of squares not zero
    [ssqmin,indmin]=min(ssq);
    if(ssqmin<=0)
        indzero=ssq<=0;
        ssq(indzero)=NaN;
        [ssqmin,indmin]=min(ssq);
        ssq(indzero)=0;
    end
    
    % back calculate base ssq for comparison, ie for no predictors
    nvarmin=nvars(indmin);
    ssq0=ssqmin/betaincinv(optn.maxprob,(nerr-nvarmin)/2,nvarmin/2,  ...
        'upper');

else
    ssq0=optn.ssq0;
end

% estimate probabilities for remaining ssq
prob=betainc(min(ssq/ssq0,1),(nerr-nvars)/2,nvars/2,'upper');

return
end
