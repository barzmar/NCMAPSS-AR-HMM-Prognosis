n_w = 50;
num_cruises = 30;

total_counter = 0;

sensor_index = 20; %sensor to use ( from 9 to 22)
p = 3; %number of parameters (found by analysing FPE, MDL, AIC graph)





% : amount of sample per AR estimation Lag: overlap of window
Window = 400;
Lag = 20;
unit = 1;
input = [];
output = [];
AVectors = double.empty;
BVectors = double.empty;
for i = 1 : length(ppCruiseData(unit).flights)
    for c = 1 : length(ppCruiseData(unit).flights(i).cruises)
        % signal = iddata(ppCruiseData(unit).flights(i).cruises(c).DDValue(sensor_index, :)', [], 1);
        output = [ppCruiseData(unit).flights(i).cruises(c).Value(sensor_index, 1:end)'];
        % mach_filtered = lowpass(ppCruiseData(unit).flights(i).cruises(c).Dad(6, :), 0.05, 1);  % Choose a reasonable cutoff
        
        input = [ppCruiseData(unit).flights(i).cruises(c).Value(7, :)'];
        signal = iddata(output, input, 1);

        % ESTIMATION
        [~, temp_AVectors, temp_BVectors] = calcAR_C(signal, p, Window, Lag, [false]);
    end
    AVectors = vertcat(AVectors, temp_AVectors);
    BVectors = vertcat(BVectors, temp_BVectors);
end
% calculate average of the AR coeffiecients calculated
% the resulting coefiecients is AR model for healthy system.

newAR = sum(AVectors(1:n_w,:),1)/n_w;
newAR_model = idpoly(newAR);

total_counter = length(AVectors);

figure;
hold on;
plot(1:1:total_counter, AVectors(:,2))
plot(1:1:total_counter, AVectors(:,3))
plot(1:1:total_counter, AVectors(:,4))

figure;
hold on;
plot(1:1:total_counter, BVectors(:,1))
plot(1:1:total_counter, BVectors(:,2))
plot(1:1:total_counter, BVectors(:,3))

% for j = 1 :size(BVectors,2)
%     for i = 1:length(BVectors)
%         temp = BVectors{i, j};
%         BVec(j, i,:) = temp;
%     end
%     figure;
%     hold on;
%     plot(1:1:total_counter, BVec(j, :, 2));
%     plot(1:1:total_counter, BVec(j, :, 3));
%     plot(1:1:total_counter, BVec(j, :, 4));
% end

