unit = 1;
sensor_index = 20;
totalTimeSeries = [];

for sensor_index = 5 : 22
    temp_totalTimeSeries = [];
    for f = 1 : length(ppCruiseData(unit).flights)
        for c = 1 : length(ppCruiseData(unit).flights(f).cruises)
                temp_totalTimeSeries = horzcat(temp_totalTimeSeries, ppCruiseData(unit).flights(f).cruises(c).d(sensor_index, :));

        end
    end
    if isempty(totalTimeSeries)
        totalTimeSeries = zeros(22,length(temp_totalTimeSeries));
    end
    totalTimeSeries(sensor_index, :) = temp_totalTimeSeries;
end
     
for i = 6 : 22
    figure;
    subplot(2,1,1);
    plot(totalTimeSeries(5,:));
    title([strcat('Sensor Index: ', num2str(5)),strcat( 'Sensor Name: ', ppCruiseData(unit).flights(1).cruises(1).Name(5))]);
    xlabel('Time');
    ylabel('Altitude (ft)');
    subplot(2,1,2);
    plot(totalTimeSeries(i,:));
    title([strcat('Sensor Index: ', num2str(i)),strcat( 'Sensor Name: ', ppCruiseData(unit).flights(1).cruises(1).Name(i))]);
    xlabel('Time');
    ylabel('Value');
end