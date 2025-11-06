rng(1);
unit = 1; f = 1;

buffered_data = custom_buffer( ...
    unitsFlights(unit).flights(f).Value([5:8, 19], :), ...
    800, 100, 100); 

p = size(buffered_data{1}, 1);
PriorMdl = bayeslm(p,'ModelType', 'Lasso' , 'Intercept', false);

X=[];
X_1=[];
y = [];
y_1 = [];

for i = 1 : length(buffered_ppCruise)
    X = buffered_data{i}(1:end-1,:);
    y = buffered_data{i}(end,:);



    X_train = [X(:,:)];
    X_train = standardizeTimeSeries(X_train)';

    y_train = standardizeTimeSeries(y_1)';
end

PosteriorMdl = estimate(PriorMdl,X_train,y_train);


% Mdl = fitlm(X_train,y_train);
X_val = [];
X_1_val = [];
y_val = [];
y_1_val = [];

for i = 5 : 5
    X_val = [X_val unitsFlights(2).flights(i).Value(5:7, 1:end-1)];
    X_1_val = [X_1_val unitsFlights(2).flights(i).Value(5:7,2:end)];
    y_val = [y_val unitsFlights(2).flights(i).Value(19,1:end-1)];
    y_1_val = [y_1_val unitsFlights(2).flights(i).Value(19,2:end)];
end


X_val_test = [X_1_val(:,:)];
X_val_test = standardizeTimeSeries(X_val_test)';

y_val_test = standardizeTimeSeries(y_1_val)';

yF = forecast(PosteriorMdl,X_val_test);

figure;
plot(y_val_test);
hold on;
plot(yF);

frmse = sqrt(mean((y_val_test - yF).^2, 1))