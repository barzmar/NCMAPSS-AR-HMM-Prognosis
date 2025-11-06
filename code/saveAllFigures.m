function saveAllFigures(folderPath)
    % Check if the folder exists, if not, create it
    if ~exist(folderPath, 'dir')
        mkdir(folderPath);
    end
    
    % Get all open figures
    figHandles = findall(0, 'Type', 'figure');
    
    % Save each figure in the specified folder
    for i = 1:length(figHandles)
        fig = figHandles(i);
        % Construct the filename
        filename = fullfile(folderPath, sprintf('figure_%d.png', fig.Number));
        % Save the figure
        saveas(fig, filename);
    end
end