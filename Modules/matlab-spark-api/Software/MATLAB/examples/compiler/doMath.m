function [x,y] = doMath(a, b)
    % doMath
    %
    % This is used as an example in
    %   Modules/matlab-spark-api/Documentation/PythonSparkBuilder.md

    % Copyright 2024 The MathWorks, Inc.

    x = -(a + b);
    y = int64(a * b);
end
