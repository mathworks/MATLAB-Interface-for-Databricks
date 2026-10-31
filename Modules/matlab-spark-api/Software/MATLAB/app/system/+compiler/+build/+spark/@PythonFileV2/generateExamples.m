function [outNameCode, outNotebook, outNameShell, outNameArtifacts] = generateExamples(file, options)
    % generateExamples Generate examples from File

    % Copyright 2023 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.PythonFileV2
        options.examplesFolder (1,1) string
    end

    PSB = file.Parent;
    fprintf("Generating examples for %s ...\n", file.funcName);

    outNameCode = generatePythonCodeExample(file, options);
    if isDatabricksEnvironment
        outNotebook = generatePythonNotebookTask(file, options.examplesFolder, outNameCode);
    else
        outNotebook = "";
    end

    if PSB.Debug
        outNameShell = generateShellFileSPython(file, options, outNameCode);
    else
        outNameShell = "";
    end
    outNameArtifacts = generateArtifactsExample(file, options.examplesFolder);
end


function outNameCode = generatePythonCodeExample(file, options)


    outNameCode = fullfile(options.examplesFolder, sprintf("%s_example.py", file.funcName));

    PSB = file.Parent;
    api = file.API;

    ioAligns = file.ioSchemasAlign();

    SW = matlab.sparkutils.StringWriter(outNameCode);

    SW.pf("# Example file for the function %s\n\n", file.funcName);

    SW.pf("from __future__ import print_function\n")
    SW.pf("import sys\n")
    SW.pf("import random\n\n")

    newCell(SW);

    SW.pf("from pyspark.sql import SparkSession\n")
    SW.pf("from pyspark.sql.functions import concat,col,lit\n")
    SW.pf("from pyspark.sql.functions import udf\n")

    SW.pf("from pyspark.sql.types import *\n");
    SW.pf("from decimal import Decimal\n");
    SW.pf("from pyspark.testing import assertDataFrameEqual\n");

    SW.pf("import datetime\n\n")


    newCell(SW);
    SW.pf("# The special command %%pip can be used to install a library in a notebook.\n")
    SW.pf("# Libraries installed this way may also be overwritten with a newer version.\n")
    SW.pf("# This can be very useful during development/debug. The user must upload the wheel file and choose a location.\n")
    SW.pf("\n")
    [~, whlName] = PSB.getWheelFile();
    if isempty(PSB.WheelDestination)
        SW.pf("# %%pip install /Volumes/<my_catalog>/<my_schema>/my_volume/my_directory/%s --force-reinstall\n", whlName);
    else
        SW.pf("%%pip install %s/%s --force-reinstall\n", PSB.WheelDestination, whlName);
    end
    SW.pf("#\n")
    SW.pf("# Refer to https://docs.databricks.com/aws/en/libraries/notebooks-python-libraries#install-a-python-wheel-package-with-pip\n")
    SW.pf("# Python may also have to be restarted, using %%restart_python\n");

    newCell(SW);

    SW.pf("# Import special functions from wrapper\n");

    importStrings = file.getImports(debug=PSB.Debug);
    SW.insertLines(join(importStrings, newline));

    if PSB.Debug
        SW.pf("import matlab\n");
        SW.pf("import numpy\n");
    end


    newCell(SW);

    SW.pf("print('This is a demo for %s')\n\n", file.funcName);

    SW.pf("try:\n")
    SW.indent();
    SW.pf("spark\n")
    SW.pf('print("Spark session already exists")\n');
    SW.unindent();
    SW.pf("except NameError:\n")
    SW.indent();
    SW.pf('print("No spark session present, creating one.")\n')
    SW.pf('spark = SparkSession\\\n');
    SW.indent();
    SW.pf('    .builder\\\n');
    SW.pf('    .appName("simple_task_%s")\\\n', file.funcName);
    SW.pf('    .getOrCreate()\n');
    SW.unindent();
    SW.pf('\n');
    SW.unindent();

    tryNewData = true;
    %&& file.TableInterface;

    SW.pf("# Create some trivial input data with the right data types\n")
    inTypes = file.getInputElements(main=true, useData=true);
    inTypeNames = file.getInputNames(main=true);

    if tryNewData
        newCell(SW);
        tmpFuncsName = sprintf("%s_tmpFuncs", file.funcName);
        PyW = matlab.sparkutils.PythonWriter("", tmpFuncsName, 'pathPrepend', options.examplesFolder);
        PSB.setPythonWriter(PyW);
        removePyWAfter = onCleanup(@() PSB.clearPythonWriter());

        DDD = file.InData();
        if file.TableInterface
            dataFunc = DDD(1).genPythonExampleFunction();
        else
            numCols = numel(DDD);
            dataFunc = strings(1, numCols);
            for nc=1:numCols
                dataFunc(nc) = DDD(nc).genPythonExampleFunction();
            end
        end
        % for kk=1:numel(DDD)
        %     DDD(kk).genPythonExampleFunction();
        % end

        PyW.writeFile();

        SW.pf("### TEST FUNCTION\n")
        SW.insertFile(PyW.FileName)

        SW.pf("DATA = list()\n");
        SW.pf("for di in range(10):\n")
        SW.indent()
        if file.TableInterface
            SW.pf("DATA.append(%s(di))\n", dataFunc);
        else
            tmpStrs = strings(1, numCols);
            for nc=1:numCols
                tmpStrs(nc) = sprintf("%s(di + %d)", dataFunc(nc), nc-1);
            end
            SW.pf("DATA.append((%s,))\n", tmpStrs.join(", "));
        end
        SW.unindent();
    else
        % Old style
        newCell(SW);
        SW.pf("DATA = [\n");
        SW.indent();
        numRows = 10;
        comma = ", ";
        for k=1:numRows
            numIT = length(inTypes);
            SW.pf("(");
            for it = 1:numIT
                argType = inTypes(it);
                SW.pf('%s,', argType.instantiatePythonExampleValue(k+it-1, 1+rem(k+it, 5)));
            end
            if k==numRows; comma = ""; end
            SW.pf(")%s\n", comma);
        end
        SW.unindent();
        SW.pf("]\n");
        SW.pf("\n");
    end

    SW.pf("\n\n")
    SW.pf("# Create a dataframe from the example data\n")
    if file.TableInterface
        SW.pf("dfSchema = %s\n", file.Schema.Inputs(1).SparkType.pythonInitCode);
    else
        SW.pf("dfSchema = %s\n", file.Schema.Inputs.pythonInitCode);
    end
    SW.pf("\n");

    SW.pf('DF = spark.createDataFrame(DATA, dfSchema).repartition(1).cache()\n\n')

    SW.pf('print("### Show example data")\n');
    SW.pf("DF.printSchema()\n")
    SW.pf("DF.show(10, False)\n\n");

    SW.pf("# Create a database view of the data\n")
    tblName = sprintf('temptest_%s', file.funcName);
    SW.pf("DF.createOrReplaceTempView('%s')\n\n", tblName);

    if PSB.Debug
        SW.pf("## For easier debugging\n")
        SW.pf("rows = DF.collect()\n")
        SW.pf("pdf = DF.toPandas()\n")
    end


    % if it's a table function with additional arguments, we need
    % values for these too.
    extraArgsStr = "";
    if file.TableInterface
        extraArgs = file.getInputElements(table=false,individual=true, useData=true);
        if ~isempty(extraArgs)
            extraArgNames = "arg_" + file.getInputNames(table=false, individual=true);
            for k = 1:length(extraArgs)
                SW.pf('%s = %s\n', extraArgNames(k), extraArgs(k).instantiatePythonExampleValue(k));
            end
            SW.pf('\n');
            extraArgsStr = "(" + join(extraArgNames, ", ") + ")";
        end
    end

    % Generate simple values for calling a plain function
    mt = compiler.build.spark.MethodType.plain;
    if ismember(mt, file.MethodTypes)
        newCell(SW);

        SW.pf("# Example data for simple functions\n")
        simpleArgs = string.empty;
        inTypes = file.getInputElements(table=false, individual=true, useData=true);
        inNames = file.getInputNames(table=false, individual=true);
        for k=1:file.nArgIn
            CA = inTypes(k);
            exVarName = "exdata_" + inNames(k);
            SW.pf("%s = %s\n", exVarName, CA.instantiatePythonExampleValue(k*10));
            simpleArgs(k) = exVarName;
        end
        SW.pf("\n")

        SW.pf('print("### Run %s with %s\\n")\n', string(mt), file.funcName);
        SW.pf("plainRet = %s(%s)\n", file.funcName, join(simpleArgs, ", "));
        if file.nArgOut > 0
            SW.pf('print("plainRet: " + str(plainRet) + "\\n")\n');
        end
        SW.pf("\n")
    end

    % TODO: Make sure there's a method type for udf registration
    if isfield(file.API, 'regUDF')
        newCell(SW);
        SW.pf('# Register as UDF\n');
        SW.pf('%s(spark)\n\n', file.API.regUDF);

        SW.pf('# Use the UDF on the temporary table\n')
        inNames = file.getInputNames(table=false, individual=true);
        inNamesStr = inNames.join(", ");
        SW.pf("UDF1 = spark.sql('SELECT %s, %s_udf(%s) FROM %s')\n", ...
            inNamesStr, file.funcName, inNamesStr, tblName)
        SW.pf("UDF1.show(5, False)\n\n")

        if ioAligns
            newCell(SW);
            SW.pf("# Verify the output is the same as the input\n");
            if file.nArgOut > 1
                SW.pf("UDF1_ = UDF1.select(UDF1.columns[-1] + '.*')\n")
            else
                outNames = file.getOutputNames();
                SW.pf("UDF1_ = UDF1.select(UDF1.columns[-1]).toDF('%s')\n", outNames);
            end
            SW.pf("assertDataFrameEqual(DF, UDF1_)\n")
        end
    end

    if isfield(file.API, 'regUDFDataframe')
        newCell(SW);
        SW.pf('# Register as UDF for Dataframes\n');
        udfDFName = sprintf('%s_udf_df', file.funcName);
        SW.pf('%s = %s()\n\n', udfDFName, file.API.regUDFDataframe);

        SW.pf('# Use in a Dataframe select statement\n')
        inNamesStrQuoted = "'" + inNames.join("', '") + "'";
        SW.pf("UDF2 = DF.select(%s, %s(%s))\n", inNamesStrQuoted, udfDFName, inNamesStrQuoted)
        SW.pf("UDF2.show(5, False)\n\n")

        if ioAligns
            newCell(SW);
            SW.pf("# Verify the output is the same as the input\n");
            if file.nArgOut > 1
                SW.pf("UDF2_ = UDF2.select(UDF2.columns[-1] + '.*')\n")
            else
                outNames = file.getOutputNames();
                SW.pf("UDF2_ = UDF2.select(UDF2.columns[-1]).toDF('%s')\n", outNames);
            end
            SW.pf("assertDataFrameEqual(DF, UDF2_)\n")
        end
    end

    if isfield(file.API, 'regUDFSeries')
        newCell(SW);
        SW.pf('# Register as UDF for Pandas series\n');
        udfDFName = sprintf('%s_udf_series', file.funcName);
        SW.pf('%s = %s()\n\n', udfDFName, file.API.regUDFSeries);

        SW.pf('# Use in a Dataframe select statement\n')
        inNamesSelect = "col('" + inNames + "')";
        inNamesSelectStr = inNamesSelect.join(", ");
        SW.pf("UDF3 = DF.select(%s, %s(%s))\n", inNamesStrQuoted, udfDFName, inNamesSelectStr)
        SW.pf("UDF3.show(5, False)\n\n")

        if ioAligns
            newCell(SW);
            SW.pf("# Verify the output is the same as the input\n");
            if file.nArgOut > 1
                SW.pf("UDF3_ = UDF3.select(UDF3.columns[-1] + '.*')\n")
            else
                outNames = file.getOutputNames();
                SW.pf("UDF3_ = UDF3.select(UDF3.columns[-1]).toDF('%s')\n", outNames);
            end
            SW.pf("assertDataFrameEqual(DF, UDF3_)\n")
        end

        % When UDF Series is present, so is the iterator variant
        newCell(SW);
        SW.pf('# Register as UDF for Pandas iterator-series\n');
        udfDFName = sprintf('%s_udf_series_iter', file.funcName);
        SW.pf('%s = %s()\n\n', udfDFName, file.API.regUDFSeriesIter);

        SW.pf('# Use in a Dataframe select statement\n')
        inNamesSelect = "col('" + inNames + "')";
        inNamesSelectStr = inNamesSelect.join(", ");
        SW.pf("UDF4 = DF.select(%s, %s(%s))\n", inNamesStrQuoted, udfDFName, inNamesSelectStr)
        SW.pf("UDF4.show(5, False)\n\n")

        if ioAligns
            newCell(SW);
            SW.pf("# Verify the output is the same as the input\n");
            if file.nArgOut > 1
                SW.pf("UDF4_ = UDF4.select(UDF4.columns[-1] + '.*')\n")
            else
                outNames = file.getOutputNames();
                SW.pf("UDF4_ = UDF4.select(UDF4.columns[-1]).toDF('%s')\n", outNames);
            end
            SW.pf("assertDataFrameEqual(DF, UDF4_)\n")
        end
    end


    mt = compiler.build.spark.MethodType.map;
    if ismember(mt, file.MethodTypes)
        newCell(SW);

        SW.pf('print("### Run %s with %s")\n', string(mt), file.funcName);
        SW.pf("DF_map = DF.rdd.map(%s_map).toDF(%s_output_schema)\n", file.funcName, file.funcName);
        SW.pf("DF_map.show(10, False)\n\n")

        if ioAligns
            newCell(SW);
            SW.pf("# Verify the output is the same as the input\n");
            SW.pf("assertDataFrameEqual(DF, DF_map)\n")
        end

    end

    mt = compiler.build.spark.MethodType.mapPartitions;
    if ismember(mt, file.MethodTypes)
        newCell(SW);

        SW.pf('print("### Run %s with %s")\n', string(mt), file.funcName);
        SW.pf("DF_mapPartitions = DF.rdd.mapPartitions(%s%s).toDF(%s).cache()\n", ...
            file.API.mapPartitions, extraArgsStr, file.API.outputSchema);
        SW.pf("DF_mapPartitions.show(10, False)\n\n")

        if ioAligns
            newCell(SW);
            SW.pf("# Verify the output is the same as the input\n");
            SW.pf("assertDataFrameEqual(DF, DF_mapPartitions)\n")
        end
    end

    mt = compiler.build.spark.MethodType.applyInPandas;
    if ismember(mt, file.MethodTypes)

        % datetime types don't work with Pandas
        newCell(SW);
        groupByArgName = chooseGroupbyColumn(file);
        SW.pf('print("### Run %s with %s")\n', string(mt), file.funcName);
        SW.pf('DF_applyInPandas = DF.groupBy("%s").applyInPandas(%s%s, schema=%s).cache()\n', ...
            groupByArgName, file.API.applyInPandas, extraArgsStr, file.API.outputSchema);
        SW.pf("DF_applyInPandas.show(10, False)\n\n")

        if ioAligns
            newCell(SW);
            SW.pf("# Verify the output is the same as the input\n");
            SW.pf("assertDataFrameEqual(DF, DF_applyInPandas.sort('%s'))\n", groupByArgName);
        end
    end

    mt = compiler.build.spark.MethodType.mapInPandas;
    if ismember(mt, file.MethodTypes)
        newCell(SW);
        SW.pf('print("### Run %s with %s")\n', string(mt), file.funcName);
        SW.pf('DF_mapInPandas = DF.mapInPandas(%s%s, schema=%s).cache()\n', ...
            file.API.mapInPandas, extraArgsStr, file.API.outputSchema);
        SW.pf("DF_mapInPandas.show(10, False)\n\n")

        if ioAligns
            newCell(SW);
            SW.pf("# Verify the output is the same as the input\n");
            SW.pf("assertDataFrameEqual(DF, DF_mapInPandas)\n")
        end
    end

