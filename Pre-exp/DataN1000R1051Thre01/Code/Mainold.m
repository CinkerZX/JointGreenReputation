clc;
%addpath(genpath('D:\uva\courses\thesis\code'))
%% Basic elements & init
global n;                    % #companies n = numSuppliers+numManufacturers+numRetailers
global numSuppliers;        
global numManufacturers;
global numRetailers;
global supplierRange;        % id of suppliers; dimension: 1*numSuppliers
global manufacturerRange;    % id of manufactures; dimension: 1*numManufactures
global retailerRange;        % id of retailers; dimension: 1*numRetailers

global t;                    % timestep; t=0
global K;                    % init tran ratio
global initialT2GValues;     % Dimension: n*1

global alpha;                % weight of joint green reputation
%% network structure
global adjMatrix;

%% Dynamics
global strategyPlan;        % dimension: n*1
global dynamicT2GUpdate;    % dimension: n*1
global dynamicJRUpdate;     % dimension: n*(t+1)
global steadyState;         % the time step of reaching stable state

%% Each experiment is terminated at t and is repreated numIterations times

% Initialize variables
n = 20;  % {20,500}
t = 500;
alpha = 0.7;  % {0.2,0.5,0.7}
K = 0.75;  % {0.25,0.5,0.75}
% Initialize strategy plan n*2 matrix
strategyPlan = zeros(n, 2);
steadyState = t;     % Terminating time step
numIterations = 30;  % Number of repetitions for the experiment
allData = cell(1, numIterations);

% Let the node be equally distributed
numSuppliers = round(n * 0.33);
numManufacturers = round(n * 0.33);
numRetailers = n - numSuppliers - numManufacturers;

% Index ranges
supplierRange = 1:numSuppliers;
manufacturerRange = numSuppliers + 1 : numSuppliers + numManufacturers;
retailerRange = numSuppliers + numManufacturers + 1 : n;
% disp('supplierRange:');
% disp(supplierRange);
% disp('manufacturerRange:');
% disp(manufacturerRange);
% disp('retailerRange:');
% disp(retailerRange);

for currentIteration = 1:numIterations
    % Create initial adjacency matrix (t=0)
    adjMatrix = createAdjacencyMatrix();
    % disp(adjMatrix(:,:,1)); 
    
    % Initial value of T2G
    initialT2GValues = zeros(n, 1);
    % Random choose nK nodes be green
    initialG = randperm(n, round(n * K));
    initialT2GValues(initialG) = 1;
    % disp('initialT2GValues:');
    % showTable(n, initialT2GValues);
    % Initialize dynamicT2GUpdate
    dynamicT2GUpdate = initialT2GValues;
    
    % Calculate joint green repuataion
%     weightT2G = 1 - alpha;
%     initialJRValues = weightT2G * initialT2GValues;
    % Initialize dynamicJRUpdate
    dynamicJRUpdate = jrCalculate();
    
    %First Strategy Plan
%     strategyFirstPlan();
    strategyFirstPlan2();
    
    % Check Add Success Strategy Plan
%     strategyCheckAddSuccess(supplierRange, manufacturerRange, retailerRange, n, alpha);
    strategyCheckAddSuccess2()
    
    % Update Fail Add Strategy Plan (final version)
%     strategyFailAddUpdate(n);
    strategyFailAddUpdate2()
    
    % Update T2G
    updateT2G();
    
    % Update adjMatric
    updateAdjacencyMatrix();
    
    % Update JR value
    updateJR();
    % disp('Updated JR values:');
    % disp(dynamicJRUpdate);
    
    % Loop for t iterations
    %runIterations(t, alpha, numIterations);
    runIterations();
    allData{currentIteration} = dynamicT2GUpdate;
end

filename = 'D:\uva\courses\thesis\AllIterationsData.xlsx';
for i = 1:numIterations
    sheetName = ['Iteration ' num2str(i)];
    writematrix(allData{i}, filename, 'Sheet', sheetName);
end

%Plot average T2G Diffusion Curve
plotAverageT2GDiffusionCurve(t, numIterations)

% Plot the T2G diffusion curve
% plotT2GDiffusionCurve(steadyState);

% Plot the JR diffusion curve
%plotJRDiffusionCurve(t);

% Plot AdjMatrix Structure
%plotAdjMatrixStructure();

% Plot average degree and variancce degree
%outputDegreeStatsTable();