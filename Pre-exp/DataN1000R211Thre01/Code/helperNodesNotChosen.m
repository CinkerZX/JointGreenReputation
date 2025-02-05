function nodesNotChosen = helperNodesNotChosen(nodesToConnect, currentJRValues, numNeighbors, k, currentT2G, currentJR, alpha, categoryAverageJR)
    % Sort nodesToConnect by their JR values in descending order
    [sortedJRValues, sortedIndices] = sort(currentJRValues(nodesToConnect), 'descend');
    sortedNodesToConnect = nodesToConnect(sortedIndices);
    
    % Initialize variables to track chosen nodes and updated JR calculation
    chosenNodes = [];  % To store accepted nodes
    currentNumNeighbors = numNeighbors;  % Keep track of updated number of neighbors

    
    for i = 1:length(sortedNodesToConnect)
        if length(chosenNodes) >= k
            break;  % Stop if we've reached the maximum number of accepted invitations
        end
    
        % Select the next node to consider
        candidateNode = sortedNodesToConnect(i);
        candidateJR = currentJRValues(candidateNode);
    
        % Calculate the new JR after potentially connecting with this node
        newJR = (1 - alpha) * currentT2G + (currentJR * currentNumNeighbors ...
                - (1 - alpha) * currentT2G * currentNumNeighbors + candidateJR * alpha) / (currentNumNeighbors + 1);
    
        % Check if the new JR is still greater than or equal to category average JR
        if newJR >= categoryAverageJR
            % Accept the connection
            chosenNodes = [chosenNodes; candidateNode];
            
            % Update current JR and neighbor count for the next calculation
            currentJR = newJR;
            currentNumNeighbors = currentNumNeighbors + 1;
        end
    end
    nodesNotChosen = setdiff(nodesToConnect, chosenNodes);
end