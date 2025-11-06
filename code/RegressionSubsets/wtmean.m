function [wm,wsd,dist]=wtmean(x,sd,rpts)
% wtmean  Weighted mean with realistic standard deviation
%  2017-09-28  Matlab9.3  Copyright (c) 2017, W J Whiten  BSD License 
%
% [y,sd]=wtmean(x,sd,rpt)
%  x     Vector of values for mean to be calculated for
%  sd    Vector of standard deviations for each x value (default ones)
%  rpts  Number of repeats for bootstrap calculation (default 1000)
%
%  wm    Weighted mean value
%  wsd   Standard deviation for wm
%  dist  Distribution of wm if required
%         e.g. n=length(dist);plot(dist,(1:n)/(n+1))
%
% Calculation of standard deviation is non standard to cover cases:
%  wtmean([1 1 1],[10 10 10]) and wtmean([10 20 30],[1 1 1])
% dist is calculated by a parametric bootstrap adjusting values
%  according to a standard deviation calculated from both x and sd 

% set default values for missing arguments
if(nargin==1)
    sd=ones(size(x));
    rpts=1000;
elseif(nargin==2)
    if(length(sd)==1)
        rpts=sd;
        sd=ones(size(x));
    else
        rpts=1000;
    end
end

n=length(x);

% normallise by given weights and find weighted mean
wt=(1./(sd(:)+1e-100));
xw=x(:).*wt;
wm=wt\xw;

% add  variances from regression using sd and from scatter of x
v1=1/(wt'*wt);
stderr=std(wt*wm-xw);
v2=stderr^2*v1;
wsd=sqrt(v1+v2);

% fprintf('%9.4g %8.4g',sqrt(v1),sqrt(v2))

% generate bootstrap distribution of mean if required
if(nargout>2)
    dist=zeros(rpts,1);
    for i=1:rpts
        dist(i)=(wt)\((xw+randn(n,1)+stderr*randn(n,1)));
    end
    dist=sort(dist);
end

return
end
