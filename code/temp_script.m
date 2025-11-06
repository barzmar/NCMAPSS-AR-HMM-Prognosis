nUnits = length(unitsFlights);
meansUnits = zeros(size(unitsFlights(1).flights(1).Value,1), nUnits);
for unit = 1 : nUnits
    nFlights = length(unitsFlights(unit).flights);
    temp = zeros(size(unitsFlights(1).flights(1).Value,1), nFlights);
    for f = 1 : nFlights
        temp(:,f) = mean(unitsFlights(unit).flights(f).Value, 2);
    end
    meansUnits(:, unit) = mean(temp,2);
end
meanTotal = mean(meansUnits,2)

for unit = 1 : nUnits
    nFlights = length(unitsFlights(unit).flights);
    temp = zeros(size(unitsFlights(1).flights(1).Value,1), nFlights);
    for f = 1 : nFlights
        temp(:,f) = std(unitsFlights(unit).flights(f).Value, 1, 2);
    end
    stdDevUnits(:, unit) = mean(temp,2);
end
stdDevTotal = mean(stdDevUnits,2)
