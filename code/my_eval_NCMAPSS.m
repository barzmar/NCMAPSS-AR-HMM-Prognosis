function frmse = my_eval_NCMAPSS(data, mdl, unit2, sensorIndexes, window, step, phase, predictorInd, halfFlights)


frmse = [];
for f2 = 1 : length(data(unit2).flights)
    
    if halfFlights
        window = floor((length(data(unit2).flights(f2).StdValue(sensorIndexes, :)) - phase)/2);
        step = window;
    end

    buffered_data_val = custom_buffer( ...
        data(unit2).flights(f2).StdValue(sensorIndexes, :), ...
        window, step, phase);

    % Mdl = fitlm(X_train,y_train);

    L_Buff = length(buffered_data_val);
    temp_frmse = zeros(L_Buff,1);

    for j = 1 : L_Buff
        X_val = [];
        X_1_val = [];
        y_val = [];
        y_1_val = [];
        X_val = buffered_data_val{j}(1:end-1,:);
        y_val = buffered_data_val{j}(end,:);
        
        
        
        X_val_test = [X_val(:,:)]';
        % X_val_test = standardizeTimeSeries(X_val_test)';
        
        
        y_val_test = [y_val]';
        
        % yF = forecast(PosteriorMdl, X_val_test);
        yF = my_eval(mdl, X_val_test, predictorInd);

        % figure;
        % plot(y_val_test);
        % hold on;
        % plot(yF);
        
        temp_frmse(j) = sqrt(mean((y_val_test - yF).^2, 1));
    end
    frmse = vertcat(frmse, temp_frmse);

end

end