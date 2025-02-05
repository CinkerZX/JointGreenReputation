function showTable(n, matrix)
    IDs = (1:n)';
    T = table(IDs, matrix, 'VariableNames', {'ID', 'Value'});
    disp(T);
end