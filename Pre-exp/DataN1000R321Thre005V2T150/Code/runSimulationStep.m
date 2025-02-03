function runSimulationStep()
    global t adjMatrix dynamicT2GUpdate dynamicJRUpdate steadyState

    % Time step threshold for stable detection
    steadyStateThreshold = 2;
    noChangeSteps = 0; 

    for step = 1:t
        % Get the current T2G and adjMatrix
        currentT2GValues = dynamicT2GUpdate(:, step);
        currentJRValues = dynamicJRUpdate(:, step);
        currentAdjMatrix = adjMatrix(:, :, step);
        
        % currentNumNeighborTable: | type | #upperStreamNei | #lowerStreamNei | <=2 | neighbor | <2 neighbor |
        currentNumNeighborTable = helperCurrentNumNeighborTable(currentAdjMatrix);

        %First Strategy Plan
        strategyFirstPlan2(currentJRValues, currentAdjMatrix, currentNumNeighborTable);

        % Check Add Success Strategy Plan
        strategyCheckAddSuccess2(currentJRValues, currentAdjMatrix, currentT2GValues, currentNumNeighborTable);

        % Update Fail Add Strategy Plan (final version)
        strategyFailAddUpdate2(currentJRValues, currentAdjMatrix, currentT2GValues);

        % Update T2G based on the strategy plan
        updateT2G(step, currentT2GValues);

        % Update adjacency matrix based on the strategy plan
        updateAdjacencyMatrix(step, currentAdjMatrix);

        % Update JR based on the new adjacency matrix and T2G values
        updateJR(step, dynamicT2GUpdate(:, step+1), adjMatrix(:, :, step+1));

         % Check changes of T2G and adjMatrix
        if isequal(currentT2GValues, dynamicT2GUpdate(:, end)) && isequal(currentAdjMatrix, adjMatrix(:, :, end))
            noChangeSteps = noChangeSteps + 1;
        else
            noChangeSteps = 0;
        end

        % If there is no change for several time steps, steady state is considered to be reached
        if noChangeSteps >= steadyStateThreshold
            disp('Steady state reached at:');
            disp(step);
            steadyState = step;
            break;
        end
    end
end
