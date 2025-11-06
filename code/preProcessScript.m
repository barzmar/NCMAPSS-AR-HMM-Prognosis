function ppCruiseData = preProcessFunction(unitsCruises)
    ppCruiseData = struct.empty;
    
    %removing empty flights (non cruises long enough)
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
                % ppCruiseData(j).flights(i).cruises(c).StdDiff = diff(ppCruiseData(j).flights(i).cruises(c).StdVal,1,2);
                % ppCruiseData(j).flights(i).cruises(c).MeanVal = mean(ppCruiseData(j).flights(i).cruises(c).Value(:,:), 2, "double");
            end
        end
    end
end

ppCruiseData = preProcessFunction(unitsCruises);