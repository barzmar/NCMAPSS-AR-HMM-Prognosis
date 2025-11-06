unit = 10;

varMeanMatrix = zeros(22,1);
for f = 1 : length(ppCruiseData(unit).flights)
    for c = 1 : length(ppCruiseData(unit).flights(f).cruises)
        temp = ppCruiseData(unit).flights(f).cruises(c).MeanVal(:);

        varMeanMatrix = horzcat(varMeanMatrix, temp);
    end

end

varMeanMatrix(:, 1) = [];