function MDL = calcMDL(N,MSE,p)
% N number of samples
% MSE cost function result
% p number of parameters
MDL = N*log(MSE)+2*p*log(N);
end