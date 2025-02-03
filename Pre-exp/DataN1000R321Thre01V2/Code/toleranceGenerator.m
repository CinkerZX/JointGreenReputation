%% This function is to generate the individual tolerance for the N firms
% Input: 

function tolerance_N  = toleranceGenerator(N, lower_bound, upper_bound)
    % N = 1000; % Replace with your desired size
    % lower_bound = 0.05;
    % upper_bound = 0.2;
    
    alpha = 1.8; % Adjust alpha to control the distribution shape
    
    % Generate the inverse power-law distributed vector
    tolerance = (1 - rand(N, 1) .^ alpha) * (upper_bound - lower_bound) + lower_bound;
    
    % Sort them randomly
    tolerance_N = tolerance(randperm(N));
    % % Plot the histogram
    % histogram(random_vector, 50); % 50 bins for better visualization
    % xlabel('Value');
    % ylabel('Frequency');
    % title('Inverse Power Distribution of Random Vector');
end