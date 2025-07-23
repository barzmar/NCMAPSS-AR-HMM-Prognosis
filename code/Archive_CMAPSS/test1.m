%[text] Load data from "data" directory:
%Load data from data directory
data = load('data\train_FD001.txt');
names = ["unit" "time" "altitude" "mach" "TRA" "T2" "T24" "T30" "T50" "P2" "P15" "P30" "Nf" "Nc" "epr" "Ps30" "phi" "NRf" "NRc" "BPR" "farB" "htBleed" "Nf_dmd" "PCNfR_dmd" "W31" "W32"];
% Convert the loaded data into a table with appropriate variable names
dataTable = array2table(data, 'VariableNames', names);

%preliminary operation to divide the units from eachother
maxUnit = max(dataTable.unit);
array_unitData = cell(maxUnit, 1);

%prepare figure
figure;
hold on;
title('Nc vs Time for Each Unit');
xlabel('Time');
ylabel('Nc');
grid on;
% legend('show');

for i=1:maxUnit
    unitData = dataTable(dataTable.unit == i, :);
    array_unitData{i} = unitData; % Store the unit data in the cell array
    % array_unitData = array_unitData(i);
    plot(unitData, "time", "Nc");
end

hold off;
%[text] Calculating statistics for unitData:
%extract data from table to array
time_data = table2array(unitData(:,2));
sensor_data = table2array(unitData(:,6:26));


mean_array = mean(sensor_data);
cov_sensor = cov(sensor_data);

% Display the mean and covariance results
disp('Mean of sensor data:'); %[output:975e711f]
disp(mean_array); %[output:8cab7b0f]
disp('Covariance of sensor data:'); %[output:873dd146]
disp(cov_sensor); %[output:6658eb50]
% D_cov= diag(cov_sensor);
% for i = 1 : 10
%     figure;
%     [a,argMax] = max(D_cov);
%     D_cov(argMax) = 0; 
%     title(['Sensor Data for Sensor ' num2str(i) ' - Max Covariance']);
%     xlabel('Time');
%     ylabel('Sensor Value');
%     grid on;
%     plot(time_data, sensor_data(:, argMax));
% end
% 
% hold off;


