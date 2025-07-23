function [intervals, start_idx_array, fin_idx_array] = extract_maxTimeSeries(time_series, minLength)
    arguments
        time_series (1, :)
        minLength (1,1) int16 = 100;
    end
    % Find the maximum value and its index
    [max_value, max_index] = max(time_series);
    
    %Parameter for threhold
    percThreshold = 0.005;
    

    % Define the threshold for "around" the max value
    threshold = percThreshold * max_value; % Adjust this value as needed
    
    % Initialize an empty array to hold the intervals
    intervals = struct.empty;
    
    % Find the indices where the values are within the threshold of the max value
    indices = find(abs(time_series - max_value) <= threshold);
    
    %initialise start index array
    start_idx_array = [];
    fin_idx_array = [];

    % Group the indices into intervals
    start_idx = indices(1);
    interval_counter = 0;
    for i = 2:length(indices)
       
        if indices(i) ~= indices(i-1) + 1
            % If the current index is not consecutive, save the interval
            interval = time_series(start_idx:indices(i-1));
            
            if length(interval) >= minLength
                interval_counter = interval_counter + 1 ; % Update counter of useful intervals
                intervals(interval_counter).interval = interval; % Add as a new row
                start_idx_array(interval_counter) = start_idx; % Insert new element in start_array
                fin_idx_array(interval_counter) = indices(i-1);
            end
            start_idx = indices(i); % Update start index
            
            
        end
    end
    
    % Check the last interval
    interval = time_series(start_idx:indices(end));
    if length(interval) >= minLength
        interval_counter = interval_counter + 1 ; % Update counter of useful intervals
        intervals(interval_counter).interval = interval; % Add as a new row
        start_idx_array(interval_counter) = start_idx; % Insert new element in start_array
        fin_idx_array(interval_counter) = indices(end);
    end
end