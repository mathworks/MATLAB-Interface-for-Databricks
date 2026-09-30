function T_OUT = addStringCol(T_IN)
    % addStringCol
    %
    % This is used as an example in
    %   Modules/matlab-spark-api/Documentation/PythonSparkBuilder.md

    % Copyright 2024 The MathWorks, Inc.


    T_OUT = T_IN;
    T_OUT.hello = string(T_IN.id) + "_hello_" + string(T_IN.did);

end

