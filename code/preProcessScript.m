function ppCruiseData = preProcessFunction(unitsCruises)
    ppCruiseData = struct.empty;
    
    for i = 1 : length(unitsCruises)
            ppCruiseData(i).flights = removeEmptyElements(unitsCruises(i).flights);
    end
    
    %detrend and difference my data
    for j = 1 :length(ppCruiseData)
        for i = 1:length(ppCruiseData(j).flights)
            for c = 1 : length(ppCruiseData(j).flights(i).cruises)
                ppCruiseData(j).flights(i).cruises(c).D = [];
                ppCruiseData(j).flights(i).cruises(c).d = [];
                ppCruiseData(j).flights(i).cruises(c).Dad = [];
                ppCruiseData(j).flights(i).cruises(c) = preprocessCruise(ppCruiseData(j).flights(i).cruises(c));
            end
        end
    end
end

ppCruiseData = preProcessFunction(unitsCruises);