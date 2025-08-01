t = 0;
MatrixTest = double.empty;

test = struct.empty;

for i = 1 : length(ppCruiseData(unit).flights)
    for c = 1 : length(ppCruiseData(unit).flights(i).cruises)
        % signal = iddata(ppCruiseData(unit).flights(i).cruises(c).DDValue(sensor_index, :)', [], 1);
        output = [ppCruiseData(unit).flights(i).cruises(c).DDValue(sensor_index, :)'];
        input = [] ;% [ppCruiseData(unit).flights(i).cruises(c).Value(6, :)' ppCruiseData(unit).flights(i).cruises(c).Value(7, :)' ppCruiseData(unit).flights(i).cruises(c).Value(8, :)'];
        signal = iddata(output, input, 1);
        
        t = t +1;
        
        [test,  p, stat, cValue]= adftest(signal.OutputData);

        MatrixTest(t,:) = [test,  p, stat, cValue]; % Store the result of the adftest in the cellTable
    end
end