function funcName = genInterColToPySeries(arg)
    % genInterColToPySeries
    % Generate a helper function, and add it to the API struct. If already
    % present, don't generate it.
    
    % Copyright 2023 The MathWorks, Inc.
    
    arguments
        arg (1,1) compiler.build.spark.types.ArgType
    end
    
    file = arg.getFileParent;
    PyW = file.Parent.PyW;
    
    funcName = sprintf("__%s_%s_intermColToSeries", file.funcName, arg.Name);
    fieldName = sprintf("intermColToSeries_%s", arg.Name);
    
    
    if isfield(file.API, fieldName)
        % This was already generated, don't bother
        return
    end
    
    file.API.(fieldName) = funcName;
    
    SW = PyW.newMethod();
    
    SW.pf("def %s(col, num_rows):\n", funcName);
    SW.indent();
    if arg.isScalarData
        scalarStr = "scalar";
    else
        scalarStr = "vector";
    end
    SW.pf('"""Helper function for convertingcolumn\n')
    SW.pf('      column ''%s'' in the function ''%s''\n', arg.Name, file.funcName);
    SW.pf('      a %s of MATLAB type ''%s''\n', scalarStr, arg.MATLABType)
    SW.pf('"""\n');
    if file.Parent.Debug
        SW.pf("dbgvar('col', col)\n");
    end
    
    SW.pf("return pd.Series(col, name='%s', dtype='object')\n", arg.Name);
    SW.unindent();
    SW.pf("\n");
    
    PyW.addMethod(SW);
end