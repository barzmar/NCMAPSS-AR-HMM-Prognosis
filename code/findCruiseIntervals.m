function [intervals, signal] = findCruiseIntervals(altitude, window, threshold, min_length)
    
    %calculates the mean difference in altitude of point from window samples in the past
    %(current_sample_altitude - sample_w)/windows
    signal = backWindowMean(altitude, window);
    
    %check if mean delta altitude is within threshold.
    boolean_signal = abs(signal)<=threshold;

    % Find the start and end indices of cruise intervals
    intervals = find_long_true_intervals(boolean_signal, min_length);

    % check_first_from_end with outside altitude threshold
    for i = 1 : size(intervals,1)
        flag = sign(altitude(intervals(i,2))-altitude(intervals(i,2)-1));
        temp = 0;
        for j = 0 : window-1
            temp = altitude(intervals(i,2)-j)-altitude(intervals(i,2)-j-1);
            temp_flag = sign(temp);
            if (abs(temp) > threshold) && (temp_flag == flag)
                intervals(i, 2) = intervals(i, 2) - j; % Adjust end index if altitude exceeds threshold
            end
        end
    end
end