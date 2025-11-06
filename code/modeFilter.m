function [idxFiltered] = modeFilter(idx, Size)
    % modeFilter applies a mode filter to the input vector 'idx'
    % using a sliding window of size 'Size'.
    % Ensures Size is odd for symmetry.

    % Round and enforce odd Size
    Size = round(Size);

    n = length(idx);
    idxFiltered = zeros(size(idx));

    % Apply mode filtering
    for i = Size + 1 : n
        idxFiltered(i) = mode(idx(i - Size : i));
    end

    % Extend boundaries
    idxFiltered(1:Size-1) = 1;
end
