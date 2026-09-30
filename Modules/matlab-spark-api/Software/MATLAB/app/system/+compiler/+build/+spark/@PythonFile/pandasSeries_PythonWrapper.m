function funcName = pandasSeries_PythonWrapper(file)
    % pandasSeries_PythonWrapper Generate pandasSeries function

    % Copyright 2023 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.File
    end

    funcName = sprintf("%s_series", file.funcName);
    fieldName = "pandaSeries";
    
    if isfield(file.API, fieldName)
        return % This was already generated, don't bother
    end

    PSB = file.Parent;
    % Setup local variables
    PyW = PSB.PyW;

    inTypesStr =  join(...
        "'" + [file.InTypes.PrimitiveJavaType] + "'", ...
        ", ");

    % SW.pf("@pandas_udf(%s)\n", inTypesStr);
    [inArgString, inArgs] = file.generatePythonInputArgs();

    file.API.(fieldName) = funcName;
    SW = PyW.newMethod();
    inNames = file.getInputNameArray();
    inNamesPdTyped = "arg_" + inNames + ": pd.Series";
    inNamesPdTypedStr = inNamesPdTyped.join(", ");

    % inArgString = join(inArgs + " : pd.Series", ", ");
    SW.pf("def %s(%s) -> pd.Series:\n", funcName, inNamesPdTypedStr);
    SW.indent();
    SW.pf('""" A function to be used as a pandas_udf on a Series.\n');
    SW.pf('Please cf. the registration function (next in file).\n')
    SW.pf('"""\n');
    SW.pf("instance = %s.getInstance()\n", PSB.WrapperClassName);
    lInArgs = "l_" + inArgs;
    for k = 1 : length(inArgs)
        SW.pf("%s = %s.to_numpy().tolist()\n", lInArgs(k), inArgs(k));
    end
    SW.pf("result = instance.RT.%s_series(%s)\n", ...
        file.funcName, lInArgs.join(", "));
    SW.pf("%s.releaseInstance(instance)\n", PSB.WrapperClassName);
    SW.pf("return pd.Series(result)\n\n");
    SW.unindent();

    PyW.addMethod(SW);

    % Also register this function as a pandas_udf
    SW = PyW.newMethod();

    regUDFSeries = sprintf("%s_reg_udf_series", file.funcName);
    file.API.regUDFSeries = regUDFSeries;

    outElems = file.getOutputElements;
    if isscalar(outElems)
        PyW.addImport(sprintf("from pyspark.sql.types import %s", file.OutTypes.SparkType));
        % SW.pf("from pyspark.sql.types import %s\n", file.OutTypes.SparkType);
        outSchema = sprintf("%s()", file.OutTypes.SparkType);
    else
        outSchema = file.API.outputSchema;
    end

    SW.pf("def %s():\n", regUDFSeries)
    SW.indent();
    SW.pf('""" Register the function %s as a pandas_udf function.\n', file.API.(fieldName))
    SW.pf('It may be used as follows:\n')
    localName = sprintf('%s_pandas_udf', file.funcName);
    SW.pf('  %s = regUDFSeries()\n', localName);
    inNamesSelect = "col('" + inNames + "')";
    inNamesSelectStr = inNamesSelect.join(", ");
    SW.pf('  DF.select(%s(%s))\n', localName, inNamesSelectStr)
    SW.pf('"""\n')
    SW.pf("return pandas_udf(%s, %s)\n", file.API.(fieldName), outSchema)
    SW.unindent();
    
    PyW.addMethod(SW);



end
