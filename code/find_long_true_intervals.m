function intervals = find_long_true_intervals(logical_array, min_length)
    % Find the changes (edges) in the logical array
    d = diff([false, logical_array, false]);  % Pad with false at ends
    start_idx = find(d == 1);  % Rising edge (false -> true)
    end_idx   = find(d == -1) - 1;  % Falling edge (true -> false)
    
    % Calculate lengths of true segments
    lengths = end_idx - start_idx + 1;

    % Filter intervals by minimum length
    valid = lengths >= min_length;
    
    % Return as Nx2 array: [start_index, end_index]
    intervals = [start_idx(valid)', end_idx(valid)'];
end