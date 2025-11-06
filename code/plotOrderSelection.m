step = 100;
maxOrder = 20;
indexSensor = 11;
flightsToExamine = 30;
for unit = 1 : 9
    for i = 1 : 5
        for c = 1 : length(ppCruiseData(unit).flights(i).cruises)
            % signal = iddata(ppCruiseData(unit).flights(i).cruises(c).DDValue(sensor_index, :)', [], 1);
            temp = getfield(ppCruiseData, {unit}, 'flights', {i}, 'cruises', {c}, fieldOutput);
            
            output = [temp(sensor_index, 1:end)'];
            % mach_filtered = lowpass(ppCruiseData(unit).flights(i).cruises(c).Dad(6, :), 0.05, 1);  % Choose a reasonable cutoff
            if ~strcmp(fieldInput, 'None')
                temp = getfield(ppCruiseData, {unit}, 'flights', {i}, 'cruises', {c}, fieldInput);
    
                input = [temp(5,:)' temp(7, :)' ];
            end
            signal = iddata(output, input, 1);
    
            % ESTIMATION
            INDICATORS = ModelOrderSelection(signal, maxOrder,  flightsToExamine, indexSensor);
        end

    end
end



h1 = figure; 
h2 = figure; 
h3 = figure;

x = 1 : 1 : maxOrder;

for c = 1 : length(INDICATORS)
    
    figure(h1);
    hold on;
    plot(x, INDICATORS(c).OrderIndicator(1, :), 'DisplayName', ['AIC--c' num2str(c)]);
    xlabel('Model Order');
    ylabel('AIC');
    title('AIC vs Model Order');
    legend;
    
    
    
    figure(h2);
    hold on;
    plot(x, INDICATORS(c).OrderIndicator(2, :), 'DisplayName', ['FPE--c' num2str(c)]);
    xlabel('Model Order');
    ylabel('FPE');
    title('FPE vs Model Order');
    legend;
    
    figure(h3);
    hold on;
    plot(x, INDICATORS(c).OrderIndicator(3, :),'DisplayName', ['MDL--c' num2str(c)]);
    xlabel('Model Order');
    ylabel('MDL');
    title('MDL vs Model Order');
    legend;
end