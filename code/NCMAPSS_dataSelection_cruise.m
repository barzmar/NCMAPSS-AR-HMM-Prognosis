%% 
clear;
% close;


%Load data from file
filename = "C:\Users\speci\OneDrive\Documents\MATLAB\Thesis\NCMAPSS-AR-HMM-Prognosis\dataNew\data_set\N-CMAPSS_DS07.h5";
file = load_NCMAPSS_struct(filename);
%reduce cumbersome structure from file into a vector of stucts
data = file.Datasets;

units = extractData_TableRow(data, [1,3,4]);

unitsFlights = struct.empty(length(units), 0);
for u = 1 : length(units)
    flightsUnit = extractData_flights(units, u);
    unitsFlights(u).flights = flightsUnit;

    numberFlights = length(flightsUnit);
    
    % Initialize intervals array
    tempCruise = 0;
    tempStart = 0;
    cruiseTimeSeries = struct.empty();
    
    
    % for i = 1 : numberFlights
    % 
    %     [tempCruise, tempStart, tempFin] = extract_maxTimeSeries(flightsUnit(i).Value(5, :), 400, 0.0015);
    %     cruiseTimeSeries(i).Value = tempCruise;
    %     cruiseTimeSeries(i).StartIndexes = tempStart;
    %     cruiseTimeSeries(i).FinalIndexes = tempFin;
    % end
    % 
    % cruiseDATA = struct.empty();
    % for i = 1 : numberFlights
    %     for j = 1 : length(cruiseTimeSeries(i).Value) 
    %         cruiseDATA(i).cruise(j).Value = flightsUnit(i).Value( : , cruiseTimeSeries(i).StartIndexes(j) : cruiseTimeSeries(i).FinalIndexes(j));
    %         cruiseDATA(i).cruise(j).Name = flightsUnit(i).Name;
    %     end
    % 
    % end
    % unitsCruises(u).flights = cruiseDATA;


    for i = 1 : numberFlights
        y = unitsFlights(u).flights(i).Value(5, :);
        temp_intervals = findCruiseIntervals(y, 15, 1.0, 415);
        for j= 1:size(temp_intervals,1)
        unitsCruises(u).flights(i).cruises(j).Value = unitsFlights(u).flights(i).Value( : , temp_intervals(j,1) : temp_intervals(j,2));
        unitsCruises(u).flights(i).cruises(j).Name = unitsFlights(u).flights(i).Name;
        end
    end
end

clear file filename numberFlights tempFin tempStart cruiseTimeSeries tempCruise;
