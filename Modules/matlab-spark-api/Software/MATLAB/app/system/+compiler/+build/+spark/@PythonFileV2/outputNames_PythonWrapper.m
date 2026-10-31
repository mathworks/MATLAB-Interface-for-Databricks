function funcName = outputNames_PythonWrapper(file)
    % outputNames_PythonWrapper Generate outputNames function/variable
    %

    % Copyright 2023-2026 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.PythonFileV2
    end

    funcName = sprintf("%s_output_names", file.funcName);
    fieldName = "outputNames";
    
    if isfield(file.API, fieldName)
        return % This was already generated, don't bother
    end

    PSB = file.Parent;
    % Setup local variables
    PyW = PSB.PyW;

    useMetrics = PSB.useMetrics(file);

    [outputSchema, outNames] = generatePythonPandasSchema(file, isOut=true);

    file.API.(fieldName) = funcName;
    SW = PyW.newMethod();
    SW.pf("%s = ['%s']\n", funcName, join(outNames, "', '"));

    % We need the types that are returned as schema
    file.API.outputSchema = sprintf("%s_output_schema", file.funcName);
    SW.pf("%s = '%s'\n", file.API.outputSchema, outputSchema);

    PyW.addMethod(SW);

end

