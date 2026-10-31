function generateExampleSchema
    % GENERATEEXAMPLESCHEMA Generate schema file with datatype information

    DI = DemoInfo();

    s = load( ...
        "+deploy/SampleInputOutputTables.mat", ...
        "SampleInputTable", "SampleOutputTable");
    
    generateFunctionSchema(...
        DI.FuncName, ... The name of the function
        {s.SampleInputTable} ... Values corresponding to input type(s)
        ...{s.SampleOutputTable} ... Values corresponding to output type(s)
        );

    % The 3rd argument, for output types, is optional. If possible, it will
    % be deduced by calling the function with the input values.
end