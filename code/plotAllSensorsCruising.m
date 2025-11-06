unit = 1;
f=59;
c=1;
for k = 5 : 22
    figure;
    subplot(2,1,1);
    plot(ppCruiseData(unit).flights(f).cruises(c).Value(k,:));
    title([strcat('Sensor Index: ', num2str(k)),strcat( 'Sensor Name: ', ppCruiseData(unit).flights(1).cruises(1).Name(k))]);
    xlabel('Time');
    ylabel('Value');
    subplot(2,1,2);
    plot(ppCruiseData(unit).flights(f).cruises(c).d(k,:));
    title([strcat('Sensor Index: ', num2str(k)),strcat( 'Sensor Name: ', ppCruiseData(unit).flights(1).cruises(1).Name(k))]);
    xlabel('Time');
    ylabel('Differenced Value');
end