function generateSchemas()
    % generateSchemas Generate example schemas
    %
    % This is used as an example in
    %   Modules/matlab-spark-api/Documentation/PythonSparkBuilder.md

    % Copyright 2024-2025 The MathWorks, Inc.


    sigFile = "plusPi.schema";
    if ~isfile(sigFile)
        generateFunctionSchema("plusPi", {33})
    end

    sigFile = "doMath.schema";
    if ~isfile(sigFile)
        generateFunctionSchema("doMath", {3, 4.5})
    end

    sigFile = "addStringCol.schema";
    if ~isfile(sigFile)
        id = int64(1:10)';
        did = (1:10)';
        DF_T = table(id, did);
        generateFunctionSchema("addStringCol", {DF_T})
    end

end