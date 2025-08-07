for k = 5 : 22
    figure;
    hold on;
    for i = 1 : 3
        for j = 1 : length(unitsCruises(1).flights(i).cruises)
        
        plot(unitsCruises(1).flights(i).cruises(j).Value(k, :));
        end
    end
end