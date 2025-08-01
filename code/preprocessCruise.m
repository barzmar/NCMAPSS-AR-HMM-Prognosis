function cruise = preprocessCruise(cruise)
    
    for i = 5 : 22
        [cruise.Dad(i,:), cruise.D(i,:), cruise.d(i,:)] = detrendAndDiff(cruise.Value(i,:));
        % Further processing or analysis can be added here
    end
    

end