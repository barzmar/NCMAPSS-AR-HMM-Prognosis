function [AVectors, BVectors, counter] = calcAR_C(cruiseData,sensor_index, p, Window, Lag)
%preparing for while loop
L = length(cruiseData);
speed_index = 6;


counter = 0;

for f = 1 : L
    for c = 1 : length(cruiseData(f).flight)
        for i = 1 : Lag : length(cruiseData(f).flight(c).Value)-Window
            counter = counter + 1;
            % y = iddata(cruiseData(f).flight(c).Value(sensor_index, i:i+Window)', [], 1);
            y = cruiseData(f).flight(c).Value(sensor_index, i:i+Window)';
            u = cruiseData(f).flight(c).Value(speed_index, i:i+Window)';
            % tempModel = ar(y, p, 'ls'); % Assuming AR calculation on the second column
            tempModel = arx(u, y, [p 2 1]); % Assuming AR calculation on the second column
            AVectors(counter, :) = tempModel.A;
            BVectors(counter, :) = tempModel.B;
        end
    end
end
end