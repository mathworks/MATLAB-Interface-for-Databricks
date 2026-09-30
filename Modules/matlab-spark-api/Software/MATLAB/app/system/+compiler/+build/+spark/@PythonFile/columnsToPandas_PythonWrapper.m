function funcName = columnsToPandas_PythonWrapper(file)
    % columnsToPandas_PythonWrapper Convert MATLAB columns to Pandas
    % 
    
    % Copyright 2023 The MathWorks, Inc.
    
    arguments
        file (1,1) compiler.build.spark.PythonFile
    end
    
    fieldName = "colsToPandas";
    funcName = sprintf("__%s_columns_to_pandas", file.funcName);
    if isfield(file.API, fieldName)
        % This was already generated, don't bother
        return
    end
    
    PSB = file.Parent;
    % Setup local variables
    PyW = PSB.PyW;
    
    % Change context
    changeBack = PSB.setScopedCallContext('TablePandas'); %#ok<NASGU>
    
    OUT_ARGS = file.getOutputElements();
    N_OUT = numel(OUT_ARGS);
    
    
    
    file.API.(fieldName) = funcName;
    SW = PyW.newMethod();
    
    SW.pf("def %s(result):\n", funcName);
    SW.indent();
    SW.pf('""" A helper function to convert MATLAB result columns to a\n');
    SW.pf('    Pandas DataFrame for %s"""\n', file.funcName);
    
    % printVarInfo(SW, 'result')
    SW.pf('num_rows = result[%d]\n', N_OUT);
    % SW.pf('if num_rows==1:\n');
    % SW.indent();
    % SW.pf("pdf_out = pd.DataFrame({\n")
    % SW.indent();
    % for k=1:N_OUT
    %     ARG = OUT_ARGS(k);
    %     % convCode = ARG.convertIntermediateToExternal(sprintf("result[%d]", k-1));
    %     convCode = sprintf("result[%d]", k-1);
    %     SW.pf('"%s": [%s]%s\n', ARG.Name, convCode, ARG.getComma(k, N_OUT));
    % end
    % SW.unindent();
    % SW.pf("})\n")
    % SW.unindent();
    % SW.pf('else:\n')
    % SW.indent();
    % SW.pf("pdf_out = pd.DataFrame({\n")
    % SW.indent();
    % for k=1:N_OUT
    %     ARG = OUT_ARGS(k);
    %     convCode = ARG.convertIntermediateToExternal(sprintf("result[%d]", k-1));
    %     SW.pf('"%s": %s%s\n', ARG.Name, convCode, ARG.getComma(k, N_OUT));
    % end
    % SW.unindent();
    % SW.pf("})\n")
    % SW.unindent();
    
    % if PSB.Debug
    % printVarInfo(SW, 'pdf_out')
    % end
    SW.pf("pdf_out = pd.DataFrame({\n")
    SW.indent();
    for k=1:N_OUT
        ARG = OUT_ARGS(k);
        convCode = sprintf("%s(result[%d], num_rows)", ...
            genInterColToPySeries(ARG), k-1);
        SW.pf('"%s": %s%s\n', ARG.Name, convCode, ARG.getComma(k, N_OUT));
    end

    SW.unindent();
    SW.pf("})\n")


    SW.pf("\n")
    SW.pf("return pdf_out\n")
    SW.unindent();
    SW.pf('\n');
    PyW.addMethod(SW);
end

function printVarInfo(SW, varName)
    SW.pf("dbgvar('%s', %s, listIgnoreLimit=2, indentDepth=4)\n", varName, varName)
end
