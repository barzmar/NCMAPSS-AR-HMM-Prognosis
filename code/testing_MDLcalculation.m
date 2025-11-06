    clear all

flagSave = false;

load("..\dataNew\processed_data_sets\unitsFlight\unitsFlights-fileN-CMAPSS_DS02-006.mat","-mat")

targets = [11 12];

data = unitsFlights;
clear unitsFlights
unit1 = [1 2 3 4 5];
unit2 = [6 7 8 9];

window = 1000;
step = 800;
phase = 2;
maxFlightsTraining = 4;
maxFlightsCV = 5;

numHI = 0;
for targetSensor = targets
    numHI = numHI + 1;
    sensorIndexes = horzcat([5,6,7,8], targetSensor);
    
    buffered_data = double.empty();
    for unit = unit1
        for f = 1 : maxFlightsTraining
            temp_buffered_data = myBufferizeData(data(unit).flights(f).StdValue(:,:), sensorIndexes, window, step, phase)';
            buffered_data = horzcat(buffered_data, cell2mat(temp_buffered_data));
            clear temp_buffered_data
        end
    end
    
    %% creating sensor names with phase
    for i = 1 : size(buffered_data, 1)
        sensorNameIndex = sensorIndexes(floor((i-1)/(phase+1))+1);
        noMixNames(i) = strcat(data(unit).flights(f).Name(sensorNameIndex), num2str(phase-mod(i-1,phase+1)));
    end
    
    X_train = buffered_data(1:end-1-phase,:);
    y_train = buffered_data(end,:);
    
    clear buffered_data 
    
    
    n_rows = size(X_train, 1) - 1;
    y_name = noMixNames(end);
    noMixNames = noMixNames(1:end-1-phase);
    rowNames = horzcat(noMixNames, y_name);
    
    %% loading cross-validation data
    n_CV = length(unit2)*maxFlightsCV;
    buffered_data2 = cell(n_CV,1);
    counter = 0;
    for unitCV = unit2
        for j = 1 : maxFlightsCV    
            counter = counter + 1;
            buffered_data2{counter} = cell2mat(myBufferizeData(data(unitCV).flights(j).StdValue(:,:), sensorIndexes, window, step, phase)');
        end
    end
    
    %% interaction variables and rowNames
    % for r1 = 1 : n_rows
    %     for r2 = r1 : n_rows
    %         X = vertcat(X, X(r1,:) .*  X(r2,:));
    %         X2 = vertcat(X2, X2(r1,:) .*  X2(r2,:));
    %         rowNames = horzcat(rowNames, strcat(rowNames(r1), " ", rowNames(r2)));
    %     end
    % end
    %% creating X matrix for training
    
    X_train = [X_train(:,:)]';
    
    y_train = [y_train(:,:)]';
    
    matComb = my_combinationGenerator(size(X_train,2));
    
    
    nModels = size(matComb,1);
    MDL = cell(nModels, n_CV);
    rmse = cell(nModels, n_CV);
    
    
    
    
    %% cycling through combination
    for i = 1 : size(matComb,1) 
        
        currentComb = matComb(i,:);
        if i ~= 1
            predictorInd = find(currentComb);
        else
            predictorInd = [];
        end
        %number of parameters in current model
        p = sum(currentComb);
        
        varNames = cell(1, p);
        counterNames = 0;
    
        for name = predictorInd
            counterNames = counterNames + 1;
            varNames{counterNames} = rowNames(name);
        end
    
        % current model
        model = fitlm(X_train, y_train, "quadratic", "Intercept", false, "PredictorVars", currentComb);
        
        for j = 1 : n_CV
                temp_data = buffered_data2{j};
                X_CV = temp_data(1:end-1-phase,:)';
                y_CV = temp_data(end,:)';
                clear temp_data    
                yF = my_eval(model, X_CV, predictorInd);
                    
                rmse{i, j} = sqrt(mean((y_CV - yF).^2, 1));
                
                N = length(X_CV);
                MDL{i, j} = calcMDL(N,rmse{i},p);
        end
    end

    [~, argm] = min(cell2mat(MDL))
    modeIndex = mode(argm);
    bestPredictorsInd{numHI} = matComb(modeIndex, :);
    models{numHI} = fitlm(X_train, y_train, "quadratic", "Intercept", false, "PredictorVars", bestPredictorsInd{numHI});
end

if flagSave
        folderName = '..\dataNew\MDLmodel\DATASET__PLACEHOLDER';
        if ~exist(folderName, 'dir')
            mkdir(folderName);
        end
        
        % Generate the file name
        targetStr = num2str(targets);
        iteration = 0;
        fileName = fullfile(folderName, sprintf('MDLmodel%s_%02d.mat', targetStr, iteration));
        
        % Increment iteration if file already exists
        while exist(fileName, 'file')
            iteration = iteration + 1;
            fileName = fullfile(folderName, sprintf('MDLmodel%s_%02d.mat', targetStr, iteration));
        end
        
        % Save the health index
        save(fileName, 'models', "bestPredictorsInd");
end