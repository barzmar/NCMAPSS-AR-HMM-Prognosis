function yF = my_eval(model, X, predictorInd)
            
            % extracting only predictors
            X_eval = X(:, predictorInd);
        
            yF = feval(model, X_eval);


end