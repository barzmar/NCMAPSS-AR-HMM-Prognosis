clear;
close;


%Load data from file
filename = "C:\Users\speci\OneDrive\Documents\MATLAB\Thesis\dataNew\data_set\N-CMAPSS_DS07.h5";
file = load_NCMAPSS_struct(filename);
%reduce cumbersome structure from file into a vector of stucts
data = file.Datasets;

units = extractData_TableRow(data, [1,3,4]);

unitFlights = struct.empty(length(units), 0);
for u = 1 : length(units)
    flightsUnit = extractData_flights(units, u);
    unitFlights(u).flights = flightsUnit;

    numberFlights = length(flightsUnit);
    
    % Initialize intervals array
    tempCruise = 0;
    tempStart = 0;
    cruiseTimeSeries = struct.empty();
    
    
    for i = 1 : numberFlights
    
        [tempCruise, tempStart, tempFin] = extract_maxTimeSeries(flightsUnit(i).Value(5, :), 500);
        cruiseTimeSeries(i).Value = tempCruise;
        cruiseTimeSeries(i).StartIndexes = tempStart;
        cruiseTimeSeries(i).FinalIndexes = tempFin;
    end
    
    cruiseDATA = struct.empty();
    for i = 1 : numberFlights
        for j = 1 : length(cruiseTimeSeries(i).Value) 
            cruiseDATA(i).flight(j).Value = flightsUnit(i).Value( : , cruiseTimeSeries(i).StartIndexes(j) : cruiseTimeSeries(i).FinalIndexes(j));
            cruiseDATA(i).flight(j).Name = flightsUnit(i).Name;
        end
        
    end
    unitsCruises(u).cruiseData = cruiseDATA;
end

clear file filename numberFlights tempFin tempStart cruiseTimeSeries tempCruise;
