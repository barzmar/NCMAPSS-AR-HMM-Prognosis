function plotMatrixRows(matrix, rowIndices)
    % plotMatrixRows Plots selected rows of a matrix using different graph types.
    % Usage: plotMatrixRows(matrix, rowIndices)
    % - matrix: a numeric matrix
    % - rowIndices: a vector of row indices to plot

    % Validate input
    if ~ismatrix(matrix) || ~isnumeric(matrix)
        error('First input must be a numeric matrix.');
    end
    if ~isvector(rowIndices) || ~isnumeric(rowIndices)
        error('Second input must be a numeric vector of row indices.');
    end

    % Define plot types to cycle through
    plotTypes = {@plot};
    nTypes = length(plotTypes);

    % Create figure
    figure;
    hold on;
    legendEntries = {};

    for k = 1:length(rowIndices)
        idx = rowIndices(k);

        % Check index validity
        if idx < 1 || idx > size(matrix, 1)
            warning('Row index %d is out of bounds. Skipping.', idx);
            continue;
        end

        rowData = matrix(idx, :);

        % Choose plot type in a round-robin fashion
        plotFunc = plotTypes{mod(k-1, nTypes) + 1};

        % Plot the data
        plotFunc(rowData);

        % Add label
        legendEntries{end+1} = sprintf('Row %d - %s', idx, func2str(plotFunc));
    end

    title('Selected Matrix Rows with Different Plot Types');
    xlabel('Column Index');
    ylabel('Value');
    legend(legendEntries);
    grid on;
    hold off;
end
