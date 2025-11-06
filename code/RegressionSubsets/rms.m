function a=rms(x,dim)
% rms  Calculate the root means square value of a vector
%  2017-09-28  Matlab9.3  Copyright (c) 2017, W J Whiten  BSD License 
%
% a=rms(x,dim)
%  x   Vector or matrix of data
%  dim Dimension to calculate rms over (optional)
%
%  a   Root mean square values of x

if(nargin<2)
    s=size(x);
    dim=find(s>1,1,'first');
    ps=prod(s);
    if(ps==1)
        dim=1;
    end
    if(isempty(dim) || ps==0)
        a=NaN;
        return
    end
end

a=sqrt(sum(x.^2,dim)/size(x,dim));

return
end
