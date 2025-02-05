function cutoffNeighborAddfail(i, typeofNode, neighbors, currentJRValues)
    global strategyPlan supplierRange manufacturerRange ;
    if typeofNode == 2 % if the node is a manufacture. Idea1: maintain at least one connection with suppliers / retailers;
        % idea2: cut off with the neighbor who is from the specific side which has more than 5 cooperators, and meanwhile has the lowest JR
        neighbors_suppliers = neighbors(neighbors <= supplierRange(end));
        neighbors_retailers = neighbors(neighbors > manufacturerRange(end));
        if sum(neighbors_suppliers) >= sum(neighbors_retailers) % need to cut with one supplier neighbor
            neighbors = neighbors_suppliers;
        else % need to cut with one retailer neighbors
            neighbors = neighbors_retailers;
        end
    end
    % if the node is not manufacture, just find the lowest JR of needtoCut(i)'s neighbor, and cut connection
    minJR = min(currentJRValues(neighbors));
    minJRNeighbors = neighbors(currentJRValues(neighbors) == minJR);
    % Random choose one if there are multiple
    neighborToDisconnect = minJRNeighbors(randi(length(minJRNeighbors)));
    strategyPlan = helperPlanUpdate(strategyPlan, i, [2, neighborToDisconnect]);
end