clc;
%addpath(genpath('D:\uva\courses\thesis\code'))

global n;
global t;                    %t=0
global K;%size: t+1x1   update[K0,0.4,0.2,...]
global alpha;
global numSuppliers;
global numManufacturers;
global numRetailers;
global supplierRange;
global manufacturerRange
global retailerRange
global initialT2GValues;
global initialJRValues;
global adjMatrix;
global strategyPlan;
global dynamicT2GUpdate;
global dynamicJRUpdate;


n = 11;
t = 3;
alpha = 0.2;  % {0.2,0.5,0.7}
supplierRange = 1:3;
manufacturerRange = 4:7;
retailerRange = 8:11;
disp('supplierRange:');
disp(supplierRange);
disp('manufacturerRange:');
disp(manufacturerRange);
disp('retailerRange:');
disp(retailerRange);

adjMatrix = [
    0 0 0 0 1 1 1 0 0 0 0;
    0 0 0 0 1 1 0 0 0 0 0;
    0 0 0 0 1 1 1 0 0 0 0;
    0 0 0 0 0 0 0 0 1 1 1;
    1 1 1 0 0 0 0 0 1 0 1;
    1 1 1 0 0 0 0 1 1 0 1;
    1 0 1 0 0 0 0 1 1 1 0;
    0 0 0 0 0 1 1 0 0 0 0;
    0 0 0 1 1 1 1 0 0 0 0;
    0 0 0 1 0 0 1 0 0 0 0;
    0 0 0 1 1 1 0 0 0 0 0
];

for i = 1:n
        neighbors = find(adjMatrix(i,:,1)); 
        fprintf('Node %d has neighbors: %s\n', i, mat2str(neighbors)); 
end

initialT2GValues = [0 
                    1 
                    0 
                    1 
                    0 
                    0 
                    0 
                    0 
                    1 
                    0 
                    1];

initialJRValues = [0 
                   0.2 
                   0 
                   0.2 
                   0 
                   0 
                   0 
                   0 
                   0.2 
                   0 
                   0.2];

dynamicT2GUpdate = initialT2GValues;
dynamicJRUpdate = initialJRValues;
disp('initial T2G:');
disp(dynamicT2GUpdate);
disp('initial JR:');
disp(dynamicJRUpdate);

strategyPlan = cell(n, 1);

    for iteration = 1:t
        % First Strategy Plan
        strategyFirstPlan(supplierRange, manufacturerRange, retailerRange, n);
        disp(['strategyFirstPlan at iteration ', num2str(iteration), ':']);
        disp(strategyPlan);

        % Check Add Success Strategy Plan
        strategyCheckAddSuccess(supplierRange, manufacturerRange, retailerRange, n, alpha);
        disp(['strategyCheckAddSuccess at iteration ', num2str(iteration), ':']);
        disp(strategyPlan);

        % Update Fail Add Strategy Plan
        strategyFailAddUpdate(n);
        disp(['strategyFailAddUpdate at iteration ', num2str(iteration), ':']);
        disp(strategyPlan);

        % Update T2G based on the strategy plan
        updateT2G();
        disp(['update T2G at iteration ', num2str(iteration), ':']);
        disp(dynamicT2GUpdate);

        % Update adjacency matrix based on the strategy plan
        updateAdjacencyMatrix();
        disp(['Updated adjacency matrix at iteration ', num2str(iteration), ':']);
        disp(adjMatrix(:, :, end));
        for i = 1:n
            neighbors = find(adjMatrix(i, :, end)); 
            fprintf('Node %d has neighbors at iteration %d: %s\n', i, iteration, mat2str(neighbors)); 
        end

        % Update JR based on the new adjacency matrix and T2G values
        updateJR(alpha);
        disp(['Updated JR values at iteration ', num2str(iteration), ':']);
        disp(dynamicJRUpdate);
    end