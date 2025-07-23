function plotTableRows(varargin)
    % plotTableRows Plots multiple table rows on the same figure using different plot types.
    % Usage: plotTableRows(row1, row2, ..., rowN)
    % Each input (row1, row2, ...) should be a single row from a MATLAB table.

    % Define plot types to cycle through
    plotTypes = {@plot};
    nTypes = length(plotTypes);

    % Create figure
    figure;
    hold on;
    legendEntries = {};

    for k = 1:nargin
        row = varargin{k};

        if ~istable(row) || height(row) ~= 1
            error('Each input must be a single row of a table.');
        end

        % Convert table row to numeric vector (excluding non-numeric columns)
        numericData = row{1, vartype('numeric')};

        if isempty(numericData)
            warning('Row %d has no numeric data. Skipping.', k);
            continue;
        end

        % Choose plot type in a round-robin fashion
        plotFunc = plotTypes{mod(k-1, nTypes) + 1};

        % Plot the data
        plotFunc(numericData);

        % Add label
        legendEntries{end+1} = sprintf('Row %d - %s', k, func2str(plotFunc));
    end

    title('Multiple Table Rows Plotted with Different Graphs');
    xlabel('Column Index');
    ylabel('Value');
    legend(legendEntries);
    grid on;
    hold off;
end
