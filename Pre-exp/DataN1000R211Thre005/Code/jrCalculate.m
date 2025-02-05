%% This function is for calculate the Joint-green Reputation
% Output: the vector of JR: n*1
function JR = jrCalculate(currentT2G, currentAdjMatrix)
    global n alpha

    % Degree matrix D (n x n)
    D = diag(sum(currentAdjMatrix, 2));
    
    % Identity matrix I (n x n)
    I = eye(n);
    
    % Initialize the JR vector
    JR = zeros(n, 1);

    % Calculate JR for agents with at least one neighbor
    hasNeighbors = (diag(D) > 0);  % Logical vector for agents with neighbors
    
    % Apply the original formula only for agents with neighbors
    JR(hasNeighbors) = (I(hasNeighbors, hasNeighbors) - alpha * (D(hasNeighbors, hasNeighbors) \ currentAdjMatrix(hasNeighbors, hasNeighbors))) ...
                        \ ((1 - alpha) * currentT2G(hasNeighbors));

    % For agents with no neighbors, set JR to their T2G values
    JR(~hasNeighbors) = currentT2G(~hasNeighbors);
end