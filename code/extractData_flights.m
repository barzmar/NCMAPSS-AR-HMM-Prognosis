function flightsData4Unit = extractData_flights(data, unit)
    [start, fin] = findIntervalsSameValue(data, unit, 2);
    
    numberFlights = length(start);

    flightsData4Unit = struct.empty(numberFlights, 0);
    
    for i = 1 : 1 : numberFlights
        flightsData4Unit(i).Name = data(unit).Name;
        flightsData4Unit(i).Value = data(unit).Value(:, start(i):fin(i));
    end
end