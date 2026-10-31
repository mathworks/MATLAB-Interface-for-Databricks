function funcName = mapInPandas_PythonWrapper(file)
    % mapInPandas_PythonWrapper Generate mapInPandas function

    % Copyright 2024 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.PythonFileV2
    end

    funcName = sprintf("%s_mapInPandas", file.funcName);
    fieldName = "mapInPandas";
    
    if isfield(file.API, fieldName)
        return % This was already generated, don't bother
    end

    PSB = file.Parent;
    % Setup local variables
    PyW = PSB.PyW;

    applyInPandasName = applyInPandas_PythonWrapper(file);
    file.API.(fieldName) = funcName;
    SW = PyW.newMethod();

    if file.ScopedTables

        extraArgs = file.generatePythonTableRestArgs();
        SW.pf("def %s(%s):\n", funcName, extraArgs);
        SW.indent();
        SW.pf('""" A function to be used with mapInPandas.\n');
        SW.pf('This function takes additional arguments, which create\n')
        SW.pf('a local scope for this function. """\n')
        innerName = sprintf("%s_mapInPandas_inner", file.funcName);
        SW.pf("def %s(iterator):\n", innerName);
        SW.indent();
        SW.pf("nonlocal %s\n", extraArgs);
        SW.pf("func = %s(%s)\n", applyInPandasName, extraArgs);
        SW.pf("for pdf in iterator:\n");
        SW.indent();
        SW.pf("yield func(pdf)\n");
        SW.unindent();
        SW.unindent();
        SW.pf("return %s\n\n", innerName);
        SW.unindent();

    else

        SW.pf("def %s(iterator):\n", funcName);
        SW.indent();
        SW.pf('""" A function to be used with mapInPandas."""\n');
        SW.pf("for pdf in iterator:\n");
        SW.indent();
        SW.pf("yield %s(pdf)\n\n", applyInPandasName);
        SW.unindent();
        SW.unindent();
    end

    PyW.addMethod(SW);
end
