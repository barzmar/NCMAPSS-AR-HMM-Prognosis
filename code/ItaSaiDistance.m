n_w = 100;
PSDhat = calcPSD(newAR);
figure;
hold on;
plot(PSDhat);
for i = n_w+1 : length(AVectors)
    tempAVector = sum(AVectors(i-n_w:i-1, :), 1)/n_w;
    
    PSDtemp = calcPSD(tempAVector);
    PSDVector(:, i-n_w) = PSDtemp;
    % ItaSai of PSDtempA and PSDHat
    ItaSaiVector(i-n_w) = ItaSai(PSDhat, PSDtemp);
end

figure;
plot(ItaSaiVector);
% 
% for i = n_w+1 : length(AVectors)
%     tempAVector = sum(AVectors(i-n_w:i-1, :), 1)/n_w;
% 
%     PSDtemp = calcPSD2(AVectors(i,:), BVectors(i, :));
%     PSDVector(:, i-n_w) = PSDtemp;
%     % ItaSai of PSDtempA and PSDHat
%     ItaSaiVector(i-n_w) = ItaSai(PSDhat, PSDtemp);
% end
% 
% figure;
% plot(ItaSaiVector);