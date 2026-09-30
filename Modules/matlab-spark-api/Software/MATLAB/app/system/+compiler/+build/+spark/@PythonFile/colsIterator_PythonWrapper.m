function funcName = colsIterator_PythonWrapper(file)
    % colsIterator_PythonWrapper Generate colsIterator function
    %

    % Copyright 2023 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.PythonFile
    end

    funcName = sprintf("__%s_iterator_columns", file.funcName);
    fieldName = "colsIterator";
    
    if isfield(file.API, fieldName)
        return % This was already generated, don't bother
    end

    PSB = file.Parent;
    % Setup local variables
    PyW = PSB.PyW;

    % Change context
    changeBack = PSB.setScopedCallContext('TableDataFrame'); %#ok<NASGU> 

    file.API.(fieldName) = funcName;
    SW = PyW.newMethod();
    SW.pf("def %s(iterator):\n", funcName);
    SW.indent();
    SW.pf('""" A helper function to convert an iterator to a tuple of lists for %s"""\n', file.funcName);

    if file.TableInterface
        ARGS = file.InTypes(1).TableCols;
    else
        ARGS = file.InTypes;
    end

    N_ARGS = numel(ARGS);
    COLS = "C" + (1:N_ARGS) + "_";
    for k=1:N_ARGS
        SW.pf("%s = list()\n", COLS(k));
    end
    SW.pf('for row in iterator:\n')
    SW.indent();

    for k=1:N_ARGS
        rowStr = sprintf("row[%d]", k-1);
        codeOut = ARGS(k).convertExternalToIntermediate(rowStr);
        % SW.pf("%s.append(%s)\n", COLS(k), appendCandidate);
        SW.pf("%s.append(%s)\n", COLS(k), codeOut);
    end
    SW.unindent();

    % Check if any columns must be changed
    SW.pf('return [\n');
    SW.indent();
    for k=1:N_ARGS
        ARG = ARGS(k);
        if ARG.isScalarData
            % COLS(k) = sprintf("matlab.%s(%s)", ARG.MATLABType, COLS(k));
        % if ARG.
        end
        if k == N_ARGS
            comma = "";
        else
            comma = ", ";
        end
        conv = ARG.convertIntermediateColumnForRuntime(COLS(k));
        SW.pf("%s%s\n", conv, comma);
    end
    SW.unindent();
    SW.pf(']\n\n');
    SW.unindent();

    SW.unindent();
    
    PyW.addMethod(SW);

end
