clear data

for unit = [1,2,5,6,8]
    for f = 1 : length(unitsFlights(unit).flights)
        if exist("data","var")
            data = horzcat(data, unitsFlights(unit).flights(f).Value(:,:));
        else
            data = unitsFlights(unit).flights(f).Value(:,:);
        end
    end
end

row_mean = mean(data, 2);
rowStd  = std(data, 0, 2);