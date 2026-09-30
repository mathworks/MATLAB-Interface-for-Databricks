function funcName = inputNames_PythonWrapper(file)
    % inputNames_PythonWrapper Generate inputNames function/variable

    % Copyright 2026 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.PythonFileV2
    end

    funcName = sprintf("%s_input_names", file.funcName);
    fieldName = "inputNames";
    
    if isfield(file.API, fieldName)
        return % This was already generated, don't bother
    end

    PSB = file.Parent;
    % Setup local variables
    PyW = PSB.PyW;

    useMetrics = PSB.useMetrics(file);

    [inputSchema, inputNames] = generatePythonPandasSchema(file, isOut=false);

    file.API.(fieldName) = funcName;
    SW = PyW.newMethod();
    SW.pf("%s = ['%s']\n", funcName, join(inputNames, "', '"));

    % We need the types that are returned as schema
    file.API.inputSchema = sprintf("%s_input_schema", file.funcName);
    SW.pf("%s = '%s'\n", file.API.inputSchema, inputSchema);

    PyW.addMethod(SW);

end

