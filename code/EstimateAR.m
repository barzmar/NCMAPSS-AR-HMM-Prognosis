n_w = 30;
num_cruises = 30;
num_units = 1;
healthyCruiseData = struct.empty;

healthyCruiseData = excludeEmptyCruises(unitsCruises, num_units);

sensor_index = 12; %sensor to use ( from 9 to 22)
p = 10; %number of parameters (found by analysing FPE, MDL, AIC graph)

% : amount of sample per AR estimation Lag: overlap of window
Window = 400;
Lag = 20;

[AVectors, BVectors, counter] = calcAR_C(healthyCruiseData,sensor_index,p, Window, Lag);

% calculate average of the AR coeffiecients calculated
% the resulting coefiecients is AR model for healthy system.

newAR = sum(AVectors(1:n_w,:),1)/n_w;
newAR_model = idpoly(newAR);

figure;
hold on;
plot(1:1:counter, AVectors(:,2))
plot(1:1:counter, AVectors(:,3))
plot(1:1:counter, AVectors(:,4))
plot(1:1:counter, AVectors(:,5))
% plot(1:1:counter, AVectors(:,6))
% plot(1:1:counter, AVectors(:,7))
% plot(1:1:counter, AVectors(:,8))
% plot(1:1:counter, AVectors(:,9))
% plot(1:1:counter, AVectors(:,10))
% plot(1:1:counter, AVectors(:,11))
plot(1:1:counter, BVectors(:,2))
plot(1:1:counter, BVectors(:,3))
% plot(1:1:counter, BVectors(:,4))
% plot(1:1:counter, BVectors(:,5))