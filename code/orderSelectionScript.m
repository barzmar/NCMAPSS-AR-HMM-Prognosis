unit = 1;
sensor_index = 12;
output = [];
input = [];

max_order = 50;

counter = 0;
modelOrder = {};
for i = 1 : 3
    for c = 1 : length(ppCruiseData(unit).flights(i).cruises)
        output = [];
        input = [];
        output = [ppCruiseData(unit).flights(i).cruises(c).Dad(sensor_index, 1:end)'];
        input = [ppCruiseData(unit).flights(i).cruises(c).Dad(7, :)'];
        signal = iddata(output, input, 1);
        INDICATORS_temp = ModelOrderSelection(signal, max_order, [false]);

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

%plot each value
for i = 1 : size(modelOrder,2)
    fig(i) = figure(i);
    hold on;
    for j = 1 : size(modelOrder{1,1}, 2)
        plot(1:1:max_order, modelOrder{1,i}(:, j));

    end

end

