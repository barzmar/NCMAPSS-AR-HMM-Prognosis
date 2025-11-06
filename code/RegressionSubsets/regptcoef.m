function regptcoef(vars,coef,sdcoef,nbrs)
% regptcoef print summary of regresion equations
%  2017-09-28  Matlab9.3  Copyright (c) 2017, W J Whiten  BSD License 
%
% regptcoef(vars,coef,crit,nbrs)
% regptcoef(vars,coef,sdcoef,crit,nbrs)
%  vars   Matrix of variable numbers from regreorder
%  coef   Matrix ot coefficient values from regreorder
%  sdcoef Matrix of standard deviations of coefficients (optional)
%  nbrs   Row numbers to be printed or negative of number to print
%
%  Output is to screen

if(nargin==3)
    nbrs=sdcoef;
    sdcoef=[];
end

m=size(vars,1);

if(length(nbrs)==1 && nbrs<0)
    nbrs=1:min(-nbrs,m);
else
    nbrs=nbrs(:)';
end

nvars=sum(vars>0,2);
%sdres=sqrt(crit.ssq./(crit.nerr-nvars));

disp(' ')

for i=nbrs
    if(i>m)
        continue
    end
    for k=1:6:nvars(i)
        k1=min(nvars(i),k+5);
        if(k==1)
            fprintf('%5i:',i)
        else
            fprintf('      ')
        end
        for j=k:k1
            fprintf('%8i    ',vars(i,j))
        end
        if(k==1)
            fprintf('\n Coef')
        else
            fprintf('\n     ')
        end
        for j=k:k1
            fprintf('%#12.4g',coef(i,j))
        end
        fprintf('\n')
        if(~isempty(sdcoef))
            if(k==1)
                fprintf('  std ')
            else
                fprintf('      ')
            end
            for j=k:k1
                fprintf('%#12.4g',sdcoef(i,j))
            end
            fprintf('\n')
        end
    end
    
end

return
end