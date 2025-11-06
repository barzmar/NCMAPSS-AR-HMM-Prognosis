function c=nbrequs(n,w)
% nbrequs  Number of regression equations  n variables, selecting upto w 
%  2017-09-28  Matlab9.3  Copyright (c) 2017, W J Whiten  BSD License 
%
% c=nbrequs(n,w)
%  n  Number of variables
%  w  Maximum number of variables to be selected
%
%  c  Count of number of equations from n variables selecting upto w
%
% Count is calculate from
%  c(n,w)=c(n-1,w-1)+c(n-1,min(n-1,w))+1
%  c(n,0)=0  c(0,v)=0  c(1,v)=1  c(n,1)=n

% table of solution values  debug info
% t1=ones(n,w);
% for i=2:n
%     t1(i,2:end)=t1(i-1,1:end-1)+t1(i-1,2:end)+1;
%     t1(i,1)=i;
% end
% t1(end,end)

% calculate from binomial coefficients
x=1;
if(w<=n/2)
    c=0;
    for i=1:w
        x=x*(n-i+1)/i;
        c=c+x;
        %t3(i)=c;
    end
else
    c=2^n-1;
    x=1;
    for i=1:n-w
        c=c-x;
        x=x*(n-i+1)/i;
        %t4(i)=c;
    end
end

return
end