end

function outNameShell = generateShellFileSPython(file, options, pythonOutName)
    outNameShell = fullfile(options.examplesFolder, sprintf("run_%s_example.sh", file.funcName));

    SW = matlab.sparkutils.StringWriter(outNameShell);
    writeCommonScriptLines(SW, file);
    SW.pf("cd $OUTDIR_NAME\n")

    SW.pf("$SPARK_HOME/bin/pyspark --total-executor-cores 4 --py-files %s\n", pythonOutName);


    SW.pf('\n# End of file\n\n');
    clear('SW');
    if isunix
        [r, s] = system(sprintf("chmod +x %s", outNameShell)); %#ok<ASGLU>
    end

end


function writeCommonScriptLines(SW, file)
    SW.pf('#!/bin/bash\n\n');
    SW.pf('set -x\n\n');
    SW.pf('echo "This script is a simple test of the code in %s with sample data."\n', file.funcName);
    SW.pf('echo "It requires that the variable SPARK_HOME is set and pointing to a valid Spark installation"\n\n');
    SW.pf('echo "Call the script with the argument STOP_AFTER to have it automatically return from Spark."\n\n');

    SW.pf('export STOP_TEST_AFTER=$1\n\n');
    SW.pf('echo "Starting Spark shell from $SPARK_HOME"\n');
    SW.pf('SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"\n');
    SW.pf('OUTDIR_NAME="$( dirname ${SCRIPT_DIR})"\n\n');

    MCR_ROOT = "R" + string(version('-release'));
    SW.pf("export MCR_ROOT=/usr/local/MATLAB/MATLAB_Runtime\n");
    SW.pf("export MCR=$MCR_ROOT/%s\n", MCR_ROOT);
    SW.pf("export LD_LIBRARY_PATH=${MCR}/runtime/glnxa64:${MCR}/bin/glnxa64:${MCR}/sys/os/glnxa64:${MCR}/sys/opengl/lib/glnxa64\n\n");

end

function newCell(SW)

    comment = "# ";

    SW.pf("\n");
    SW.pf("%sCOMMAND ----------\n", comment);
    SW.pf("\n");
end

