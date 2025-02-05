function updateT2G(step, currentT2GValues)

    global strategyPlan dynamicT2GUpdate

    newT2GValues = currentT2GValues;

    % transferNodes = intersect(find(strategyPlan(:,1) == 3), find(isnan(strategyPlan(:,2))));
    transferNodes = find(strategyPlan(:,1) == 3);
    if ~isempty(transferNodes)
        newT2GValues(transferNodes) = 1;
    end
    
    % Add new column to update T2G
    dynamicT2GUpdate(:,step+1) = newT2GValues;
end