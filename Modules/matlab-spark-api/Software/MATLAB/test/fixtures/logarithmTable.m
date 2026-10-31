function L = logarithmTable()
    % logarithmTable table for log functions testing
    
    % Copyright 2026 MathWorks, Inc.
   
    x = (0:1:10)';
    ln = log(x);
    l1p = log1p(x);
    l2 = log2(x);
    L = table(x, ln, l1p, l2, ...
        'VariableNames', ["X", "Log", "Log1p", "Log2"]);
end