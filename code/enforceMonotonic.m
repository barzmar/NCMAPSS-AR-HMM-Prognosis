function idxTransformed = enforceMonotonic(idx)
    % enforceMonotonic ensures that idx is non-decreasing from left to right
    % by replacing any value smaller than the previous with the previous.

    idxTransformed = idx; % initialize
    for i = 2:length(idx)
        if idxTransformed(i) < idxTransformed(i-1)
            idxTransformed(i) = idxTransformed(i-1);
        end
    end
end