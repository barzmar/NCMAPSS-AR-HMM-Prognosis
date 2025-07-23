sens_index = 6;

figure
hold on
for i = 1 : 10
    plot(unitsCruises(1).cruiseData(i).flight.Value(sens_index,:), DisplayName=unitsCruises(1).cruiseData(i).flight.Name(sens_index) + num2str(i) );
end 
legend;

figure;
hold on;
for i = 1 :10
    plot(unitFlights(1).flights(i).Value(sens_index,:), DisplayName=unitsCruises(1).cruiseData(i).flight.Name(sens_index) + num2str(i));
end
legend;