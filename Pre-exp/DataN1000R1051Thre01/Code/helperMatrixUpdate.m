%% This function is for updating the symmetric adjacency matrix
% The input of this function is the matrix, fromNodes, toNodes, and
% ifConnect
% ifConnect = 0 or 1, 0 means cutoff the links, 1 means build the links
% The output of this function is the updated symmetric matrix
function mymatrix = helperMatrixUpdate(mymatrix, fromNodes, toNodes, ifConnect)
    
    % Validate that fromNodes and toNodes have the same length
    if length(fromNodes) ~= length(toNodes)
        error('fromNodes and toNodes must have the same length');
    end

    mymatrix(sub2ind(size(mymatrix), fromNodes, toNodes)) = ifConnect; % Update M(fromNodes(i), toNodes(i)) for all i
    mymatrix(sub2ind(size(mymatrix), toNodes, fromNodes)) = ifConnect;  % Update M(toNodes(i), fromNodes(i)) for all i (symmetric)
end

%% Test
% myMatrix = zeros(3, 3);
% fromNodes = [1,2];
% toNodes = [3,3];
% myMatrix = helperMatrixUpdate(myMatrix, fromNodes, toNodes, 1);
% display(myMatrix);
% % Expected outcome
% % 0 0 1
% % 0 0 1
% % 1 1 0
% % Passed

% myMatrix = ones(3, 3);
% fromNodes = [1,2];
% toNodes = [3,3];
% myMatrix = helperMatrixUpdate(myMatrix, fromNodes, toNodes, 0);
% display(myMatrix);
% % Expected outcome
% % 1 1 0
% % 1 1 0
% % 0 0 1
% % Passed