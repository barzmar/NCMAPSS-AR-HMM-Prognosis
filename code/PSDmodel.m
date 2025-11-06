function [Sf,freq] = PSDmodel(num,den,var,Nf,fs)
% [Sf,freq] = PSDmodel(num,den,var,Nf) computes the PSD of the AR model described by
% num, den and var. Nf is the number of frequency points, fs is the
% sampling frequency

[H omega]=freqz(num,den,Nf,fs);
H=abs(H);
%Sf=2*var*H.^2;
Sf=var*H.^2;
freq=omega;

end

