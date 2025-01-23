%% This function if to find the node with the highest JR and return the id of nodes who faill to add
% Input: candidate nodes, numNeighbors, and the currentJRValues
% Outout
function nodesNotChosen = helperExcludeNodeHightestJR(currentT2G, currentJR, alpha, categoryAverageJR, numNeighbors, nodesToConnect, currentJRValues)
    % Find the node with the highest JR value
    maxJR = max(currentJRValues(nodesToConnect));
    maxJRNodes = intersect(find(currentJRValues == maxJR), nodesToConnect); % !!!
    % If multiple, choose randomly
    chosenNode = maxJRNodes(randi(length(maxJRNodes)));

    % Calculate new JR value after adding the chosen node as neighbor
    newJR = (1-alpha)*currentT2G + (currentJR*numNeighbors - (1-alpha)*currentT2G*numNeighbors + maxJR*alpha)/(numNeighbors+1); %!!!!

    if newJR >= categoryAverageJR % If new JR value is still greater than category average JR
        % Update strategyPlan for the nodes that were not chosen
        nodesNotChosen = setdiff(nodesToConnect, chosenNode);
    else % Otherwise all building new connection fail !!!
        nodesNotChosen = nodesToConnect;
    end
end