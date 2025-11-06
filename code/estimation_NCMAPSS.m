function mdl = estimation_NCMAPSS(data, unit, sensorIndexes, window, step, phase)

[buffered_data,rowNames] = data_table(data,unit,sensorIndexes,window,step,phase);

X=[];
y = [];


X = buffered_data(1:end-1-phase,:);
y = buffered_data(end,:);
rowNames = rowNames([1:end-1-phase, end]);

X_train = [X(:,:)]';

y_train = [y(:,:)]';

mdl = fitlm(X_train,y_train, "interactions", "Intercept", true, "RobustOpts", "off","VarNames", rowNames);



end