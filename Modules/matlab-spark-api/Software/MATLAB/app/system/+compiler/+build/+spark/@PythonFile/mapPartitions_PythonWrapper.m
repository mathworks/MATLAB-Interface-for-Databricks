function funcName = mapPartitions_PythonWrapper(file)
    % mapPartitions_PythonWrapper Generate mapPartitions function

    % Copyright 2023 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.PythonFile
    end

    % Setup local variables
    PSB = file.Parent;
    SW = PSB.SW;

    funcName = sprintf("%s_mapPartitions", file.funcName);
    fieldName = "mapPartitions";
    
    if isfield(file.API, fieldName)
        return % This was already generated, don't bother
    end

    PSB = file.Parent;
    % Setup local variables
    PyW = PSB.PyW;

    needsOutConversion = file.needsOutputConversion();

    if needsOutConversion
        outConvFun = outputConversion_PythonWrapper(file);
    end

    % Don't create a simple iterator for table interfaces
    file.API.(fieldName) = funcName;
    SW = PyW.newMethod();

    SW.pf("def %s(iterator):\n", funcName);
    SW.indent();
    SW.pf('""" A call to the MATLAB function %s\n', file.funcName);
    SW.pf('The input argument in this case is an iterator\n');
    SW.pf('It is used as argument e.g. to mapPartition. """\n')

    colsIteratorFunc = file.colsIterator_PythonWrapper();
    SW.pf("cols = %s(iterator)\n", colsIteratorFunc);

    SW.pf("n_rows = len(cols[0])\n")

    SW.pf("if n_rows==0:\n");
    SW.indent();
    SW.pf("return iter([])\n")
    SW.unindent();

    SW.pf("else:\n")
    SW.indent();
    SW.pf("instance = %s.getInstance()\n", PSB.WrapperClassName);
    SW.pf("results = instance.RT.%s_mapPartitions(cols)\n", file.funcName);

    SW.pf("%s.releaseInstance(instance)\n", PSB.WrapperClassName);
    
    if needsOutConversion
        outConvFunc = file.outputConversion_PythonWrapper();
        SW.pf("return %s(results)\n\n", outConvFun);
    else
        if file.nArgOut == 1
            SW.pf("# Return single tuples instead of values, to convey the 'row' format\n");
            SW.pf("results = [(x,) for x in results]\n");
        end
        SW.pf("return iter(results)\n\n")
    end
    SW.unindent();
    SW.unindent();

    PyW.addMethod(SW);

end

