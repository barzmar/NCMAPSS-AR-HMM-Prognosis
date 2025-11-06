function regptinfo(vars,coef,info,nbrs)
% regptinfo print summary of regresion equations
%  2017-09-28  Matlab9.3  Copyright (c) 2017, W J Whiten  BSD License 
%
% regptinfo(vars,coef,crit,nbrs)
%  vars   Matrix of variable numbers from regreorder
%  coef   Matrix ot coefficient values from regreorder
%  crit   Struct from regreorder
%  nbrs   Row numbers to be printed or negative of number to print
%
%  Output is to screen

m=size(vars,1);

if(length(nbrs)==1 && nbrs<0)
    nbrs=1:min(-nbrs,m);
else
    nbrs=nbrs(:)';
end

nvars=sum(vars>0,2);
sdres=sqrt(info.ssq./(info.nerr-nvars));

disp(' ')
disp(['  nbr       sdres    probssq  probcoef ',  ...
    'cholratio  Variables & sign'])

for i=nbrs
    if(i>m)
        continue
    end
    fprintf('%5i %#12.4g %#8.2f %#8.2f %#8.2f ',  ...
        i,sdres(i),info.probssq(i),info.probcoef(i),info.cholratio(i))
    for j=1:nvars(i)
        sign='+';
        if(coef(i,j)<0)
            sign='-';
        elseif(coef(i,j)==0)
            sign=' ';
        end
        fprintf('%5i%c',vars(i,j),sign)
    end
    fprintf('\n')
end

return
end
