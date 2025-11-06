function cells_output_matrix = custom_buffer(data, window, step, phase)
arguments
    data 
    window  
    step
    phase
end


    n_cells = floor( (length(data) - phase - (window-step) ) / (step));
    cells_output_matrix = cell(n_cells ,1 );
    

    number_of_sens = size(data, 1);
    rows = number_of_sens * (phase + 1);

    array_of_sens = zeros(number_of_sens,1, "int16"); % array_of_sens is an array of int that indicates at which row the sensor in data row "i" in the buffered data starts
    %in case of phase=1 and number_of_sensors=5 (number of total timeseries
    %in data) then array_of_sens = [1 3 5 7 9] meaning first sensor starts
    %at row 1, second at row 3
    
    for i = 1 : number_of_sens
        array_of_sens(i) = 1 + ((phase + 1) * (i-1)) ; % phase always includes 0 phase, (i-1) to cover first to last cases (initial post)
    end
    
    for i = 1 : n_cells
        cells_output_matrix{i} = zeros(rows, window, "double");
    end

    % Initialize the output matrix based on the input data and parameters
    for i = 1 : n_cells
        index = ((i - 1) * (step)) + 1;
        for j = 0 : phase
            % cells_output_matrix{i}((j * number_of_sens)+1 : (j * number_of_sens) + number_of_sens, :) = data(:, (index + (phase-j)) : ((index + window - 1) + (phase- j))); 
            cells_output_matrix{i}(array_of_sens + phase - j, :) = data(:, (index + (phase-j)) : ((index + window - 1) + (phase- j))); 
        end
    end
end