%% This function is to update the plan for nodes who failed to build new connection
% !!!
% If adding neighbors fail, then need to either cutoff with the neighbor
% who has the lowest JR, or trans
% Alg: Already trans? (if the focal already trans, but add fail, then there must be neighbors with low JR)
%        Y: Cutoff with lowest neighbor
%        N: Has neighbor? (first consider to cutting off, unless the focal is the loest)
%               N: trans (I have no neighbors, I haven't trans)
%               Y: is the JR of the focal lower than all neighbors?
%                        Y: trans
%                        N: cut off with the lowest neighbor
function strategyFailAddUpdate2(currentJRValues, currentAdjMatrix, currentT2GValues)
    global strategyPlan

    % Find all nodes that failed add [1,-1]
    failedNodes = find(strategyPlan(:,2) == -1);
    numFailedNodes = length(failedNodes);
    
    % currentNumNeighborTable(failedNodes(i), 4) == 1 if #neighbors <=2;
    % ==0, otherwise

    if numFailedNodes > 0
        for i = 1:numFailedNodes
            node = failedNodes(i);
            neighbors = find(currentAdjMatrix(node, :) == 1);
            hasNeighbors = ~isempty(neighbors);
            alreadyTransferred = currentT2GValues(node);
             
            if alreadyTransferred
                % Already transformed, has high JR, but cannot add
                %  -> cutoff with neighbor who has the lowest JR
                [idminNeighbor, ] = helperFindLowestJRNeighbor(currentJRValues, currentJRValues(node), neighbors);
                if isempty(idminNeighbor)
                    % do nothing ~ [0, NaN]
                    strategyPlan = helperPlanUpdate(strategyPlan, node, [0, NaN]);
                else
                    % cutoff with neighbor who has the lowest JR
                    strategyPlan = helperPlanUpdate(strategyPlan, node, [2, idminNeighbor]);
                end                
            elseif ~hasNeighbors
                % No neighbors, transfer
                % Note that, for manufactures, no neighbors means they have
                % no upper or lower partners. If they have only on stream
                % partners, that also means there might be potential
                % partner with low JR can be cut off
                strategyPlan = helperPlanUpdate(strategyPlan, node, [3, NaN]);
            else
                % Has neighbors
                [idminNeighbor, minNeighborJR] = helperFindLowestJRNeighbor(currentJRValues, currentJRValues(node), neighbors);
                if currentJRValues(node) < minNeighborJR
                    % I have the lowest JR, transfer
                    strategyPlan = helperPlanUpdate(strategyPlan, node, [3, NaN]);
                else
                    if isempty(idminNeighbor)
                    % do nothing ~ [0, NaN]
                    strategyPlan = helperPlanUpdate(strategyPlan, node, [0, NaN]);
                    else
                        % cutoff with neighbor who has the lowest JR
                        strategyPlan = helperPlanUpdate(strategyPlan, node, [2, idminNeighbor]);
                    end
                end
            end
        end
    end
end