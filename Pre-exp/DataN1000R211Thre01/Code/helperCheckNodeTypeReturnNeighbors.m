%% This function is to check if a node is a manufacture
% Input: if of the node
% Output: class := 1, 2, 3; upperNeighbors: id of upper stream neighbors;
% lowerNeighbors: if of lower stream neighbors
function [class, upperNeighbors, lowerNeighbors]=helperCheckNodeTypeReturnNeighbors(i, currentAdjMatrix)
    global supplierRange manufacturerRange retailerRange n
    
    allNodes = 1:1:n;
    isSupplier = ismember(i, supplierRange);
    isManufacture = ismember(i, manufacturerRange);
    isRetailer = ismember(i, retailerRange);
    
    if isSupplier
        class = 1;
        upperNeighbors = -1;
        lowerNeighbors = allNodes(currentAdjMatrix(i,:) == 1);
        return;
    end
    
    if isManufacture
        class = 2;
        neighbors = allNodes(currentAdjMatrix(i,:) == 1);
        upperNeighbors = neighbors(neighbors < manufacturerRange(1));
        lowerNeighbors = neighbors(neighbors > manufacturerRange(end));
        return;
    end
    
    if isRetailer
        class = 3;
        upperNeighbors = allNodes(currentAdjMatrix(i,:) == 1);
        lowerNeighbors = -1;        
        return;
    end
    
end