> This exp changes:

* Changes the rate of three types of company from ~~321~~ to 211
  
  ```matlab
  % JGRRun Line 65
  % 2:1:1
  numSuppliers = round(n * 0.5);
  numManufacturers = round(n * 0.25);
  numRetailers = n - numSuppliers - numManufacturers;
  ```

>  This exp keeps:

- the tolerance is power law distributed, and the lower_bound is 0.05, upper_bound is 0.1
- The threshould of cutting the edge with previous collaborator (threshold) is 0.1

## strategyFirstPlan2

    - tolerance  % if below the average of the industry this much

## helperFindLowestJRNeighbor

    - global threshold
    - abs(minNeighborJR - currentNodeJR) > threashold