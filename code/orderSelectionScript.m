unit = 1;
sensor_index = 12;
output = [];
input = [];

max_order = 50;

counter = 0;
modelOrder = {};
for i = 1 : 10
    for c = 1 : length(ppCruiseData(unit).flights(i).cruises)
        output = [];
        input = [];
        output = [ppCruiseData(unit).flights(i).cruises(c).Dad(sensor_index, 2:end)'];
        % input = [ppCruiseData(unit).flights(i).cruises(c).Dad(6, :)'];
        signal = iddata(output, input, 1);
        INDICATORS_temp = ModelOrderSelection(signal, max_order);

        % Store the selected model order for each cruise
        counter = counter +1;
        modelOrder{counter} = INDICATORS_temp;
    end
end

%plot each value
for i = 1 : size(modelOrder{1,1},1)
    fig(i) = figure(i);
    hold on;
    for j = 1 : length(modelOrder)
        modelOrderMat = cell2mat(modelOrder(j));
        plot(1:1:max_order, modelOrderMat(i,:));
    end

end

