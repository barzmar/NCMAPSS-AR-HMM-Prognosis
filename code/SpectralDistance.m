function [specdist,specdistvec] = SpectralDistance(S1,S2)

% SpectralDistance(A1,B1,var1,A2,B2,var2) computes the symmetric Itakura-Saito  
% spectral distance between two AR or ARMA models

Nf=length(S1);    
ratioS12=S1./S2;
ratioS21=S2./S1;

rappS=ratioS12;

% specdist=(1/Nf)*sum(log(rappS).^2); % Log spectral distance
% specdist=(1/Nf)*sum(rappS-log(rappS)-ones(Nf,1));

specdist=(1/(Nf))*sum(ratioS12-log(ratioS12)+ratioS21-log(ratioS21)-ones(Nf,1)*2); % CosHdistance
specdistvec=ratioS12-log(ratioS12)+ratioS21-log(ratioS21)-ones(Nf,1)*2; % CosH freq-by-freq

%specdist=(1/Nf)*sum(S1.*log(rappS)-S1+S2);

end