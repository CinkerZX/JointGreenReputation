function updateAdjacencyMatrix(step, currentAdjMatrix)
    global strategyPlan adjMatrix

    % Create new matrix for update
    newAdjMatrix = currentAdjMatrix;
    
    % Extract the id to connect with
    nodesPlantoConnect = find(strategyPlan(:,1) == 1);
    if ~isempty(nodesPlantoConnect)
        toNodes = strategyPlan(nodesPlantoConnect,2);
        newAdjMatrix = helperMatrixUpdate(newAdjMatrix, nodesPlantoConnect, toNodes, 1);
    end
    
    % Extract the id to disconnect from
    nodesPlantoDisconnect = find(strategyPlan(:,1) == 2);
    if ~isempty(nodesPlantoDisconnect)
        toNodes = strategyPlan(nodesPlantoDisconnect,2);
        newAdjMatrix = helperMatrixUpdate(newAdjMatrix, nodesPlantoDisconnect, toNodes, 0);
    end

    % Add new matrix to 3D matrix
    adjMatrix(:, :, step + 1) = newAdjMatrix;
end