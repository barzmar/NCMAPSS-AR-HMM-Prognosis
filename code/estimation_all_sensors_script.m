function EstimateAR_p10(ppCruiseData, sensor_index)

n_w = 50;
num_cruises = 30;

total_counter = 0;

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
        output = [ppCruiseData(unit).flights(i).cruises(c).Dad(sensor_index, 1:end)'];
        % mach_filtered = lowpass(ppCruiseData(unit).flights(i).cruises(c).Dad(6, :), 0.05, 1);  % Choose a reasonable cutoff
        
        input = [ppCruiseData(unit).flights(i).cruises(c).Dad(7, :)'];
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

% Create folder name based on current date and sensor index
folderName = fullfile('..', 'figures', sprintf('Estimation%d%d%d_parameters%d_OutDadInDad', ...
    day(datetime('now')), month(datetime('now')), year(datetime('now')), p));
if ~exist(folderName, 'dir')
    mkdir(folderName);
end

% Save the current figure
saveas(gcf, fullfile(folderName, sprintf('sensorIndex%dparameters%d.png', sensor_index, p)));

% Close the figure
close(gcf);

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

end


for in = 9:22
    EstimateAR_p10(ppCruiseData, in);
end