function [buffered_data,rowNames] = data_table(data,unit,sensorIndexes,window,step,phase)
buffered_data = double.empty();
for f = 1 : 6
    temp_buffered_data = myBufferizeData(data(unit).flights(f).StdValue(:,:), sensorIndexes, window, step, phase)';
    buffered_data = horzcat(buffered_data, cell2mat(temp_buffered_data));
    clear temp_buffered_data
end

p = size(buffered_data, 1) - 1;
% PriorMdl = bayeslm(p,'ModelType', 'Lasso' , 'Intercept', false, 'Lambda', 5);
for i = 1 : size(buffered_data, 1)
    sensorNameIndex = sensorIndexes(floor((i-1)/(phase+1))+1);
    rowNames(i) = strcat(data(unit).flights(f).Name(sensorNameIndex), num2str(phase-mod(i-1,phase+1)));
end
end