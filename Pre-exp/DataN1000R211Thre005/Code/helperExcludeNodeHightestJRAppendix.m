%% This function if to find the node with multiple highest JR and return the id of nodes who faill to add
% Input:  currentNumNeighborTable (| 1-type | 2-#upperStreamNei | 3-#lowerStreamNei | 4- <=2 neighbor | 5- <2 neighbor | 6- >=5 neighbor |)
% candidate nodes, numNeighbors, and the currentJRValues
% Outout
function nodesNotChosen = helperExcludeNodeHightestJRAppendix(currentNumNeighborTable, currentT2G, currentJR, alpha, categoryAverageJR, numNeighbors, nodesToConnect, currentJRValues)
    global supplierRange retailerRange

    map = helperCreateMap();
    
    % Adjust the index by adding 2 to align with MATLAB indexing
    indexUpper = currentNumNeighborTable(2) + 2;
    indexLower = currentNumNeighborTable(3) + 2;

    availUpper = map(indexUpper);
    availLower = map(indexLower);
    
    if (currentNumNeighborTable(1)==2) % manufacture: select from upper and lower saperately
        nodesToConnectUpper = nodesToConnect(nodesToConnect <= supplierRange(end));
        nodesToConnectLower = nodesToConnect(nodesToConnect >= retailerRange(1));
        
        nodesNotChosenUpper = helperNodesNotChosen(nodesToConnectUpper, currentJRValues, numNeighbors, availUpper, currentT2G, currentJR, alpha, categoryAverageJR);
        nodesNotChosenLower = helperNodesNotChosen(nodesToConnectLower, currentJRValues, numNeighbors, availLower, currentT2G, currentJR, alpha, categoryAverageJR);
        nodesNotChosen = [nodesNotChosenUpper; nodesNotChosenLower];
    else % producer or retailer
        k = availUpper + availLower;
        nodesNotChosen = helperNodesNotChosen(nodesToConnect, currentJRValues, numNeighbors, k, currentT2G, currentJR, alpha, categoryAverageJR);
    end
    
    % % Find the node with the highest JR value
    % maxJR = max(currentJRValues(nodesToConnect));
    % maxJRNodes = intersect(find(currentJRValues == maxJR), nodesToConnect); % !!!
    % % If multiple, choose randomly
    % chosenNode = maxJRNodes(randi(length(maxJRNodes)));
    % 
    % % Calculate new JR value after adding the chosen node as neighbor
    % newJR = (1-alpha)*currentT2G + (currentJR*numNeighbors - (1-alpha)*currentT2G*numNeighbors + maxJR*alpha)/(numNeighbors+1); %!!!!
    % 
    % if newJR >= categoryAverageJR % If new JR value is still greater than category average JR
    %     % Update strategyPlan for the nodes that were not chosen
    %     nodesNotChosen = setdiff(nodesToConnect, chosenNode);
    % else % Otherwise all building new connection fail !!!
    %     nodesNotChosen = nodesToConnect;
    % end
end



