n_w = 30;
num_cruises = 30;
num_units = 1;

total_counter = 0;

sensor_index = 11; %sensor to use ( from 9 to 22)
p = 2; %number of parameters (found by analysing FPE, MDL, AIC graph)


ppCruiseData = struct.empty;

for i = 1 : length(unitsCruises)
        ppCruiseData(i).flights = removeEmptyElements(unitsCruises(i).flights);
end



% ppCruiseData = excludeEmptyCruises(unitsCruises, num_units);

%detrend and difference my data
for j = 1 :length(ppCruiseData)
    for i = 1:length(ppCruiseData(j).flights)
        for c = 1 : length(ppCruiseData(j).flights(i).cruises)
            ppCruiseData(j).flights(i).cruises(c).DValue(sensor_index, :) = detrend(ppCruiseData(j).flights(i).cruises(c).Value(sensor_index, :));
            ppCruiseData(j).flights(i).cruises(c).DDValue(sensor_index, :) = diff(ppCruiseData(j).flights(i).cruises(c).DValue(sensor_index, :));
            ppCruiseData(j).flights(i).cruises(c).DValue(6, :) = detrend(ppCruiseData(j).flights(i).cruises(c).Value(6, :));
            ppCruiseData(j).flights(i).cruises(c).DDValue(6, :) = diff(ppCruiseData(j).flights(i).cruises(c).DValue(6, :));
        end
    end
end



% : amount of sample per AR estimation Lag: overlap of window
Window = 400;
Lag = 20;
unit = 1;
AVectors = double.empty;
BVectors = double.empty;
for i = 1 : length(ppCruiseData(unit).flights)
    for j = 1 : length(ppCruiseData(unit).flights(i).cruises)
        signal = iddata(ppCruiseData(unit).flights(i).cruises(c).DDValue(sensor_index, :)', [], 1);
        signal = iddata(ppCruiseData(unit).flights(i).cruises(c).DDValue(sensor_index, :)', ppCruiseData(unit).flights(i).cruises(c).DDValue(6, :)' , 1);
        [temp_AVectors, temp_BVectors, counter] = calcAR_C(signal, p, Window, Lag);
    end
    AVectors = vertcat(AVectors, temp_AVectors);
    BVectors = vertcat(BVectors, temp_BVectors);
    total_counter = total_counter + counter;
end
% calculate average of the AR coeffiecients calculated
% the resulting coefiecients is AR model for healthy system.

% newAR = sum(AVectors(1:n_w,:),1)/n_w;
% newAR_model = idpoly(newAR);

figure;
hold on;
plot(1:1:total_counter, AVectors(:,2))
plot(1:1:total_counter, AVectors(:,3))
plot(1:1:total_counter, AVectors(:,4))
plot(1:1:total_counter, AVectors(:,5))
% plot(1:1:counter, AVectors(:,6))
% plot(1:1:counter, AVectors(:,7))
% plot(1:1:counter, AVectors(:,8))
% plot(1:1:counter, AVectors(:,9))
% plot(1:1:counter, AVectors(:,10))
% plot(1:1:counter, AVectors(:,11))
% plot(1:1:counter, BVectors(:,2))
% plot(1:1:counter, BVectors(:,3))
% plot(1:1:counter, BVectors(:,4))
% plot(1:1:counter, BVectors(:,5))