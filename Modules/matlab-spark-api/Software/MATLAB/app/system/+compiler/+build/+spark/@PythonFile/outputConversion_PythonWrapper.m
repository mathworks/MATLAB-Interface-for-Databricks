function funcName = outputConversion_PythonWrapper(file)
    % outputConversion_PythonWrapper Convert outputs if necessary
    %

    % Copyright 2023 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.File
    end

    funcName = sprintf("__%s_outputConversions", file.funcName);
    fieldName = "outputConversion";
    
    if isfield(file.API, fieldName)
        return % This was already generated, don't bother
    end

    PSB = file.Parent;
    % Setup local variables
    PyW = PSB.PyW;

    file.API.(fieldName) = funcName;
    SW = PyW.newMethod();

    SW.pf("def %s(results):\n", funcName);
    SW.indent();
    SW.pf('"""The function %s_mapPartitions has outputs that need to be\n', file.funcName);
    SW.pf('transformed between MATLAB and Python in a non-trivial way."""\n');
    SW.pf('for row in results:\n');
    SW.indent();
    outElems = file.getOutputElements();
    conversions = string.empty();
    for k=1:length(outElems)
        conversions(k) = outElems(k).convertMWValueForPython(sprintf("row[%d]", k-1));
    end
    SW.pf("yield [%s]\n", conversions.join(", "));
    SW.unindent();
    SW.unindent();
    SW.pf('\n');

    PyW.addMethod(SW);

end

