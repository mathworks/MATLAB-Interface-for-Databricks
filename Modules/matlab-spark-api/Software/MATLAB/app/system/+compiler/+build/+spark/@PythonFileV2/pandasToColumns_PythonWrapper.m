function funcName = pandasToColumns_PythonWrapper(file)
    % pandasToColumns_PythonWrapper Generate colsIterator function
    %

    % Copyright 2023-2024 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.PythonFileV2
    end

    PSB = file.Parent;
    PyW = PSB.PyW;

    usePartialTables = PSB.PartialTables;

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

    ARGS = file.getInputElements(main=true,useData=true);
    N_ARGS = numel(ARGS);

    for k=1:N_ARGS
        ARG = ARGS(k);
        % Alternative stuff
        if usePartialTables
            SW.pf("if hasattr(pdf, '%s'):\n", ARG.Name);
            SW.indent();
        end
        
        colName = ARG.colName();
        converterCtor = ARG.getPyPandasSeriesConverterCtor();
        colValueCode = compose("%s = %s.fromPandasSeries(pdf['%s'])\n", colName, converterCtor, ARG.Name);
        SW.pf(colValueCode)

        if usePartialTables
            SW.unindent();
            SW.pf("else:\n")
            SW.indent();
            SW.pf("# Column not found: %s\n", ARG.Name)
            SW.pf("%s = []\n", ARG.colName);
            SW.unindent();
            SW.pf("\n");
        end

    end

    if N_ARGS==1
        SW.pf("return (%s,)\n", ARGS.colName);
    else
        SW.pf("return (%s)\n", join(ARGS.colName, ", "));
    end

    SW.unindent();
    PyW.addMethod(SW);

end