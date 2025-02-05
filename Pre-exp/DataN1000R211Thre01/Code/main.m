% main function: this is the only function that we need to run
% main function call JGRRun(N, T, Alpha, k, numIter)
function main

    n = 1000;
    thre = 0.1; % threshould of cutting the edge with previous collaborator

    maxNei = n;   
    T = 50;
    alpha = [0.25, 0.5, 0.75];
    K = [0.05, 0.1, 0.15, 0.2, 0.25, 0.5, 0.75];
    numIter = 20;
    
    for i = 1:length(alpha)
        for j = 1:length(K)
            namePara = helperNameGenerator(n, alpha(i), K(j));
            % disp(namePara);
            JGRRun(n, T, alpha(i), K(j), numIter, namePara, thre, maxNei);
        end
    end
end

% 
% %% Basic elements & init
% %% This function run the model numIterations times, and each time is terminated at t
% % The input of this function include: N, T, Alpha, k, numIter
% % Output of this function contains two xlsx files: T2GHistory, dynamicJRUpdate, adjMatrix
% function JGRRun(N, T, Alpha, k, numIter)