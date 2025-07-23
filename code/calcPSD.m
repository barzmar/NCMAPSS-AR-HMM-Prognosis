function PSDhat = calcPSD(newAR)
excludedAR = newAR(2 : length(newAR));
[h,w]=freqz(1, PSDhat , 1024);
PSDhat = (1/(1024)) * abs(h).^2;

% figure;
% plot(PSDhat);
end