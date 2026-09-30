function funcName = columnsToPandas_PythonWrapper(file)
    % columnsToPandas_PythonWrapper Convert MATLAB columns to Pandas
    %

    % Copyright 2024 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.PythonFileV2
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

    OUT_DATA = file.getOutputElements(useData=true);
    OUT_NAMES = file.getOutputNames();
    COL_VAR_NAMES = OUT_DATA.colName();
    N_OUT = numel(OUT_DATA);

    file.API.(fieldName) = funcName;
    SW = PyW.newMethod();

    SW.pf("def %s(result):\n", funcName);
    SW.indent();
    SW.pf('""" A helper function to convert MATLAB result columns to a\n');
    SW.pf('    Pandas DataFrame for %s"""\n', file.funcName);

    % printVarInfo(SW, 'result')
    SW.pf('num_rows = result[%d]\n', N_OUT);

    % if PSB.Debug
    % printVarInfo(SW, 'pdf_out')
    % end
    if PSB.Debug
        for k=1:N_OUT
            ARG = OUT_DATA(k);
            converterCtor = ARG.getPyPandasSeriesConverterCtor();
            colName = compose("col_%s", COL_VAR_NAMES(k));
            SW.pf("converter = %s\n", converterCtor);
            SW.pf("%s = converter.toPandasSeries(result[%d])\n",colName, k - 1);
            SW.pf("%s\n", colName);
        end        
        SW.pf("pdf_out = pd.DataFrame({\n")
        SW.indent();
        comma = ", ";
        for k=1:N_OUT
            if k == N_OUT, comma = ""; end
            ARG = OUT_DATA(k);
            SW.pf('"%s": col_%s%s\n', OUT_NAMES(k), COL_VAR_NAMES(k), comma);
        end        
        SW.unindent();
        SW.pf("})\n")
    else
        SW.pf("pdf_out = pd.DataFrame({\n")
        SW.indent();
        comma = ", ";
        for k=1:N_OUT
            if k == N_OUT
                comma = "";
            end
            ARG = OUT_DATA(k);
            converterCtor = ARG.getPyPandasSeriesConverterCtor();
            convertCode = compose("%s.toPandasSeries(result[%d])",converterCtor, k - 1);
            SW.pf('"%s": %s%s\n', OUT_NAMES(k), convertCode, comma);
        end

        SW.unindent();
        SW.pf("})\n")
    end


    SW.pf("\n")
    SW.pf("return pdf_out\n")
    SW.unindent();
    SW.pf('\n');
    PyW.addMethod(SW);
end

function printVarInfo(SW, varName)
    SW.pf("dbgvar('%s', %s, listIgnoreLimit=2, indentDepth=4)\n", varName, varName)
end