%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright","rightPanelPercent":29.1}
%---
%[output:975e711f]
%   data: {"dataType":"text","outputData":{"text":"Mean of sensor data:\n","truncated":false}}
%---
%[output:8cab7b0f]
%   data: {"dataType":"text","outputData":{"text":"   1.0e+03 *\n\n    0.5187    0.6427    1.5917    1.4103    0.0146    0.0216    0.5531    2.3881    9.0641    0.0013    0.0476    0.5213    2.3881    8.1426    0.0084    0.0000    0.3936    2.3880    0.1000    0.0388    0.0233\n\n","truncated":false}}
%---
%[output:873dd146]
%   data: {"dataType":"text","outputData":{"text":"Covariance of sensor data:\n","truncated":false}}
%---
%[output:6658eb50]
%   data: {"dataType":"text","outputData":{"text":"    0.0000   -0.0000   -0.0000    0.0000   -0.0000   -0.0000   -0.0000    0.0000   -0.0000    0.0000   -0.0000    0.0000   -0.0000   -0.0000    0.0000   -0.0000    0.0000         0         0    0.0000    0.0000\n   -0.0000    0.2120    1.2624    2.2956    0.0000    0.0000   -0.2394    0.0158    0.7337   -0.0000    0.0747   -0.1992    0.0175   -0.0874    0.0088    0.0000    0.3243         0         0   -0.0542   -0.0263\n   -0.0000    1.2624   28.8149   27.3959    0.0000    0.0000   -2.8745    0.2118    7.2349   -0.0000    0.8730   -2.2167    0.2148   -1.5715    0.1080    0.0000    4.1017         0         0   -0.5834   -0.2953\n    0.0000    2.2956   27.3959   67.9990   -0.0000    0.0006   -5.2687    0.3735   13.8392    0.0000    1.6343   -4.2894    0.3941   -3.3453    0.2080   -0.0000    7.2856         0         0   -1.1227   -0.5543\n   -0.0000    0.0000    0.0000   -0.0000    0.0000    0.0000    0.0000   -0.0000    0.0000   -0.0000    0.0000   -0.0000    0.0000    0.0000   -0.0000    0.0000   -0.0000         0         0   -0.0000   -0.0000\n   -0.0000    0.0000    0.0000    0.0006    0.0000    0.0000   -0.0001    0.0000    0.0001   -0.0000    0.0000   -0.0001    0.0000   -0.0003    0.0000    0.0000    0.0000         0         0   -0.0000    0.0000\n   -0.0000   -0.2394   -2.8745   -5.2687    0.0000   -0.0001    0.7007   -0.0385   -1.4039   -0.0000   -0.1656    0.4311   -0.0388    0.3721   -0.0204    0.0000   -0.7769         0         0    0.1079    0.0603\n    0.0000    0.0158    0.2118    0.3735   -0.0000    0.0000   -0.0385    0.0035    0.0885    0.0000    0.0117   -0.0305    0.0028   -0.0342    0.0015   -0.0000    0.0514         0         0   -0.0082   -0.0041\n   -0.0000    0.7337    7.2349   13.8392    0.0000    0.0001   -1.4039    0.0885   22.3612   -0.0000    0.4681   -1.0367    0.0934    2.7852    0.0500    0.0000    2.3292         0         0   -0.2458   -0.1382\n    0.0000   -0.0000   -0.0000    0.0000   -0.0000   -0.0000   -0.0000    0.0000   -0.0000    0.0000   -0.0000    0.0000   -0.0000   -0.0000    0.0000   -0.0000    0.0000         0         0    0.0000    0.0000\n   -0.0000    0.0747    0.8730    1.6343    0.0000    0.0000   -0.1656    0.0117    0.4681   -0.0000    0.0612   -0.1356    0.0121   -0.0734    0.0065    0.0000    0.2328         0         0   -0.0339   -0.0189\n    0.0000   -0.1992   -2.2167   -4.2894   -0.0000   -0.0001    0.4311   -0.0305   -1.0367    0.0000   -0.1356    0.4424   -0.0323    0.3107   -0.0176   -0.0000   -0.6229         0         0    0.0918    0.0472\n   -0.0000    0.0175    0.2148    0.3941    0.0000    0.0000   -0.0388    0.0028    0.0934   -0.0000    0.0121   -0.0323    0.0038   -0.0257    0.0016    0.0000    0.0570         0         0   -0.0080   -0.0043\n   -0.0000   -0.0874   -1.5715   -3.3453    0.0000   -0.0003    0.3721   -0.0342    2.7852   -0.0000   -0.0734    0.3107   -0.0257   10.5344   -0.0108    0.0000    0.2263         0         0    0.0707    0.0170\n    0.0000    0.0088    0.1080    0.2080   -0.0000    0.0000   -0.0204    0.0015    0.0500    0.0000    0.0065   -0.0176    0.0016   -0.0108    0.0012   -0.0000    0.0291         0         0   -0.0044   -0.0022\n   -0.0000    0.0000    0.0000   -0.0000    0.0000    0.0000    0.0000   -0.0000    0.0000   -0.0000    0.0000   -0.0000    0.0000    0.0000   -0.0000    0.0000   -0.0000         0         0   -0.0000   -0.0000\n    0.0000    0.3243    4.1017    7.2856   -0.0000    0.0000   -0.7769    0.0514    2.3292    0.0000    0.2328   -0.6229    0.0570    0.2263    0.0291   -0.0000    1.9757         0         0   -0.1456   -0.0896\n         0         0         0         0         0         0         0         0         0         0         0         0         0         0         0         0         0         0         0         0         0\n         0         0         0         0         0         0         0         0         0         0         0         0         0         0         0         0         0         0         0         0         0\n    0.0000   -0.0542   -0.5834   -1.1227   -0.0000   -0.0000    0.1079   -0.0082   -0.2458    0.0000   -0.0339    0.0918   -0.0080    0.0707   -0.0044   -0.0000   -0.1456         0         0    0.0340    0.0119\n    0.0000   -0.0263   -0.2953   -0.5543   -0.0000    0.0000    0.0603   -0.0041   -0.1382    0.0000   -0.0189    0.0472   -0.0043    0.0170   -0.0022   -0.0000   -0.0896         0         0    0.0119    0.0106\n\n","truncated":false}}
%---
