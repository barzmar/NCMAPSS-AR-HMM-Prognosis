function frmse = evalLasso_NCMAPSS(data, mdl, unit2, sensorIndexes, window, step, phase, predIndexes)

frmse = [];
for f2 = 1 : length(data(unit2).flights)
    
    buffered_data_val = custom_buffer( ...
        data(unit2).flights(f2).StdValue(sensorIndexes, :), ...
        window, step, phase);

    for i = 1 : size(buffered_data_val, 1)
        sensorNameIndex = sensorIndexes(floor((i-1)/(phase+1))+1);
        noMixNames(i) = strcat(data(unit).flights(f).Name(sensorNameIndex), num2str(phase-mod(i-1,phase+1)));
    end
    
    
    
    X=[];
    y = [];
    
    X = buffered_data(1:end-1-phase,:);
    y = buffered_data(end,:);
    
    for i = 1 : length(predIndexes)
        if length(predIndexes{i}) == 1
            Xx = X
        else length(predIndexes{i}) == 2

        end
    end
    n_rows = size(X, 1) - 1;
    noMixNames = noMixNames(1:end-1-phase);
    rowNames = noMixNames;
    % Mdl = fitlm(X_train,y_train);

    L_Buff = length(buffered_data_val);
    temp_frmse = zeros(L_Buff,1);

    for j = 1 : L_Buff
        X_val = [];
        X_1_val = [];
        y_val = [];
        y_1_val = [];
        X_val = buffered_data_val{j}(1:end-1-phase,:);
        y_val = buffered_data_val{j}(end,:);
        
                
        X_val_test = [X_val(:,:)]';
        % X_val_test = standardizeTimeSeries(X_val_test)';
        
        
        y_val_test = [y_val]';

        function_handle = 
        
        % yF = forecast(PosteriorMdl, X_val_test);
        yF = feval(mdl, X_val_test);

        % figure;
        % plot(y_val_test);
        % hold on;
        % plot(yF);
        
        temp_frmse(j) = sqrt(mean((y_val_test - yF).^2, 1));
    end
    frmse = vertcat(frmse, temp_frmse);

end

end