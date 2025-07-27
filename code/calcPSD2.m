function PSDhat = calcPSD2(newA, newB)
% excludedAR = newAR(2 : length(newA));
[h,w]=freqz(newB, newA , 1024);
PSDhat = (1/(1024)) * abs(h).^2;

% figure;
% plot(PSDhat);
end