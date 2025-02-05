function map = helperCreateMap()
    global maxNeighbor
    % Create a descending vector from maxNeighbor to 1
    descendingValues = maxNeighbor:-1:1;
    
    % Prepend 0 to the beginning
    map = [0, descendingValues,0];
end