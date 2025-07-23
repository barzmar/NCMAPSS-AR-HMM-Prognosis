function outDistance = ItaSai(w1, w2)

N1 = length(w1);
N2 = length(w2);

if N1 == N2
    outDistance = 2/N1 * sum(w1./w2 - log(w1./w2) + w2./w1 - log(w2./w1)-2);
else
    error("Spectrums do not have the same length");
    return ;
end
end