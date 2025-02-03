%% This function is to find the neighbor who has the lowest JR of the focal
% Input:
% Output: id of the selected neighbor
function [idNeighbor, minNeighborJR] = helperFindLowestJRNeighbor(currentJRValues, currentNodeJR, neighbors)
    global threashold
    idNeighbor = [];
    minNeighborJR = min(currentJRValues(neighbors));
    if abs(minNeighborJR - currentNodeJR) > threashold
        minJRNodes = intersect(find(currentJRValues == minNeighborJR), neighbors);
        % If multiple, choose randomly
        idNeighbor = minJRNodes(randi(length(minJRNodes)));
    end
end