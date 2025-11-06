function opla(ppCruiseData ,fieldOutput, fieldInput, p, phase, regul)
n_w = 30;
num_cruises = 30;

boIntegrate = [false];

total_counter = 0;

% sensor_index = 20; %sensor to use ( from 9 to 22)
% p = 3; %number of parameters (found by analysing FPE, MDL, AIC graph)

%fieldOutput either 'Value', or 'Dad', or 'D', or 'd'

    % : amount of sample per AR estimation Lag: overlap of window
    Window = 800;
    Lag = 20;
    unit = 2;

for sensor_index = 11:11    

    input = [];
    output = [];
    AVectors = double.empty;
    BVectors = double.empty;
    for i = 1 : length(ppCruiseData(unit).flights)
        for c = 1 : length(ppCruiseData(unit).flights(i).cruises)
            % signal = iddata(ppCruiseData(unit).flights(i).cruises(c).DDValue(sensor_index, :)', [], 1);
            temp = getfield(ppCruiseData, {unit}, 'flights', {i}, 'cruises', {c}, fieldOutput);
            
            output = [temp(sensor_index, 1:end)'];
            % mach_filtered = lowpass(ppCruiseData(unit).flights(i).cruises(c).Dad(6, :), 0.05, 1);  % Choose a reasonable cutoff
            if ~strcmp(fieldInput, 'None')
                temp = getfield(ppCruiseData, {unit}, 'flights', {i}, 'cruises', {c}, fieldInput);
    
                input = [temp(5,:)' temp(7, :)' ];
            end
            signal = iddata(output, input, 1);
    
            % ESTIMATION
            [~, temp_AVectors, temp_BVectors] = calcAR_C(signal, p, Window, Lag, boIntegrate, phase, regul);
        end
        AVectors = vertcat(AVectors, temp_AVectors);
        BVectors = vertcat(BVectors, temp_BVectors);
    end
    % calculate average of the AR coeffiecients calculated
    % the resulting coefiecients is AR model for healthy system.
    
    newAR = sum(AVectors(1:n_w,:),1)/n_w;
    newAR_model = idpoly(newAR);
    
    % if ~strcmp(fieldInput, 'None')
    %     newB = sum(BVectors(1:n_w,:),1)/n_w;
    % else
    %     newB = 1;
    %     BVectors = ones(length(AVectors),1);
    % end
    
    
    total_counter = length(AVectors);
    
    % psdHat = PSDmodel(newB, newAR, 1, 1024, 1);
    ItaSaiDist = [];
    % for i = 1 : total_counter
    %     psdTemp = PSDmodel(BVectors(i,:), AVectors(i,:), 1, 1024, 1);
    %     ItaSaiDist(i) = SpectralDistance(psdHat, psdTemp);
    % 
    % end

    psdHat = PSDmodel(1, newAR, 1, 1024, 1);
    ItaSaiDistNoB = [];
    for i = 1 : total_counter
        psdTemp = PSDmodel(1, AVectors(i,:), 1, 1024, 1);
        ItaSaiDistNoB(i) = SpectralDistance(psdHat, psdTemp);
    
    end
    
    tempString = strcat('sensor', num2str(sensor_index), 'OutField', fieldOutput, '_', 'InField', fieldInput, '_param', num2str(p), '_Integrate', num2str(boIntegrate), '_Phase', num2str(phase), '_Regul', num2str(~isnumerictype(regul)));
    figure('Name', tempString);
    plot(ItaSaiDistNoB(:));

    FolderName = 'FIR_ALT_TRA_Variables';

    dirPath = fullfile('..', 'figures', FolderName, 'Variables');
    if ~exist(dirPath, 'dir')
        mkdir(dirPath); % Create the directory if it does not exist
    end

    save(fullfile(dirPath, strcat(tempString, '.mat')), 'ItaSaiDist', 'ItaSaiDistNoB', 'AVectors', 'BVectors');
    
    % figure;
    % hold on;
    % plot(1:1:total_counter, AVectors(:,2))
    % plot(1:1:total_counter, AVectors(:,3))
    % plot(1:1:total_counter, AVectors(:,4))
    % 
    % 
    % figure;
    % hold on;
    % plot(1:1:total_counter, BVectors(:,1))
    % plot(1:1:total_counter, BVectors(:,2))
    % plot(1:1:total_counter, BVectors(:,3))
    

end

end



fieldOutput = 'StdValue';
fieldInput = 'None';

p = [2 0];
phase = 0;
regularization = 0;

%% creating singal
temp = getfield(ppCruiseData, {2}, 'flights', {1}, 'cruises', {1}, fieldOutput);

output = [temp(20, 1:end)'];

if ~strcmp(fieldInput, 'None')
    temp = getfield(ppCruiseData, {2}, 'flights', {1}, 'cruises', {1}, fieldInput);

    input = [temp(5,:)' temp(7, :)'];

else
    input = [];
end

signal = iddata(output, input, 1); %crreating signal iddata object (output, input, period)
%% defining regularization
if regularization
    %%% Defining order matrices %%%%%%%
        dim_y = 1;
        dim_u = 2;
        
        ny = ones(dim_y, dim_y, "double") .* p(1);
        nu = ones(dim_y, dim_u, "double") .* (p(2));
        nk = ones(dim_y, dim_u, "double") * phase;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [lambda, R] = arxRegul(signal, [ny nu nk]);
    opt = arxOptions;
    opt.Regularization.Lambda = lambda;
    opt.Regularization.R = R;
else
    opt = 0;    % comment this out if regularization needed
end

%% Actual Estimation part
opla(ppCruiseData, fieldOutput, fieldInput, p, phase, opt);
