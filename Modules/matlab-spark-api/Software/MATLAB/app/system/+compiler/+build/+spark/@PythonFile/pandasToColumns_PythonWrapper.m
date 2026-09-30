function funcName = pandasToColumns_PythonWrapper(file)
    % pandasToColumns_PythonWrapper Generate colsIterator function
    %
    
    % Copyright 2023 The MathWorks, Inc.
    
    arguments
        file (1,1) compiler.build.spark.PythonFile
    end
    
    PSB = file.Parent;
    % Setup local variables
    PyW = PSB.PyW;
    
    % Change context
    changeBack = PSB.setScopedCallContext('TablePandas'); %#ok<NASGU>
    
    fieldName = "pandasToCols";
    funcName = sprintf("__%s_pandas_to_columns", file.funcName);
    if isfield(file.API, fieldName)
        % This was already generated, don't bother
        return
    end

    file.API.(fieldName) = funcName;
    SW = PyW.newMethod();

    SW.pf("def %s(pdf : pd.DataFrame):\n", funcName);
    SW.indent();
    SW.pf('""" A helper function to convert a Pandas dataframe to a list of columns for %s"""\n', file.funcName);
    
    if file.TableInterface
        ARGS = file.InTypes(1).TableCols;
    else
        ARGS = file.InTypes;
    end
    
    N_ARGS = numel(ARGS);
    COLS = "C" + (1:N_ARGS) + "_";
    for k=1:N_ARGS
        ARG = ARGS(k);
        colName = sprintf("pdf['%s']", ARG.Name);
        SW.pf("%s = %s\n", COLS(k), ARG.convertPandaColumnToIntermediate(colName));
        % if PSB.Debug
        %     printVarInfo(SW, COLS(k));
        % end
        if ~ARG.isScalarData
            SW.pf("if isinstance(%s[0], numpy.ndarray):\n", COLS(k));
            SW.indent();
            SW.pf("%s = [x.tolist() for x in %s]\n", COLS(k), COLS(k));
            SW.unindent();
            % if PSB.Debug
            %     printVarInfo(SW, COLS(k));
            % end
        end
    end
    % SW.pf('for row in iterator:\n')
    % SW.indent();
    %
    % for k=1:N_ARGS
    %     rowStr = sprintf("row[%d]", k-1);
    %     [appendCandidate, preCodeTemp] = ARGS(k).convertExternalToIntermediate(rowStr);
    %     % SW.pf("%s.append(%s)\n", COLS(k), appendCandidate);
    %     SW.pf("%s.append(%s)\n", COLS(k), rowStr);
    % end
    % SW.unindent();
    
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

function printVarInfo(SW, varName)
    SW.pf("dbgvar('%s', %s, listIgnoreLimit=2, indentDepth=4)\n", varName, varName)
    % SW.pf("print('===============================')\n")
    % SW.pf("print(f'Variable: %s')\n", varName)
    % SW.pf("print(f'Type: #{type(%s)}')\n", varName)
    % SW.pf("print(f'Value: #{%s}')\n", varName)
end
