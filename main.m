% main function: this is the only function that we need to run
% main function call JGRRun(N, T, Alpha, k, numIter)
function main
    % Pilot experiments setting
    % n = 20;
    % T = 20;
    % maxNei = 5;
    n = 100;
    maxNei = 30;
    T = 30;
    alpha = [0.25, 0.5, 0.75];
    K = [0.25, 0.5, 0.75];
    % alpha = 0.25;
    % K = 0.25;
    
    numIter = 30;
    thre = 0.05;
    
    
    for i = 1:length(alpha)
        for j = 1:length(K)
            namePara = helperNameGenerator(n, alpha(i), K(j));
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