%% This function is to generatye the supplychain network
% The distribution of companies' degree is scale free
% 
% Idea: select manufactures to be lower stream partners of suppliers;
%          select manufactures to be uper stream partners of retailers;
%          need to ensure each company has at least 2 neighbors
% Input: none
% global vars:
%           supplierRange: [1, 2, ..., num_of_suppliers]
%           manufacturerRange: [num_of_suppliers+1, num_of_suppliers+2, ..., num_of_suppliers+manufacturerRange]
%           retailerRange: [num_of_suppliers+manufacturerRange+1, num_of_suppliers+manufacturerRange+2, ..., n]
% Output: the adjacency matrix of size n*n
%              the ith row of the matrix represents the neighbors of
%              company i
function A = createAdjacencyMatrix_ScaleFree()
    global n supplierRange manufacturerRange retailerRange manufacturerDegrees
    
    % Initialize adjacency matrix
    A = zeros(n, n);
    
    % Step 1: Generate scale-free degree distributions
    numSuppliers = length(supplierRange);
    numManufacturers = length(manufacturerRange);
    numRetailers = length(retailerRange);
    
    % Scale-free degrees for suppliers and retailers
    supplierDegrees = generateScaleFreeDegrees(numSuppliers, numManufacturers);
    retailerDegrees = generateScaleFreeDegrees(numRetailers, numManufacturers);

    % Initialize manufacturers' degrees (preferential attachment mechanism)
    manufacturerDegrees = zeros(1, numManufacturers);
    
    % Step 2: Assign manufacturers to suppliers
    A = assignConnections(A, supplierRange, manufacturerRange, supplierDegrees);
    
    % Step 3: Assign manufacturers to retailers
    A = assignConnections(A, retailerRange, manufacturerRange, retailerDegrees);
end

%% Helper Function: Generate Scale-Free Degree Distribution
function degrees = generateScaleFreeDegrees(numNodes, maxDegree)
    % Generate scale-free degree distribution using power-law
    rawDegrees = (1:numNodes).^(-0.5);
    degrees = round(rawDegrees * (2 * mean(rawDegrees) * numNodes));

    degrees(degrees < 2) = 2; % Ensure at least 2 connections
    degrees(degrees > maxDegree) = maxDegree; % Ensure at most maxDegree connections
end


%% Helper Function: Assign Connections
function A = assignConnections(A, sourceRange, targetRange, sourceDegrees)
    global supplierRange manufacturerDegrees
    % Initialize preferential attachment probabilities for manufacturers
    targetProbabilities = manufacturerDegrees  / sum(manufacturerDegrees + eps);
    targetProbabilities = targetProbabilities * 10;  % Adjust scaling factor for more selective attachment
    targetProbabilities(targetProbabilities < eps) = eps;  % Ensure no zero probability
    
    % Normalize probabilities
    targetProbabilities = targetProbabilities / sum(targetProbabilities);

    for i = 1:length(sourceRange)
        % Current source node
        sourceNode = sourceRange(i);
        
        % Select neighbors for the source node
        numConnections = sourceDegrees(i);
        selectedNeighbors = preferentialSelection(targetRange, targetProbabilities, numConnections);

        % Update adjacency matrix
        A(sourceNode, selectedNeighbors) = 1;
        A(selectedNeighbors, sourceNode) = 1; % Symmetric
        
        % Update manufacturer degrees and probabilities
        manufacturerDegrees(selectedNeighbors - length(supplierRange)) = manufacturerDegrees(selectedNeighbors - length(supplierRange)) + 1;
        targetProbabilities = manufacturerDegrees+1 / sum(manufacturerDegrees+1);
        
        % Re-normalize to ensure the sum of probabilities is 1
        targetProbabilities = targetProbabilities / sum(targetProbabilities);
    end
end

%% Helper Function: Preferential Selection
function selected = preferentialSelection(targetRange, probabilities, numSelections)
    % Ensure probabilities are valid
    if all(probabilities <= 0)
        probabilities = ones(size(probabilities)); % Assign equal probabilities
    end
    
    if(rand()<=0.5)
        % Add noise: Introduce a small random component to the probabilities
        noiseFactor = 0.01;  % Noise scaling factor, adjust as necessary
        noise = noiseFactor * rand(1, length(probabilities));  % Uniform noise between 0 and noiseFactor
        probabilities = probabilities + noise;
    end
    
    % Normalize
    probabilities = probabilities / sum(probabilities);
    probabilities = probabilities * 10;

    % Randomly select targets with valid probabilities
    selected = datasample(targetRange, numSelections, 'Weights', probabilities, 'Replace', false);
end

%% Test PASS