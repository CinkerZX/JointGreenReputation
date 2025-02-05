function plotAverageT2GDiffusionCurve(t, numIterations)
    global supplierRange;
    global manufacturerRange;
    global retailerRange;

    % Path to the data file
    filename = 'D:\uva\courses\thesis\AllIterationsData.xlsx';

    % Pre-allocate arrays to store the average percentage of T2G=1 at each time step
    allGreenAvg = zeros(t+1, 1);
    supplierGreenAvg = zeros(t+1, 1);
    manufacturerGreenAvg = zeros(t+1, 1);
    retailerGreenAvg = zeros(t+1, 1);

    % Initialize counters
    countAllNodes = zeros(t+1, 1);
    countSuppliers = zeros(t+1, 1);
    countManufacturers = zeros(t+1, 1);
    countRetailers = zeros(t+1, 1);

    % Loop through each iteration to calculate the average
    for i = 1:numIterations
        sheetName = ['Iteration ' num2str(i)];
        data = readmatrix(filename, 'Sheet', sheetName);
        % Data assumed to be formatted as rows of nodes with columns as time steps
        numTimeSteps = min(size(data, 2) - 1, t); % Take the smaller to match t in case data is shorter

        % Extend data to match the required time steps if necessary
        if numTimeSteps < t
            data(:, numTimeSteps+1:t+1) = repmat(data(:, numTimeSteps), 1, t-numTimeSteps+1);
        end

        % Calculate percentage for each node type
        for step = 1:t+1
            % Calculate T2G=1 percentage for all nodes
            allNodes = data(:, step) == 1;
            suppliers = data(supplierRange, step) == 1;
            manufacturers = data(manufacturerRange, step) == 1;
            retailers = data(retailerRange, step) == 1;

            if any(allNodes) % Avoid division by zero
                allGreenAvg(step) = allGreenAvg(step) + sum(allNodes) / length(allNodes) * 100;
                countAllNodes(step) = countAllNodes(step) + 1;
            end
            if any(suppliers)
                supplierGreenAvg(step) = supplierGreenAvg(step) + sum(suppliers) / length(suppliers) * 100;
                countSuppliers(step) = countSuppliers(step) + 1;
            end
            if any(manufacturers)
                manufacturerGreenAvg(step) = manufacturerGreenAvg(step) + sum(manufacturers) / length(manufacturers) * 100;
                countManufacturers(step) = countManufacturers(step) + 1;
            end
            if any(retailers)
                retailerGreenAvg(step) = retailerGreenAvg(step) + sum(retailers) / length(retailers) * 100;
                countRetailers(step) = countRetailers(step) + 1;
            end
        end
    end

    % Convert sum to average
    allGreenAvg = allGreenAvg ./ countAllNodes;
    supplierGreenAvg = supplierGreenAvg ./ countSuppliers;
    manufacturerGreenAvg = manufacturerGreenAvg ./ countManufacturers;
    retailerGreenAvg = retailerGreenAvg ./ countRetailers;

    % Plot the average T2G diffusion curve
    figure; 
    hold on;
    plot(0:t, allGreenAvg, 'Color', [1, 0, 0], 'LineStyle', '-', 'LineWidth', 2, 'DisplayName', 'All Nodes');
    plot(0:t, supplierGreenAvg, 'Color', [0, 0, 1], 'LineStyle', '-', 'LineWidth', 2, 'DisplayName', 'Suppliers');
    plot(0:t, manufacturerGreenAvg, 'Color', [0, 0.5, 0], 'LineStyle', '-', 'LineWidth', 2, 'DisplayName', 'Manufacturers');
    plot(0:t, retailerGreenAvg, 'Color', [1, 0.65, 0], 'LineStyle', '-', 'LineWidth', 2, 'DisplayName', 'Retailers');
    hold off;
    title('\alpha = 0.7', 'FontSize', 20);
    xlabel('t', 'FontSize', 25);
    ylabel('K^0 = 0.75', 'FontSize', 25);
    %legend('show', 'Location', 'southeast', 'FontSize', 15);
    grid on;

    % Set the x-axis limit to 50
    xlim([0, 50]);
end
