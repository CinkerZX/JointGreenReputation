function A = createAdjacencyMatrix()
    global n supplierRange manufacturerRange retailerRange
    
    % Initialize the adjacency matrix with zeros
    % Three-dimensional matrix for time steps
    A = zeros(n, n, 1);

    % Function to select connections using Roulette Wheel Selection Algorithm
    function connections = getConnections(range, numConnections, maxConnections, currentNode)
        connections = [];
        if ~isempty(range) && numConnections > 0
            % Filter nodes that have fewer than maxConnections connections
            % from suppliers or retailers and remove itself
            availableNodes = range(arrayfun(@(x) sum(A(x, supplierRange, 1)) < maxConnections && sum(A(x, retailerRange, 1)) < maxConnections && x ~= currentNode, range));
            if length(availableNodes) < numConnections
                % Adjust the number of connections if not enough available nodes
                numConnections = length(availableNodes);
            end
            if numConnections > 0
                % Calculate probabilities for roulette wheel selection
                % Inverse of current connections count, so nodes with fewer connections are more likely to be chosen
                selectionWeights = 1 ./ (sum(A(availableNodes, :, 1), 2) + 1);
                totalWeight = sum(selectionWeights);
                probabilities = selectionWeights / totalWeight;

                % Perform roulette wheel selection
                for k = 1:numConnections
                    r = rand; % Random number between 0 and 1
                    cumulativeProbability = 0;
                    for j = 1:length(availableNodes)
                        cumulativeProbability = cumulativeProbability + probabilities(j);
                        if r <= cumulativeProbability
                            connections = [connections, availableNodes(j)];
                            % Update weights and probabilities after selection to reduce chances of selecting the same node again
                            selectionWeights(j) = 0; % Prevent selecting the same node
                            totalWeight = sum(selectionWeights);
                            probabilities = selectionWeights / totalWeight;
                            break;
                        end
                    end
                end
            end
        end
    end

    % Function to make connections symmetric
    function makeSymmetric(src, targets)
        if ~isempty(targets)
            for target = targets
                A(src, target, 1) = 1; 
                A(target, src, 1) = 1; 
            end
        end
    end

    % Suppliers to Manufacturers
    for i = supplierRange
        if ~isempty(manufacturerRange) && length(manufacturerRange) >= 2
            % Randomly generate a number between 2 and 5 for the number of connections
            numConnections = randi([2, 5]); 
            % Get connections for suppliers
            connections = getConnections(manufacturerRange, numConnections, 5, i); 
            makeSymmetric(i, connections); 
        end
    end

    % Retailers to Manufacturers
    for i = retailerRange
        if ~isempty(manufacturerRange) && length(manufacturerRange) >= 2
            % Randomly generate a number between 2 and 5 for the number of connections
            numConnections = randi([2, 5]); 
            % Get connections for retailers
            connections = getConnections(manufacturerRange, numConnections, 5, i); 
            makeSymmetric(i, connections); 
        end
    end
end
