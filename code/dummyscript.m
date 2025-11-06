% load("C:\Users\speci\OneDrive\Documents\MATLAB\Thesis\NCMAPSS-AR-HMM-Prognosis\figures\ItaSaiDistances2Inputs\Variables\sensor22OutFieldDad_InFieldDad_param2  2_Integrate0_Phase0_Regul0.mat")
figure;
plot(ItaSaiDist);
title("ItaSaiDist");
figure;
hold on;
for i = 1:3
    plot(AVectors(:,1,i));
    title("Avectors");
end

test = cell2mat(BVectors);
figure;
hold on;
for i = 1:2
    plot(test(:,i,2));
    title("WRA");
end
figure;
hold on;
for i = 1:2
    plot(test(:,i,1));
    title("Mach");
end