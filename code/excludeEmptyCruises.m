function outputCruiseData = excludeEmptyCruises(unitsCruises, num_units,num_cruises)
arguments
    unitsCruises 
    num_units = "not_defined"
    num_cruises = "not_defined"
end

if isstring(num_units)
    num_units = length(unitsCruises);
    disp("Using all units of inputted data. num_units =" + num2str(num_units));
end

flag_num_cruises = isstring(num_cruises);
outputCruiseData = struct.empty;


for u = 1 : num_units
    cruise = unitsCruises(u).cruiseData;
    IndexNEmpty = 0;
    if flag_num_cruises
        cruise_index_max = length(cruise);
    else
        cruise_index_max = num_cruises;
    end
    i = 1;
    while i <= cruise_index_max
        try 
            while isempty(cruise(i + IndexNEmpty).cruise)
                IndexNEmpty = IndexNEmpty + 1;
            end
        catch exception
            disp("Error in EsitmateAR!!" + exception);
        end
        i = i + IndexNEmpty;
        outputCruiseData = vertcat(outputCruiseData, cruise(i));
        % outputCruiseData((u-1)*num_cruises + i) = cruise(i + IndexNEmpty);
        i = i + 1; % Increment the index to check the next cruise
        IndexNEmpty = 0;
    end

end
end