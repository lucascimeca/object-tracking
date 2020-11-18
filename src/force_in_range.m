function value = force_in_range(val, min ,max)
% function forcing values within into a range
    value = val;
    if val < min
        value = min;
    end
    if max < val
        value = max;
    end
end