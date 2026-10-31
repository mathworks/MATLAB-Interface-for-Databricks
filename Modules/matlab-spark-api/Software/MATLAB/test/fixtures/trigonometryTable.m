function T = trigonometryTable()
    % trigonometryTable Create example table for testing
    
    % Copyright 2020 MathWorks, Inc.
   
    x = (-10:.2:10)';
    absx = abs(x);
    s = sin(x);
    c = cos(x);
    t = tan(x);
    as = asin(s);
    ac = acos(c);
    at = atan(t);
    T = table(x,absx, s, c, t, as, ac, at, ...
        'VariableNames', ["X", "AbsX", "Sine", "Cosine", "Tangent", "Arcsine", "Arccosine", "Arctangent"]);
end
