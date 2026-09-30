function funcName = pandasSeries_PythonWrapper(file)
    % pandasSeries_PythonWrapper Generate pandasSeries function

    % Copyright 2023 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.PythonFileV2
    end

    funcName = sprintf("%s_series", file.funcName);
    fieldName = "pandaSeries";

    if isfield(file.API, fieldName)
        return % This was already generated, don't bother
    end

    PSB = file.Parent;
    % Setup local variables
    PyW = PSB.PyW;

    % Change context
    changeBack = PSB.setScopedCallContext('TablePandas'); %#ok<NASGU>


    % SW.pf("@pandas_udf(%s)\n", inTypesStr);
    [inArgString, inArgs] = file.generatePythonInputArgs();
    ARGS = file.getInputElements(main=true, useData=true);
    N_ARGS = numel(ARGS);
    OUT_ARGS = file.getOutputElements(useData=true);
    N_OUT = numel(OUT_ARGS);
    
    file.API.(fieldName) = funcName;
    SW = PyW.newMethod();
    inNames = "arg_" + file.getInputNames();
    inNamesPdTyped = inNames + ": pd.Series";
    inNamesPdTypedStr = inNamesPdTyped.join(", ");


    if N_OUT > 1
        outType = "pd.DataFrame";
    else
        outType = "pd.Series";
    end
    % inArgString = join(inArgs + " : pd.Series", ", ");
    SW.pf("def %s(%s) -> %s:\n", funcName, inNamesPdTypedStr, outType);
    SW.indent();
    SW.pf('""" A function to be used as a pandas_udf on a Series.\n');
    SW.pf('Please cf. the registration function (next in file).\n')
    SW.pf('"""\n');
    SW.pf("instance = %s.getInstance()\n", PSB.WrapperClassName);

    SW.pf("# Spark_to_IMPY\n")
    for k=1:N_ARGS
        argName = inNames(k);
        ARG = ARGS(k);
        converterCtor = ARG.getPyPandasSeriesConverterCtor();
        colValueCode = compose("%s = %s.fromPandasSeries(%s)\n", ARG.colName(), converterCtor, argName);
        SW.pf(colValueCode);
    end

    argString = join(ARGS.colName, ", ");
    if N_OUT > 1
        argString = sprintf("%s, nargout=%d", argString, N_OUT);
    end
    SW.pf("result = instance.RT.%s_series(%s)\n", file.funcName, argString);
    SW.pf("%s.releaseInstance(instance)\n", PSB.WrapperClassName);

    OUT_ARGS = file.getOutputElements(useData=true);
    if isscalar(OUT_ARGS)
        SW.pf("retVal = %s(result)\n", OUT_ARGS.col_IMML_to_PandasSeries());
        SW.pf("return retVal\n\n");
    else
        SW.pf("return pd.DataFrame({\n");
        SW.indent();
        comma = ", ";
        for k=1:N_OUT
            if k==N_OUT,comma = ""; end
            converterCtor = OUT_ARGS(k).getPyPandasSeriesConverterCtor();
            conversionCode = compose("%s.toPandasSeries(result[%d])", converterCtor,  k - 1);
            SW.pf("'%s': %s%s\n", OUT_ARGS(k).Name, conversionCode, comma);
        end
        SW.unindent();
        SW.pf("})\n\n");
    end

    SW.unindent();

    PyW.addMethod(SW);

    % Also register this function as a pandas_udf
    SW = PyW.newMethod();

    regUDFSeries = sprintf("%s_reg_udf_series", file.funcName);
    file.API.regUDFSeries = regUDFSeries;

    outSchemaElems = file.getOutputElements();
    if isscalar(outSchemaElems)
        sparkType = outSchemaElems.pythonType();
        sparkTypeInit = outSchemaElems.pythonInitCode();
        PyW.addImport(sprintf("from pyspark.sql.types import %s", sparkType));
        % SW.pf("from pyspark.sql.types import %s\n", file.OutTypes.SparkType);
        outSchema = sparkTypeInit;
    else
        outSchema = file.API.outputSchema;
    end

    SW.pf("def %s():\n", regUDFSeries)
    SW.indent();
    SW.pf('""" Register the function %s as a pandas_udf function.\n', file.API.(fieldName))
    SW.pf('It may be used as follows:\n')
    localName = sprintf('%s_pandas_udf', file.funcName);
    SW.pf('  %s = %s()\n', localName, regUDFSeries);
    inNamesSelect = "col('" + inNames + "')";
    inNamesSelectStr = inNamesSelect.join(", ");
    SW.pf('  DF.select(%s(%s))\n', localName, inNamesSelectStr)
    SW.pf('"""\n')
    SW.pf("return pandas_udf(%s, %s)\n", file.API.(fieldName), outSchema)
    SW.unindent();

    PyW.addMethod(SW);

    % Now add the iterator variant
    PyW.addImport("from typing import Iterator, Tuple");
    

    % Also register this function as a pandas_udf
    SW = PyW.newMethod();
    funcNameIter = funcName + "_iter";

    file.API.pandasSeriesIter = funcNameIter;

    if N_ARGS == 1
        inNamesPdTypedStr = "iterator: Iterator[pd.Series]";
    else
        inNamesPdTypedStr = sprintf("iterator: Iterator[Tuple[%s]]", join(repmat("pd.Series", 1, N_ARGS), ", "));
    end
    outType = "Iterator[" + outType + "]";

    SW.pf("def %s(%s) -> %s:\n", funcNameIter, inNamesPdTypedStr, outType)
    SW.indent();
    if N_ARGS == 1
        SW.pf("for item in iterator:\n")
        SW.indent();
        SW.pf("yield %s(item)\n", funcName);
        SW.unindent();
        SW.pf("\n");
    else
        SW.pf("for %s in iterator:\n", inArgString);
        SW.indent();
        SW.pf("yield %s(%s)\n", funcName, inArgString);
        SW.unindent()
        SW.pf("\n");
    end
    SW.unindent()

    PyW.addMethod(SW);

    % Also register this function as a pandas_udf
    SW = PyW.newMethod();

    regUDFSeriesIter = sprintf("%s_reg_udf_series_iter", file.funcName);
    file.API.regUDFSeriesIter = regUDFSeriesIter;

    outSchemaElems = file.getOutputElements();
    if isscalar(outSchemaElems)
        sparkType = outSchemaElems.pythonType();
        sparkTypeInit = outSchemaElems.pythonInitCode();
        PyW.addImport(sprintf("from pyspark.sql.types import %s", sparkType));
        outSchema = sparkTypeInit;
    else
        outSchema = file.API.outputSchema;
    end

    SW.pf("def %s():\n", regUDFSeriesIter)
    SW.indent();
    SW.pf('""" Register the function %s as a pandas_udf function.\n', funcNameIter)
    SW.pf('It may be used as follows:\n')
    localName = sprintf('%s_pandas_udf_iter', file.funcName);
    SW.pf('  %s = %s()\n', localName, regUDFSeriesIter);
    inNamesSelect = "col('" + inNames + "')";
    inNamesSelectStr = inNamesSelect.join(", ");
    SW.pf('  DF.select(%s(%s))\n', localName, inNamesSelectStr)
    SW.pf('"""\n')
    SW.pf("return pandas_udf(%s, %s)\n", funcNameIter, outSchema)
    SW.unindent();

    PyW.addMethod(SW);

end
