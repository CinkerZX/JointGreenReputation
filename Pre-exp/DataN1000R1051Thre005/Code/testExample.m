clc;
%addpath(genpath('D:\uva\courses\thesis\code'))

global n;
global t;                    %t=0
global K;%size: t+1x1   update[K0,0.4,0.2,...]
global alpha;
global numSuppliers;
global numManufacturers;
global numRetailers;
global supplierRange;
global manufacturerRange
global retailerRange
global initialT2GValues;
global initialJRValues;
global adjMatrix;
global strategyPlan;
global dynamicT2GUpdate;
global dynamicJRUpdate;

%---------------------------------------------------------------------
n = 11;
supplierRange = 1:3;
manufacturerRange = 4:7;
retailerRange = 8:11;
disp('supplierRange:');
disp(supplierRange);
disp('manufacturerRange:');
disp(manufacturerRange);
disp('retailerRange:');
disp(retailerRange);

% Test First Plan

% adjMatrix = [
%     0 0 0 0 1 1 1 0 0 0 0;
%     0 0 0 1 1 1 0 0 0 0 0;
%     0 0 0 0 1 1 1 0 0 0 0;
%     0 1 0 0 0 0 0 0 1 1 1;
%     1 1 1 0 0 0 0 0 1 0 1;
%     1 1 1 0 0 0 0 1 1 0 1;
%     1 0 1 0 0 0 0 1 1 1 0;
%     0 0 0 0 0 1 1 0 0 0 0;
%     0 0 0 1 1 1 1 0 0 0 0;
%     0 0 0 1 0 0 1 0 0 0 0;
%     0 0 0 1 1 1 0 0 0 0 0
% ];

%initialT2GValues = [1 0 1 1 0 0 1 0 1 0 1];

%initialJRValues = [0.2 0 0.2 0.2 0.2 0 0.2 0 0.2 0 0.2];
%-------------------------------------------------------------------------
% Test Update Plan

adjMatrix = [
    0 0 0 0 1 1 1 0 0 0 0;
    0 0 0 0 1 1 0 0 0 0 0;
    0 0 0 0 1 1 1 0 0 0 0;
    0 0 0 0 0 0 0 0 1 1 1;
    1 1 1 0 0 0 0 0 1 0 1;
    1 1 1 0 0 0 0 1 1 0 1;
    1 0 1 0 0 0 0 1 1 1 0;
    0 0 0 0 0 1 1 0 0 0 0;
    0 0 0 1 1 1 1 0 0 0 0;
    0 0 0 1 0 0 1 0 0 0 0;
    0 0 0 1 1 1 0 0 0 0 0
];

for i = 1:n
        neighbors = find(adjMatrix(i,:,1)); 
        fprintf('Node %d has neighbors: %s\n', i, mat2str(neighbors)); 
end

initialT2GValues = zeros(n, 1);
initialT2GValues = [0 
                    1 
                    0 
                    1 
                    0 
                    0 
                    0 
                    0 
                    1 
                    0 
                    1];

initialJRValues = [0 
                   0.2 
                   0 
                   0.2 
                   0 
                   0 
                   0 
                   0 
                   0.2 
                   0 
                   0.2];

dynamicT2GUpdate = initialT2GValues;
dynamicJRUpdate = initialJRValues;

disp('initial T2G:');
disp(dynamicT2GUpdate);
disp('initial JR:');
disp(dynamicJRUpdate);
%-------------------------------------------------------------------------

% Initialize variables
% % n = 50;  % {50,500,5000}
t = 10;
alpha = 0.2;  % {0.2,0.5,0.7}
K = 0.25;  % {0.25,0.5,0.75}
% Initialize strategy plan cell array
strategyPlan = cell(n, 1);

% Let the node be equally distributed
%numSuppliers= randi([1, n-2]);
%numManufacturers = randi([1, n-numSuppliers-1]);
% % numSuppliers = round(n * 0.33);
% % numManufacturers = round(n * 0.33);
% % numRetailers = n - numSuppliers - numManufacturers;

% % Index ranges
% supplierRange = 1:numSuppliers;
% manufacturerRange = numSuppliers + 1 : numSuppliers + numManufacturers;
% retailerRange = numSuppliers + numManufacturers + 1 : n;
% disp('supplierRange:');
% disp(supplierRange);
% disp('manufacturerRange:');
% disp(manufacturerRange);
% disp('retailerRange:');
% disp(retailerRange);

% Create initial adjacency matrix (t=0)
% % adjMatrix = createAdjacencyMatrix(n, supplierRange, manufacturerRange, retailerRange);
disp(adjMatrix(:,:,1)); 

% % Initial value of T2G
% initialT2GValues = zeros(n, 1);
% % Random choose nK nodes be green
% initialG = randperm(n, round(n * K));
% initialT2GValues(initialG) = 1;
% disp('initialT2GValues:');
% showTable(n, initialT2GValues);
% % Initialize dynamicT2GUpdate
% dynamicT2GUpdate = initialT2GValues;

% %initial value of JR
% weightT2G = 1 - alpha;
% initialJRValues = weightT2G * initialT2GValues;
% % Initialize dynamicJRUpdate
% dynamicJRUpdate = initialJRValues; 
% disp('initialJRValues:');
% showTable(n, initialJRValues);

%First Strategy Plan
strategyFirstPlan(supplierRange, manufacturerRange, retailerRange, n);
disp('strategyFirstPlan:');
disp(strategyPlan);

% Check Add Success Strategy Plan
strategyCheckAddSuccess(supplierRange, manufacturerRange, retailerRange, n, alpha);
disp('strategyCheckAddSuccess:');
disp(strategyPlan);

% Update Fail Add Strategy Plan (final version)
strategyFailAddUpdate(n);
disp('strategyFailAddUpdate:');
disp(strategyPlan);

% Update T2G
updateT2G();
disp('update T2G:');
disp(dynamicT2GUpdate);

% Update adjMatric
updateAdjacencyMatrix();
disp('Updated adjacency matrix:');
disp(adjMatrix(:, :, end));
for i = 1:n
    neighbors = find(adjMatrix(i, :, end)); 
    fprintf('Node %d has neighbors: %s\n', i, mat2str(neighbors)); 
end

% Update JR value
updateJR(alpha);
disp('Updated JR values:');
disp(dynamicJRUpdate);