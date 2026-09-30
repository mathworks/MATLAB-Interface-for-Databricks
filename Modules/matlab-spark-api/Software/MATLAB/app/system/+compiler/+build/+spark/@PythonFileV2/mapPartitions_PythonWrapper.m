function funcName = mapPartitions_PythonWrapper(file)
    % mapPartitions_PythonWrapper Generate mapPartitions function

    % Copyright 2023 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.PythonFileV2
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

    % Don't create a simple iterator for table interfaces
    file.API.(fieldName) = funcName;
    SW = PyW.newMethod();

    inputs = file.getInputElements(main=true, useData=true);
    numCols = numel(inputs);
    colArgs = "cols[" + (0:(numCols-1)) + "]";
    colArgsStr = join(colArgs, ", ");

    if file.ScopedTables
        % Table function with additional arguments

        extraArgs = file.getInputElements(table=false, individual=true, useData=true);
        extraArgNames = file.getInputNames(table=false, individual=true) + "_";
        extraArgsStr = join(extraArgNames, ", ");
        SW.pf("def %s(%s):\n", file.API.mapPartitions, extraArgsStr);
        SW.indent();
        SW.pf('""" A call to the MATLAB function %s\n', file.funcName);
        SW.pf('The input arguments in this case are the additional\n');
        SW.pf('arguments, apart from the table, that gives the scope (context)\n');
        SW.pf('of the calculation.\n');
        SW.pf('This function returns a function handle to be used by\n');
        SW.pf('a mapIteration method. """\n');

        SW.pf("\n");
        convArgNames = join(extraArgNames, ", ");
        innerName = sprintf("%s_mapPartitions_inner", file.funcName);
        SW.pf("def %s(iterator):\n", innerName);
        SW.indent();
        SW.pf("nonlocal %s\n", extraArgsStr);

        for k=1:length(extraArgNames)
            xArg = extraArgs(k);
            xArgName = extraArgNames(k);

            
            conv_Spark_to_IMPY = xArg.val_Spark_to_IMPY();
            if ~isempty(conv_Spark_to_IMPY)
                % SW.pf("%s = %s(%s)\n", xArgName, conv_Spark_to_IMPY, xArgName);
                extraArgNames(k) =sprintf("%s(%s)", conv_Spark_to_IMPY, extraArgNames(k));
            end

            conv_IMPY_to_IMML = xArg.val_IMPY_to_IMML();
            if ~isempty(conv_IMPY_to_IMML)
                % SW.pf("%s = %s(%s)\n", xArgName, conv_IMPY_to_IMML, xArgName);
                extraArgNames(k) =sprintf("%s(%s)", conv_IMPY_to_IMML, extraArgNames(k));
            end

            convArgNames = join(extraArgNames, ", ");

        end

        SW.pf("cols = %s(iterator)\n", file.API.colsIterator);
        SW.pf("n_rows = len(cols[0])\n")
        SW.pf("if n_rows==0:\n");
        SW.indent();
        SW.pf("return iter([])\n")
        SW.unindent();

        SW.pf("else:\n")
        SW.indent();
        SW.pf("instance = %s.getInstance()\n", PSB.WrapperClassName);
        outputElements = file.getOutputElements(useData=true);

        SW.pf("colResults = instance.RT.%s_mapPartitions(%s, %s, nargout=%d)\n", ...
            file.funcName, colArgsStr, convArgNames, numel(outputElements)+1);
        SW.pf("%s.releaseInstance(instance)\n", PSB.WrapperClassName);

        colsToRowsFunc = file.colsToRows_PythonWrapper();
        SW.pf("return %s(colResults)\n", colsToRowsFunc);

        SW.unindent();
        SW.unindent();
        SW.pf("return %s\n\n", innerName);
        SW.unindent();
    else
        % Table, but not scoped
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

        outputElements = file.getOutputElements(useData=true);
        SW.pf("colResults = instance.RT.%s_mapPartitions(%s, nargout=%d)\n", ...
            file.funcName, colArgsStr, numel(outputElements)+1); % +1 for NUM_ROWS

        SW.pf("%s.releaseInstance(instance)\n", PSB.WrapperClassName);

        colsToRowsFunc = file.colsToRows_PythonWrapper();
        SW.pf("return %s(colResults)\n", colsToRowsFunc);
        SW.unindent();
        SW.unindent();
    end
    PyW.addMethod(SW);

end

