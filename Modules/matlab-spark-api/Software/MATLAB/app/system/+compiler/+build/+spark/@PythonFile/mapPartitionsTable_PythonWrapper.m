function funcName = mapPartitionsTable_PythonWrapper(file)
    % mapPartitionsTable_PythonWrapper Generate mapPartitionsTable function

    % Copyright 2023 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.PythonFile
    end

    funcName = sprintf("%s_mapPartitions", file.funcName);
    fieldName = "mapPartitions";
    
    if isfield(file.API, fieldName)
        return % This was already generated, don't bother
    end

    % Setup local variables
    PSB = file.Parent;
    PyW = PSB.PyW;

    needsOutConversion = file.needsOutputConversion();

    if needsOutConversion
        outputConversion_PythonWrapper(file);
    end

    % =========== Table function ===========
    file.API.(fieldName) = funcName;
    SW = PyW.newMethod();
    if file.ScopedTables
        % Table function with additional arguments

        % extraArgs = file.generatePythonTableRestArgs;
        extraArgs = file.getInputElements(table=false, individual=true);
        extraArgNames = [extraArgs.Name] + "_";
        extraArgsStr = join(extraArgNames, ", ");
        SW.pf("def %s(%s):\n", file.API.mapPartitions, extraArgsStr);
        SW.indent();
        SW.pf('""" A call to the MATLAB function %s\n', file.funcName);
        SW.pf('The input arguments in this case are the additional\n');
        SW.pf('arguments, apart from the table, that gives the scope (context)\n');
        SW.pf('of the calculation.\n');
        SW.pf('This function returns a function handle to be used by\n');
        SW.pf('a mapIteration method. """\n');
        convArgs = string.empty;
        for k=1:length(extraArgNames)
            convArgs(k) = convertPythonValueForMW(extraArgs(k), extraArgNames(k));
            % if convArgs(k) ~= extraArgNames(k)
            %     tmpName = extraArgNames(k) + "_mw";
            %     SW.pf("%s_id = %s\n", tmpName, convArgs(k));
            %     convArgs(k) = tmpName;
            % end
        end
        SW.pf("\n");
        convArgNames = join(convArgs, ", ");
        innerName = sprintf("%s_mapPartitions_inner", file.funcName);
        SW.pf("def %s(iterator):\n", innerName);
        SW.indent();
        SW.pf("nonlocal %s\n", extraArgsStr);

        SW.pf("cols = %s(iterator)\n", file.API.colsIterator);
        SW.pf("n_rows = len(cols[0])\n")
        SW.pf("if n_rows==0:\n");
        SW.indent();
        SW.pf("return iter([])\n")
        SW.unindent();

        SW.pf("else:\n")
        SW.indent();
        SW.pf("instance = %s.getInstance()\n", PSB.WrapperClassName);

        SW.pf("results = instance.RT.%s_mapPartitions(cols, %s)\n", file.funcName, convArgNames);
        SW.pf("%s.releaseInstance(instance)\n", PSB.WrapperClassName);
        if needsOutConversion
            SW.pf("return %s(results)\n\n", file.API.outputConversion);
        else
            SW.pf("return iter(results)\n\n")
        end
        SW.unindent();
        SW.unindent();
        SW.pf("return %s\n\n", innerName);
        SW.unindent();
    else
        % Simple table function, no additional arguments
        SW.pf("def %s(iterator):\n", file.API.mapPartitions);
        SW.indent();
        SW.pf('""" A call to the MATLAB function %s\n', file.funcName);
        SW.pf('The input argument in this case is an iterator\n');
        SW.pf('It is used as argumentXXX e.g. to mapPartition. """\n');

        SW.pf("cols = %s(iterator)\n", file.API.colsIterator);

        SW.pf("n_rows = len(cols[0])\n")

        SW.pf("if n_rows==0:\n");
        SW.indent();
        % SW.pf("%s.releaseInstance(instance)\n", PSB.WrapperClassName);
        SW.pf("return iter([])\n")
        SW.unindent();
        SW.pf("else:\n")
        SW.indent();
        SW.pf("instance = %s.getInstance()\n", PSB.WrapperClassName);
        SW.pf("results = instance.RT.%s_mapPartitions(cols)\n", file.funcName);
        SW.pf("%s.releaseInstance(instance)\n", PSB.WrapperClassName);
        if needsOutConversion
            SW.pf("return %s(results)\n\n", file.API.outputConversion);
        else
            SW.pf("return iter(results)\n\n")
        end
        SW.unindent();
        SW.unindent();
    end
    PyW.addMethod(SW);
end
