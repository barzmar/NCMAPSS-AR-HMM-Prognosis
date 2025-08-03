function INDICATORS = ModelOrderSelection(signal, maxOrder)


    for p = 1 : maxOrder
        % length of signal window
        n = 400;
        % dim_y = size(signal.OutputData, 2);
        % 
        % ny = ones(dim_y, dim_y, "double") .* p;
        % model_est = ar(signal, ny, 'ls');

        INDICATORS = cell(1);
        [Models, ~, ~] = calcAR_C(signal, p, n, 100);
        for j = 1 : length(Models)
            model_est = Models{j};

            AIC(p, j) = model_est.Report.Fit.AIC;
            FPE(p, j) = model_est.Report.Fit.FPE;
            MDL(p, j) = n * log(model_est.Report.Fit.LossFcn) + 2*p * log(n);

            INDICATORS = {AIC, FPE, MDL};
        end
    end
    
            
end