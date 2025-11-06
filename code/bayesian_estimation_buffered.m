rng(1);
unit = 1; unit2 = 2;
sensorIndexes = [5, 6, 7, 8, 11];
window = 8000; step = 1000; phase = 0;

f = 1; f2 = 85; 




buffered_data = double.empty();
for f = 1 : 5
    unitsFlights(unit).flights(f).StdValue(:,:) =  standardizeTimeSeries(unitsFlights(unit).flights(f).Value(:,:), 1);
    temp_buffered_data = myBufferizeData(unitsFlights(unit).flights(f).StdValue(:,:), sensorIndexes, window, step, phase)';
    buffered_data = horzcat(buffered_data, cell2mat(temp_buffered_data));
    clear temp_buffered_data
end

p = size(buffered_data, 1) - 1;
PriorMdl = bayeslm(p,'ModelType', 'Lasso' , 'Intercept', false, 'Lambda', 5);

X=[];
X_1=[];
y = [];
y_1 = [];
beta = {};
sigma = {};

X = buffered_data(1:end-1,:);
y = buffered_data(end,:);



X_train = [X(:,:)]';
% X_train = standardizeTimeSeries(X_train)';

y_train = [y(:,:)]';


% PosteriorMdl = estimate(PriorMdl,X_train,y_train);
%  try
%     beta{i} = mean(PosteriorMdl.BetaDraws,2);
%     sigma{i} = mean(PosteriorMdl.Sigma2Draws,2);
%  catch 
%     beta{i} = PosteriorMdl.Mu;
% end

mdl = stepwiselm(X_train,y_train,'PEnter',0.06);


frmse = [];
for f2 = 1 : length(unitsFlights(unit2).flights)
    [r, c] = size(unitsFlights(2).flights(f2).Value(:,:));
    unitsFlights(unit2).flights(f2).StdValue = zeros([r,c]);
    unitsFlights(unit2).flights(f2).StdValue(:,:) =  standardizeTimeSeries(unitsFlights(2).flights(f2).Value(:,:),1);
    
    buffered_data_val = custom_buffer( ...
        unitsFlights(unit2).flights(f2).StdValue(sensorIndexes, :), ...
        3000, 1000, phase);

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
        yF = feval(mdl, X_val_test);

        % figure;
        % plot(y_val_test);
        % hold on;
        % plot(yF);
        
        temp_frmse(j) = sqrt(mean((y_val_test - yF).^2, 1));
    end
    frmse = vertcat(frmse, temp_frmse);
end

