function plotJRDiffusionCurve(t)

    global dynamicJRUpdate;
    global n;
    global supplierRange;
    global manufacturerRange;
    global retailerRange;

    % Pre-allocate an array to store the percentage of JR=1 at each time step
    allJRPercentage = zeros(t+1, 1);
    supplierJRPercentage = zeros(t+1, 1);
    manufacturerJRPercentage = zeros(t+1, 1);
    retailerJRPercentage = zeros(t+1, 1);

    % Calculate the percentage of T2G=1 at the current time step
    for step = 1:t+1
        % All nodes
        allJRPercentage(step) = sum(dynamicJRUpdate(:, step) == 1) / n * 100;
        % Suppliers
        supplierJRPercentage(step) = sum(dynamicJRUpdate(supplierRange, step) == 1) / length(supplierRange) * 100;
        % Manufacturers
        manufacturerJRPercentage(step) = sum(dynamicJRUpdate(manufacturerRange, step) == 1) / length(manufacturerRange) * 100;
        % Retailers
        retailerJRPercentage(step) = sum(dynamicJRUpdate(retailerRange, step) == 1) / length(retailerRange) * 100;
    end

    % Plot the JR diffusion curve
    figure;
    hold on;
    plot(0:t, allJRPercentage, '-o', 'DisplayName', 'All Nodes');
    plot(0:t, supplierJRPercentage, '-x', 'DisplayName', 'Suppliers');
    plot(0:t, manufacturerJRPercentage, '-s', 'DisplayName', 'Manufacturers');
    plot(0:t, retailerJRPercentage, '-d', 'DisplayName', 'Retailers');
    xlabel('Time Step');
    ylabel('Percentage of JR=1');
    title('S-shaped Diffusion Curve of JR Transition');
    legend show;
    grid on;
    hold off;
end
