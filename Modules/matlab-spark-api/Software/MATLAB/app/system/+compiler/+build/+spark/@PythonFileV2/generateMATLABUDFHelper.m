function generateMATLABUDFHelper(file)
    % generateMATLABUDFHelper Generate UDF Helper function
    %

    % Copyright 2024 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.PythonFileV2
    end

    funcName = file.funcName;

    % Convert output values if necessary
    outElems = file.getOutputElements();
    N_OUT = length(outElems);

    % If this is not a table method, add some helper functions for plain udfs
    if N_OUT == 0 || file.TableInterface
        return;
    end

    PSB = file.Parent;

    pyUdfName = funcName + "_udf";
    mlUdfName = funcName + "_ml_udf";
    udfFileName = mlUdfName + ".m";
    sparkTypes = arrayfun(@getSparkType, outElems);
    pkgName = PSB.PkgName;

    if N_OUT == 1
        udfImportTypes = sparkTypes;
        udfOutTypes = outElems.pythonInitCode();
    else
        udfImportTypes = join(unique(sparkTypes, 'stable'), ",");
        udfOutTypes = "'" + file.generatePythonPandasSchema() + "'";
    end

    inputNames = file.getInputNames();
    inputArguments = join(inputNames, ", ");
    SW = matlab.sparkutils.StringWriter(udfFileName);
    SW.pf("function matlab_udf = %s(options)\n", mlUdfName);
    SW.indent();
    SW.pf("%% %s Register UDF and return MATLAB wrapper\n\n", mlUdfName)

    SW.pf('arguments\n');
    SW.indent();
    % The argments will come in use later, when we can upload artifacts
    SW.pf('options.spark matlab.pyspark.sql.session.SparkSession %%#ok<INUSA>\n');
    SW.unindent();
    SW.pf('end\n\n');

    SW.pf("%% This code must be executed in a directory where the generated" + ...
        " files are available.\n");
    SW.pf("here = fileparts(mfilename('fullpath'));\n")
    SW.pf("outputDir = fileparts(here);\n")
    SW.pf("oldDir = cd(outputDir);\n");
    SW.pf("goBack = onCleanup(@() cd(oldDir));\n\n")
    SW.pf('imports = [...\n');
    SW.indent();
    SW.pf('"from pyspark.sql.functions import udf", ...\n');
    SW.pf('"from pyspark.sql.types import %s", ...\n', udfImportTypes);
    %SW.pf('"from databricks.connect import DatabricksSession" ...\n');
    SW.unindent();
    SW.pf('];\n');
    SW.pf('udf_lines = [ ...\n');
    SW.indent();
    SW.pf('"@udf(returnType=%s)", ...\n', udfOutTypes);
    SW.pf('"def %s(%s):", ...\n', pyUdfName, inputArguments);
    SW.pf('"    from %s.wrapper import %s", ...\n', pkgName, funcName);
    SW.pf('"    return %s(%s)" ...\n', funcName, inputArguments);
    SW.unindent();
    SW.pf('];\n\n');
    SW.pf('pyrun([imports, udf_lines])\n\n')

    SW.pf("%% Return a handle to the function that can be used with Spark\n");
    SW.pf("matlab_udf = @udf_handler;\n\n")

    SW.unindent();
    SW.pf("end\n\n");

    % New function here
    SW.pf("function newCol = udf_handler(%s)\n", inputArguments);
    SW.indent();
    SW.pf("%% udf_handler UDF handler for %s\n\n", funcName);

    colConversions = inputNames + "=" + inputNames + ".toPy";
    colConvStr = join(colConversions, ", ");
    SW.pf("newCol = matlab.pyspark.sql.column.Column(...\n")
    SW.indent();
    SW.pf('pyrun("newCol = %s(%s)", "newCol", %s));\n', ...
        pyUdfName, inputArguments, colConvStr);
    SW.unindent();
    SW.unindent();
    SW.pf("end\n\n");

end
