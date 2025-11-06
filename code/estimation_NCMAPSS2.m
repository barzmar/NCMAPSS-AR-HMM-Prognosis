function mdl = estimation_NCMAPSS2(data, unit, sensorIndexes, window, step, phase)

buffered_data = double.empty();
for f = 1 : 6
    temp_buffered_data = myBufferizeData(data(unit).flights(f).StdValue(:,:), sensorIndexes, window, step, phase)';
    buffered_data = horzcat(buffered_data, cell2mat(temp_buffered_data));
    clear temp_buffered_data
end

p = size(buffered_data, 1) - 1;
% PriorMdl = bayeslm(p,'ModelType', 'Lasso' , 'Intercept', false, 'Lambda', 5);

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

mdl = fitlm(X_train,y_train, "linear", "RobustOpts", "off");



end