function plan = helperPlanUpdate(plan, index, value)
    replacement = repmat(value, length(index), 1);
    plan(index, :) = replacement;
end