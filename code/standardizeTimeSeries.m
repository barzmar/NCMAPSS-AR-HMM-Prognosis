function Xstd = standardizeTimeSeries(X, hardcoded)
arguments
    X 
    hardcoded int8 = 0
end
%STANDARDIZETIMESERIES Standardizes rows of a matrix independently
%   Xstd = STANDARDIZETIMESERIES(X) takes a matrix X where each row 
%   represents a separate time series, and returns Xstd where each row 
%   has been standardized to have mean 0 and standard deviation 1.
%
%   Example:
%       X = [1 2 3 4; 10 20 30 40];
%       Xstd = standardizeTimeSeries(X)

if hardcoded
        rowMean = [10.929774278615069; 
                    38.597422248656819; 
                    2.915305928687633; 
                    0.225898035745589; 
                    2.152850768984763e+04; 
                    0.620719826727900; 
                    68.198587958817015; 
                    4.761087572255344e+02; 
                    5.600191679724941e+02; 
                    1.321079151747625e+03; 
                    1.643978601360217e+03; 
                    1.107981766095102e+03; 
                    10.963327867768621; 
                    8.358874657127830; 
                    11.130282099257471; 
                    13.760331577930989; 
                    2.104857927583297e+02; 
                    2.140902612781680e+02; 
                    8.148679685860678; 
                    2.012999609026864e+03; 
                    8.210376807934008e+03; 
                    2.275341896490028];
        rowStd = [7.595137298390469; 
                    22.674898895051523; 
                    0.402759358333125; 
                    0.418172405145553; 
                    6.458563827699199e+03; 
                    0.080711869184695; 
                    14.568581908314794; 
                    17.045139549804222; 
                    18.203909785030394; 
                    55.559704415238670; 
                    98.425427468623582; 
                    52.080350483053401; 
                    2.210457755699154; 
                    1.822680740598186; 
                    2.244119548933150; 
                    2.689404274731736; 
                    44.691642061201442; 
                    45.356678943476076; 
                    1.957976358468009; 
                    1.385012343305939e+02; 
                    1.841600226367603e+02; 
                    0.576054266897203];

    else
        % Compute row-wise mean and std
        rowMean = mean(X, 2);         % column vector of row means
        rowStd  = std(X, 0, 2);       % column vector of row std deviations
        
      
    end
    % Handle case where std = 0 (constant row -> return zeros)
    rowStd(rowStd == 0) = 1;
    % Standardize: subtract mean and divide by std
    Xstd = (X - rowMean) ./ rowStd;
    
end
