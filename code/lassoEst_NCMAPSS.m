function [mdl, infoLassoFit] = lassoEst_NCMAPSS(data, unit, unit2, sensorIndexes, window, step, phase)

buffered_data = double.empty();
for unit = 1 : 5
    for f = 1 : 4
        temp_buffered_data = myBufferizeData(data(unit).flights(f).StdValue(:,:), sensorIndexes, window, step, phase)';
        buffered_data = horzcat(buffered_data, cell2mat(temp_buffered_data));
        clear temp_buffered_data
    end
end

buffered_data2 = cell2mat(myBufferizeData(data(unit2).flights(1).StdValue(:,:), sensorIndexes, window, step, phase)');

for i = 1 : size(buffered_data, 1)
    sensorNameIndex = sensorIndexes(floor((i-1)/(phase+1))+1);
    noMixNames(i) = strcat(data(unit).flights(f).Name(sensorNameIndex), num2str(phase-mod(i-1,phase+1)));
end



X = [];
y = [];

X = buffered_data(1:end-1-phase,:);
X2 = buffered_data2(1:end-1-phase,:);
y = buffered_data(end,:);

n_rows = size(X, 1) - 1;
noMixNames = noMixNames(1:end-1-phase);
rowNames = noMixNames;

for r1 = 1 : n_rows
    for r2 = r1 : n_rows
        X = vertcat(X, X(r1,:) .*  X(r2,:));
        X2 = vertcat(X2, X2(r1,:) .*  X2(r2,:));
        rowNames = horzcat(rowNames, strcat(rowNames(r1), " ", rowNames(r2)));
    end
end

X_train = [X(:,:)]';
X_CV = [X2(:,:)]';
% X_train = standardizeTimeSeries(X_train)';

y_train = [y(:,:)]';

[coef, infoLassoFit] = lasso(X_train, y_train,"PredictorNames", rowNames(1:end), "CV", 2 , "Lambda", linspace(0, 1, 1000), "Intercept", false, "Alpha", 0.1);
MSE = infoLassoFit.MSE;
p = infoLassoFit.DF;
LASSO_INDEX = find(p<=100, 1, "first");

MDL = zeros(size(coef, 2),1);
N = length(buffered_data);

MDL = N*log(MSE)+2*p*log(N);

%write me a script that goes trough ans and finds strings in NoMix Names that match partially the string inrowNames
lassoPredNames = rowNames(find(coef(:, LASSO_INDEX)~=0));
matchIndices = cell(size(lassoPredNames));

for i = 1:length(noMixNames)
    matches = contains(lassoPredNames, noMixNames{i});
    matches2 = contains(lassoPredNames, strcat(noMixNames{i}," ", noMixNames{i}));
    for j = 1 : length(lassoPredNames)
        if matches(j)
             matchIndices{j} =  horzcat(matchIndices{j}, i);
        end
        if matches2(j)
            matchIndices{j} =  horzcat(matchIndices{j}, i);
        end
    end
end

newCoef = coef(find(coef(:, LASSO_INDEX)~=0),LASSO_INDEX);
% Create a regression function handle using the coefficients and match indices
mdl = @(x)my_funcHandle(x, newCoef, matchIndices);

end