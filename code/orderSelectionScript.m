unit = 1;
sensor_index = [];
output = [];
input = [];

max_order = 20;

counter = 0;


fieldOutput = 'StdVal';
fieldInput = 'StdVal';

for sensor_index = 9:22
    modelOrder = {};
    for i = 1 : 3
        for c = 1 : length(ppCruiseData(unit).flights(i).cruises)
            output = [];
            input = [];

            
            temp = getfield(ppCruiseData, {unit}, 'flights', {i}, 'cruises', {c}, fieldOutput);
            output = [temp(sensor_index,1:end)'];
            temp = getfield(ppCruiseData, {unit}, 'flights', {i}, 'cruises', {c}, fieldInput);
            input = [temp(7, 1:end)'];
            signal = iddata(output, input, 1);
            INDICATORS_temp = ModelOrderSelection(signal, max_order, [false], 1);
    
            % Store the selected model order for each cruise
            if isempty(modelOrder)
                modelOrder = INDICATORS_temp;
            else
                for l = 1:3
                    modelOrder{1,l} = horzcat(modelOrder{1,l}, INDICATORS_temp{1,l}); % Append the selected model order
                end
            end
        end
    end

    
% Define the directory path
dirPath = fullfile('..', 'ModelOrder010-1inputs', '');
if ~exist(dirPath, 'dir')
    mkdir(dirPath); % Create the directory if it does not exist
end

% Save the model order variable
fileName = sprintf('MO_sensorIndex%d_Out%sIn%s.mat', sensor_index, fieldOutput, fieldInput);
save(fullfile(dirPath, fileName), 'modelOrder');

end