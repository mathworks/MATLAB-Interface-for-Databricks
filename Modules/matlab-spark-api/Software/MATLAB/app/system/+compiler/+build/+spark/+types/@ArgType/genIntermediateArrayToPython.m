function funcName = genIntermediateArrayToPython(arg)
    % genIntermediateArrayToPython
    % Generate a helper function, and add it to the API struct. If already
    % present, don't generate it.
    
    % Copyright 2023 The MathWorks, Inc.
    
    arguments
        arg (1,1) compiler.build.spark.types.ArgType
    end
    
    funcName = sprintf("__array%s_to_py", arg.MATLABType);
    fieldName = sprintf("intermColConvPy%s", arg.MATLABType);

    file = arg.getFileParent;
    PyW = file.Parent.PyW;

    if isfield(file.API, fieldName)
        % This was already generated, don't bother
        return
    end
    
    if ~arg.isArray
        return
        % Not needed for scalars
    end

    file.API.(fieldName) = funcName;

    convType = sprintf("matlab.%s", arg.MATLABType);
    SW = PyW.newMethod();

    SW.pf("def %s(col):\n", funcName);
    SW.indent();
    SW.pf("def fix_item(x):\n");
    SW.indent();
    % SW.pf("dbgvar('x', x)\n");
    SW.pf("if isinstance(x, %s):\n", convType);
    SW.indent();
    SW.pf("y = x.tomemoryview().tolist()[0]\n");
    SW.unindent();
    SW.pf("elif isinstance(x, %s):\n", arg.PythonType);
    SW.indent();
    SW.pf("y = [x]\n");
    SW.unindent();
    SW.pf("elif isinstance(x, list):\n");
    SW.indent();
    SW.pf("# Already a list\n");
    SW.pf("if isinstance(x[0], %s):\n", convType);
    SW.indent();
    SW.pf("y = x[0].tomemoryview().tolist()\n");
    SW.unindent();
    SW.pf("else:\n");
    SW.indent();
    SW.pf("y = x\n");
    SW.unindent();
    SW.unindent();
    SW.pf("else:\n");
    SW.indent();
    SW.pf("y = None\n");
    SW.unindent();
    SW.pf("return y\n");
    SW.unindent();
    SW.pf("return [fix_item(x) for x in col]\n");
    SW.unindent();
    SW.pf("\n");
    
    PyW.addMethod(SW);
end