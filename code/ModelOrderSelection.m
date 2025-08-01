function INDICATORS = ModelOrderSelection(signal, maxOrder)



    for p = 1 : maxOrder
        n = length(signal.OutputData);
        dim_y = size(signal.OutputData, 2);

        ny = ones(dim_y, dim_y, "double") .* p;
        model_est = ar(signal, ny, 'ls');
        AIC(p) = model_est.Report.Fit.AIC;
        FPE(p) = model_est.Report.Fit.FPE;
        MDL(p) = n * log(model_est.Report.Fit.LossFcn) + 2*p * log(n);
        
    end
    INDICATORS = [AIC; FPE; MDL];
            
end