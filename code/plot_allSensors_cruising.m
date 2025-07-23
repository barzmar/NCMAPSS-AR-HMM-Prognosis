
numberFlights = length(cruiseDATA);

index_firstSensor = 9;
index_lastSensor = 22;

flightsExamined = 10;

for j = index_firstSensor : index_lastSensor
    figure(j);
    sp1 = subplot(2, 1, 1); % Create a 2-row, 1-column subplot
    hold(sp1, "on");
    legend;
    sp2 = subplot(2, 1, 2); % Create a 2-row, 1-column subplot
    hold(sp2, "on");
    legend;
    for i = 1 : flightsExamined
        
        try
            first = cruiseDATA(i).flight(1).Value(j, :);
            last = cruiseDATA(numberFlights - i + 1).flight(1).Value(j, :);

            l_first = length(first);
            l_last = length(last);

            % Create the first subplot
            plot(sp1, 1:1:l_first, first, "DisplayName", "Cruise Flight" + num2str(i)); 
            title('First 7 Flights'); % Title for the first plot
            
            % Create the second subplot
            plot(sp2, 1:1:l_last, last, "DisplayName", "Cruise Flight" + num2str(numberFlights - i + 1)); 
            title('Last 7 Flights'); % Title for the second plot
        catch exception
            
        end
        
        
       
    end

end