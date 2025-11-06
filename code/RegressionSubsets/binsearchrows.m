function nx=binsearchrows(r,tab)
% binsearchrows  Binary search for matching row
%  2017-09-28  Matlab9.3  Copyright (c) 2017, W J Whiten  BSD License 
%
% n=binsearchrows(r,tab)
%  r   Row vector to be found
%  tab Matrix of rows
%
%  nx  Subscript of row found or -n if before nth row

if(isempty(r) || isempty(tab))
    nx=0;
    return
end
[m1,m2]=size(tab);

n1=0;
n2=m1+1;

indeq=false;
while(true)
    nx=floor((n1+n2)/2);
    %disp([n1,nx,n2])
    if(nx==n1)
        nx=-nx-1;
        break
    end
    for i=1:m2
        if(r(i)>tab(nx,i))
            n1=nx;
            break
        elseif(r(i)<tab(nx,i))
            n2=nx;
            break
        elseif(i==m2)
            indeq=true;
            break
        end
    end
    if(indeq)
        break
    end
end

return
end


% tab =[
%      1     2     6     0     0     0
%      1     3     8     0     0     0
%      1     4    10     0     0     0
%      2     3     9     0     0     0
%      2     4     7     0     0     0
%      3     4     5     0     0     0
% ]

% for i=1:6;t(i)=binsearchrows(tab(i,:),tab);end;t
% for i=1:6;t(i)=binsearchrows(tab(i,:)+[0 0 1 0 0 0],tab);end;t
% for i=1:6;t(i)=binsearchrows(tab(i,:)-[0 0 1 0 0 0],tab);end;t
