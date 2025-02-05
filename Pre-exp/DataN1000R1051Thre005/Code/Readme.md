> This exp changes:

- Change the rate of three types of company from ~~211~~ to 10 5 1
  
  ```matlab
  % JGRRun Line 65
  % 10:5:1
  numSuppliers = round(n * 0.625);
  numManufacturers = round(n * 0.3125);
  numRetailers = n - numSuppliers - numManufacturers;
  ```

- Shorten the dynamic from ~~T = 150~~ to T = 50
  
  ```matlab
  % Main Line 8
  ```

> This exp keeps:

- the tolerance is power law distributed, and the lower_bound is 0.05, upper_bound is 0.1

- the threshould of cutting the edge with previous collaborator is 0.05

## strategyFirstPlan2

    - tolerance 
    % if below the average of the industry this much

## helperFindLowestJRNeighbor

    - global threshold
    - abs(minNeighborJR - currentNodeJR) > threashold