function regressionFunc = my_funcHandle(x, newCoef, matchIndices)
    regressionFunc = 0;
    for i = 1 : length(newCoef)
        currentPredictor = prod(x(matchIndices{i}, :), 1);
        temp = newCoef(i) .* currentPredictor;
        regressionFunc = temp+ regressionFunc;
    end
    regressionFunc = regressionFunc';
end