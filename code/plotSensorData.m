L = 10;
D_cov= diag(cov_sensor);

myFolder = ".\figures\SensorData\TopCov\";
if ~exist(myFolder, 'dir')
    mkdir(myFolder);
end

for i = 1 : L
    f = figure(Visible="off");
    [a,argMax] = max(D_cov);
    D_cov(argMax) = 0; 
    
    plot(time_data, sensor_data(:, argMax));
        
    title("Sensor " +  argMax + " - " + num2str(i) + "° in Max Covariance");
    xlabel("Sample");
    ylabel("Sensor Value");
    grid on;
    
    savefig(myFolder + num2str(i) + "sensor" + argMax);
    saveas(f, myFolder + num2str(i) + "sensor" + argMax, "png");
end