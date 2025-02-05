%% This function is to filter the neighbors from potential ones
% Only the ones whose current JR > the average of their peers count
% Input: id of potential neighbors and the constructed currentJRPeerTable
function filteredNeighbors = filteredNeighborsGenerate(potentialNeighbors, currentJRPeerJRTable)
    
    filteredNeighbors = potentialNeighbors(currentJRPeerJRTable(potentialNeighbors,1)>=currentJRPeerJRTable(potentialNeighbors,2));    
    
end