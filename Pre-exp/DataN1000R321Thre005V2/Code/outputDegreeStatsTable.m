function outputDegreeStatsTable()
    global adjMatrix;
    global dynamicT2GUpdate;
    global dynamicJRUpdate;

    % Get the adjacency matrix for the initial and final time steps
    initialAdjMatrix = adjMatrix(:, :, 1);
    finalAdjMatrix = adjMatrix(:, :, end);

    % Calculate the number of degrees for the initial and final time steps
    initialDegrees = sum(initialAdjMatrix, 2);
    finalDegrees = sum(finalAdjMatrix, 2);

    % Calculate the mean and variance of the initial and final time steps.
    initialAvgDegree = mean(initialDegrees);
    initialVarDegree = var(initialDegrees);
    finalAvgDegree = mean(finalDegrees);
    finalVarDegree = var(finalDegrees);

    % Get the JR and T2G values for the initial and final time steps
    initialJRValues = dynamicJRUpdate(:, 1);
    finalJRValues = dynamicJRUpdate(:, end);
    initialT2GValues = dynamicT2GUpdate(:, 1);
    finalT2GValues = dynamicT2GUpdate(:, end);

    % Calculate the mean and variance of JR and T2G of the initial and final time steps
    initialAvgJR = mean(initialJRValues);
    initialVarJR = var(initialJRValues);
    finalAvgJR = mean(finalJRValues);
    finalVarJR = var(finalJRValues);
    initialAvgT2G = mean(initialT2GValues);
    initialVarT2G = var(initialT2GValues);
    finalAvgT2G = mean(finalT2GValues);
    finalVarT2G = var(finalT2GValues);

    % Create date table
    data = {
        'Variable', 't_0', 'T';
        'Average Degree', initialAvgDegree, finalAvgDegree;
        'Variance Degree', initialVarDegree, finalVarDegree;
        % 'Average JR', initialAvgJR, finalAvgJR;
        % 'Variance JR', initialVarJR, finalVarJR;
        % 'Average T2G', initialAvgT2G, finalAvgT2G;
        % 'Variance T2G', initialVarT2G, finalVarT2G
    };

    % Create figure
    figure('Position', [100, 100, 600, 250], 'Color', 'w');

    % Create table
    uit = uitable('Data', data(2:end, :), ...
                  'ColumnName', data(1, :), ...
                  'ColumnWidth', {150, 150, 150}, ...
                  'RowName', [], ...
                  'Position', [20, 20, 660, 200]);

    % Save as png
    saveas(gcf, 'DegreeJRAndT2GStatsTable.png');
end
