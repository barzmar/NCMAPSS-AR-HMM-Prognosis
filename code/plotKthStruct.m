function plotKthStruct(unit, k)
    % Create a figure
    figure;
    
    % Loop through each of the 4 rows
    for row = 1:4
        subplot(4, 1, row); % Create a subplot for each row
        plot(unit(k).Value(row, :)); % Assuming 'data' is a field in the struct
        title(['Row ' num2str(row) ' of Struct ' num2str(k)]);
        xlabel('X-axis Label'); % Replace with appropriate label
        ylabel('Y-axis Label'); % Replace with appropriate label
    end
    
    % Adjust layout
    sgtitle(['Plots for Struct ' num2str(k)]); % Super title for all subplots
end

