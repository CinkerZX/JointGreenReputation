function namePara = helperNameGenerator(n, alpha, k)
    % Convert parameters to strings with appropriate formatting
    nStr = ['N', num2str(n)];
    alphaStr = ['Alpha', num2str(alpha, '%.2f')];
    kStr = ['k', num2str(k, '%.2f')];

    % Combine the parts with underscores for readability
    namePara = [nStr, alphaStr, kStr];
    
    % Replace dots with underscores to ensure valid filenames
    namePara = strrep(namePara, '.', '');
end