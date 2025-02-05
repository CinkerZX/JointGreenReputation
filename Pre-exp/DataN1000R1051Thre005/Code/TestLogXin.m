%% This script is for testing
N = 10;
T = 2;
Alpha = 0.2;
k = 0.25;
numIter = 2;

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
% Initialize variables
n = N;  % {20,500}
t = T; % Termination times
alpha = Alpha;  % {0.2,0.5,0.7}
K = k;  % {0.25,0.5,0.75}

% Initialize strategy plan n*2 matrix
numIterations = numIter;  % Number of repetitions for the experiment
steadyState = t;     % Terminating time step

% **********************************************
% allData = cell(1, numIterations);

% Let the node be equally distributed
numSuppliers = round(n * 0.33);
numManufacturers = round(n * 0.33);
numRetailers = n - numSuppliers - numManufacturers;

% Index ranges
supplierRange = 1:numSuppliers;
manufacturerRange = numSuppliers + 1 : numSuppliers + numManufacturers;
retailerRange = numSuppliers + numManufacturers + 1 : n;

currentIteration = 1;

adjMatrix = createAdjacencyMatrix();
currentAdjMatrix = adjMatrix;

% %% Test helperCheckNodeTypeReturnNeighbors
% i = 2;
% [class, upperNeighbors, lowerNeighbors]=helperCheckNodeTypeReturnNeighbors(i, currentAdjMatrix);
% % Expected outcome
% % 1, 0, [4 5 6]
% 
% i = 4;
% [class, upperNeighbors, lowerNeighbors]=helperCheckNodeTypeReturnNeighbors(i, currentAdjMatrix)
% % Expected outcome
% % 2, [1 2 3], [7 8 9 10]
% 
% i = 10;
% [class, upperNeighbors, lowerNeighbors]=helperCheckNodeTypeReturnNeighbors(i, currentAdjMatrix)
% % Expected outcome
% % 3, [4 5 6], 0
% % AllPASS

% %% Test helperCurrentNumNeighborTable(currentAdjMatrix)
% table = helperCurrentNumNeighborTable(currentAdjMatrix);
% % PASS


%% Test strategyFirstPlan2
% ============ JGRRun() ============ 
initialT2GValues = zeros(n, 1);
% Random choose nK nodes be green
initialG = randperm(n, round(n * K));
initialT2GValues(initialG) = 1;
T2GHistory((currentIteration-1)*t+1,:) = initialT2GValues';
% Initialize dynamicT2GUpdate
dynamicT2GUpdate = initialT2GValues;

% Calculate joint green repuataion
dynamicJRUpdate = jrCalculate();

% ============ runSimulationStep() ============ 
currentT2GValues = dynamicT2GUpdate(:, end);
currentJRValues = dynamicJRUpdate(:, end);
currentAdjMatrix = adjMatrix(:, :, end);

% currentNumNeighborTable: | type | #upperStreamNei | #lowerStreamNei | <=2 | neighbor | <2 neighbor |
currentNumNeighborTable = helperCurrentNumNeighborTable(currentAdjMatrix);

% ============ strategyFirstPlan2() ============ 
% currently PASS

% ============ strategyCheckAddSuccess2() ============ 













