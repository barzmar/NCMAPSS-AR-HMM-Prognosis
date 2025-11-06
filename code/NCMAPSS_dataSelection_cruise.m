%% 
clear;
% close;


%Load data from file
filename = "N-CMAPSS_DS02-006"; % file estension is concatenated later
full_filename = strcat("C:\Users\speci\OneDrive\Documents\MATLAB\Thesis\NCMAPSS-AR-HMM-Prognosis\dataNew\data_set\", filename, ".h5");
file = load_NCMAPSS_struct(full_filename);

%reduce cumbersome structure from file into a vector of stucts
data = file.Datasets;

units = extractData_TableRow(data, [1,3,4]);

clear data

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
for unit = 1 : length(unitsFlights)
    for f = 1 : length(unitsFlights(unit).flights)
        [r, c] = size(unitsFlights(unit).flights(f).Value(:,:));
        unitsFlights(unit).flights(f).StdValue = zeros([r,c]);
        unitsFlights(unit).flights(f).StdValue(:,:) =  standardizeTimeSeries(unitsFlights(unit).flights(f).Value(:,:), 1);
    end
end

    for i = 1 : numberFlights
        y = unitsFlights(u).flights(i).Value(5, :);
        temp_intervals = findCruiseIntervals(y, 15, 1.0, 815);
        for j= 1:size(temp_intervals,1)
        unitsCruises(u).flights(i).cruises(j).Value = unitsFlights(u).flights(i).Value( : , temp_intervals(j,1) : temp_intervals(j,2));
        unitsCruises(u).flights(i).cruises(j).StdValue = unitsFlights(u).flights(i).StdValue( : , temp_intervals(j,1) : temp_intervals(j,2));
        unitsCruises(u).flights(i).cruises(j).Name = unitsFlights(u).flights(i).Name;
        end
    end
end




%save flights
outputDirFlights = "..\dataNew\processed_data_sets\unitsFlight";
if ~exist(outputDirFlights, 'dir')
    mkdir(outputDirFlights);
end

save(strcat(outputDirFlights, "\unitsFlights-file" ,filename), "unitsFlights", "-v7.3");

%save cruises
outputDirCruises = "..\dataNew\processed_data_sets\unitsCruises";
if ~exist(outputDirCruises, 'dir')
    mkdir(outputDirCruises);
end

save(strcat(outputDirCruises, "\unitsCruises-file", filename), "unitsCruises", "-v7.3");

clear file full_filename numberFlights tempFin tempStart cruiseTimeSeries tempCruise;

%pre-processing data and inserting it into ppCruiseData in the workspace
preProcessScript;

clear flightsUnit unitsCruises y 
clear units
