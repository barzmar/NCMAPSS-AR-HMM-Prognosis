function result = removeEmptyElements(inputArray)
% removeEmptyElements - Removes all empty elements from any array
%
% Syntax:
%   result = removeEmptyElements(inputArray)
%
% Input:
%   inputArray - A cell array, struct array, or general array
%
% Output:
%   result - Array with empty elements removed

    % For cell arrays
    if iscell(inputArray)
        isEmpty = cellfun(@isempty, inputArray);
        result = inputArray(~isEmpty);
    
    % For struct arrays
    elseif isstruct(inputArray)
        isEmpty = arrayfun(@(s) isempty(fieldnames(s)) || all(structfun(@isempty, s)), inputArray);
        result = inputArray(~isEmpty);

    % For other arrays (e.g., numeric, string, etc.)
    else
        isEmpty = arrayfun(@isempty, inputArray);
        result = inputArray(~isEmpty);
    end
end
