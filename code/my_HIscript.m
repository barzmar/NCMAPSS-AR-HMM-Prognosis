clear

halfFlights = true;
phase = 2;
window2 = 500; step2 = 250;
targets = [11 12];

total_frmse = cell.empty;
numHI = 0; % number of health indexes

plotNotSave = false;


load("..\dataNew\processed_data_sets\unitsFlight\unitsFlights-fileN-CMAPSS_DS02-006.mat","-mat")
load("..\dataNew\MDLmodel\DATASET__PLACEHOLDER\MDLmodel11  12_01.mat")

for targetSensor = targets
    numHI = numHI + 1;
    sensors = [5,6,7,8, targetSensor];
    
    i = 0;
    frmse = cell.empty;
    movMfrmse =  cell.empty;
    mdl = models{numHI}; % current model
    indexPred = bestPredictorsInd{numHI}; % current predictor indexes
    for unit_testing = 1 : length(unitsFlights)
        i = i + 1;
        
        frmse{i} = my_eval_NCMAPSS(unitsFlights, mdl, unit_testing, sensors, window2, step2, phase, indexPred, halfFlights);
        movMfrmse{i} = movmean(frmse{i}, 50);

    end
    
    
    if isempty(total_frmse)
        total_frmse = cell(length(frmse), length(targets));
        total_movMfrmse = cell(length(frmse), length(targets));
    end

    for i = 1 : length(frmse)
        
        total_frmse{i, numHI} = frmse{i};
        total_movMfrmse{i, numHI} = movmean(frmse{i}, 50);

        if plotNotSave
            figure(i);
            subplot(length(targets),1,numHI);
            hold on;
            plot(total_frmse{i, numHI});
            plot(total_movMfrmse{i, numHI})
            hold off;
            title(['Sensor Target: ', num2str(targetSensor)]);
            xlabel('Evaluation');
            ylabel('FRMSE');
            xlim([0, max(0, length(total_frmse{i, numHI}))]);
            ylim([0, 0.7])
            grid on;
        end
    end
end

if not(plotNotSave)
        folderName = '..\dataNew\HealthIndexes\DATASET__PLACEHOLDER';
        if ~exist(folderName, 'dir')
            mkdir(folderName);
        end
        
        % Generate the file name
        targetStr = num2str(targets);
        iteration = 0;
        fileName = fullfile(folderName, sprintf('HI_targets%s_%02d.mat', targetStr, iteration));
        
        % Increment iteration if file already exists
        while exist(fileName, 'file')
            iteration = iteration + 1;
            fileName = fullfile(folderName, sprintf('HI_targets%s_%02d.mat', targetStr, iteration));
        end
        
        % Save the health index
        save(fileName, 'total_frmse', "total_movMfrmse");
end