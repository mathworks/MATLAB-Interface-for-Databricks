function [outNameCode, outNameShell] = generateExamples(file, options)
    % generateExamples Generate examples from File

    % Copyright 2023 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.File
        options.examplesFolder (1,1) string
    end


    fprintf("Generating examples for %s ...\n", file.funcName);

    outNameCode = generatePythonCodeExample(file, options);
    outNameShell = generateShellFileSPython(file, options, outNameCode);

end


function outNameCode = generatePythonCodeExample(file, options)


    outNameCode = fullfile(options.examplesFolder, sprintf("%s_example.py", file.funcName));

    PSB = file.Parent;
    api = file.API;

    SW = matlab.sparkutils.StringWriter(outNameCode);

    SW.pf("# Example file for the function %s\n\n", file.funcName);

    SW.pf("from __future__ import print_function\n")
    SW.pf("import sys\n")
    SW.pf("from random import random\n\n")

    newCell(SW, file);

    SW.pf("from pyspark.sql import SparkSession\n")
    SW.pf("from pyspark.sql.functions import concat,col,lit\n")
    SW.pf("from pyspark.sql.functions import udf\n")

    SW.pf("from pyspark.sql.types import *\n");
    SW.pf("import datetime\n\n")

    newCell(SW, file);

    SW.pf("# Import special functions from wrapper\n");

    importStrings = file.getImports(debug=PSB.Debug);
    SW.insertLines(join(importStrings, newline));

    if PSB.Debug
        SW.pf("import matlab\n");
        SW.pf("import numpy\n");
    end


    newCell(SW, file);

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

    newCell(SW, file);

    SW.pf("# Create some trivial input data with the right data types\n")
    inTypes = file.getInputElements(table=file.TableInterface,individual=~file.TableInterface);
    SW.pf("DATA = [\n");
    SW.indent();
    numRows = 100;
    for k=1:numRows
        numIT = length(inTypes);
        SW.pf("(");
        for it = 1:numIT
            argType = inTypes(it);
            SW.pf('%s,', argType.instantiatePythonExampleValue(k, 1+rem(k+it, 5)));
        end
        SW.pf(")%s\n", argType.getComma(k, numRows));
    end
    SW.unindent();
    SW.pf("]\n");
    SW.pf("\n");

    % % =========================================================
    % SW.pf("R = spark.range(1000).withColumnRenamed('id', 'xxxx')\n");
    % SW.pf('DF = (R\n');
    % SW.indent();
    % srcCol = 'R["xxxx"]';
    % for it = 1:length(inTypes)
    %     argType = inTypes(it);
    %     SW.pf('.withColumn("%s", %s)\n', argType.Name, argType.castLongColumnToValue(srcCol, true));
    % end
    % SW.unindent();
    SW.pf("# Create a dataframe from the example data\n")
    inArgNames = join("'" + [inTypes.Name] + "'", ",");
    SW.pf('DF = spark.createDataFrame(DATA, [%s])\n\n', inArgNames)
    SW.pf('print("### Show example data")\n');
    SW.pf("DF.show(10, False)\n\n");

    SW.pf("# Create a database view of the data\n")
    tblName = sprintf('temptest_%s', file.funcName);
    SW.pf("DF.createOrReplaceTempView('%s')\n\n", tblName);


    % if it's a table function with additional arguments, we need
    % values for these too.
    extraArgsStr = "";
    if file.TableInterface
        extraArgs = file.getInputElements(table=false,individual=true);
        if ~isempty(extraArgs)
            extraArgNames = "arg_" + [extraArgs.Name];
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
        newCell(SW, file);

        SW.pf("# Example data for simple functions\n")
        simpleArgs = string.empty;
        for k=1:file.nArgIn
            CA = file.InTypes(k);
            exVarName = sprintf("exdata_%s", CA.Name);
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
        newCell(SW, file);
        SW.pf('# Register as UDF\n');
        SW.pf('%s(spark)\n\n', file.API.regUDF);

        SW.pf('# Use the UDF on the temporary table\n')
        inNames = file.getInputNameArray();
        inNamesStr = inNames.join(", ");
        SW.pf("UDF1 = spark.sql('SELECT %s, %s_udf(%s) FROM %s')\n", ...
            inNamesStr, file.funcName, inNamesStr, tblName)
        SW.pf("UDF1.show(5, False)\n\n")
    end

    if isfield(file.API, 'regUDFDataframe')
        newCell(SW, file);
        SW.pf('# Register as UDF for Dataframes\n');
        udfDFName = sprintf('%s_udf_df', file.funcName);
        SW.pf('%s = %s()\n\n', udfDFName, file.API.regUDFDataframe);

        SW.pf('# Use in a Dataframe select statement\n')
        inNamesStrQuoted = "'" + inNames.join("', '") + "'";
        SW.pf("UDF2 = DF.select(%s, %s(%s))\n", inNamesStrQuoted, udfDFName, inNamesStrQuoted)
        SW.pf("UDF2.show(5, False)\n\n")
    end

    if isfield(file.API, 'regUDFSeries')
        newCell(SW, file);
        SW.pf('# Register as UDF for Pandas series\n');
        udfDFName = sprintf('%s_udf_series', file.funcName);
        SW.pf('%s = %s()\n\n', udfDFName, file.API.regUDFSeries);

        SW.pf('# Use in a Dataframe select statement\n')
        inNamesSelect = "col('" + inNames + "')";
        inNamesSelectStr = inNamesSelect.join(", ");
        SW.pf("UDF3 = DF.select(%s, %s(%s))\n", inNamesStrQuoted, udfDFName, inNamesSelectStr)
        SW.pf("UDF3.show(5, False)\n\n")
    end


    mt = compiler.build.spark.MethodType.map;
    if ismember(mt, file.MethodTypes)
        newCell(SW, file);

        SW.pf('print("### Run %s with %s")\n', string(mt), file.funcName);
        SW.pf("DF_map = DF.rdd.map(%s_map).toDF(%s_output_names)\n", file.funcName, file.funcName);
        SW.pf("DF_map.show(10, False)\n\n")
    end

    mt = compiler.build.spark.MethodType.mapPartitions;
    if ismember(mt, file.MethodTypes)
        newCell(SW, file);

        SW.pf('print("### Run %s with %s")\n', string(mt), file.funcName);
        SW.pf("DF_mapPartitions = DF.rdd.mapPartitions(%s_mapPartitions).toDF(%s_output_names)\n", file.funcName, file.funcName);
        SW.pf("DF_mapPartitions.show(10, False)\n\n")
    end

    mt = compiler.build.spark.MethodType.mapPartitionsTable;
    if ismember(mt, file.MethodTypes)
        newCell(SW, file);

        SW.pf('print("### Run %s with %s")\n', string(mt), file.funcName);
        SW.pf("DF_mapPartitions = DF.rdd.mapPartitions(%s_mapPartitions%s).toDF(%s_output_names)\n", ...
            file.funcName, extraArgsStr, file.funcName);
        SW.pf("DF_mapPartitions.show(10, False)\n\n")
    end

    mt = compiler.build.spark.MethodType.applyInPandas;
    if ismember(mt, file.MethodTypes)
        tableArgs = file.getInputElements(table=true, individual=false);
        tableArgNames = [tableArgs.MATLABType];
        if ~any(tableArgNames.contains("datetime"))
            % datetime types don't work with Pandas
            newCell(SW, file);
            groupByArg = chooseGroupbyColumn(file);
            SW.pf('print("### Run %s with %s")\n', string(mt), file.funcName);
            SW.pf('DF_applyInPandas = DF.groupBy("%s").applyInPandas(%s_applyInPandas%s, %s_output_schema)\n', ...
                groupByArg.Name, file.funcName, extraArgsStr, file.funcName);
            SW.pf("DF_applyInPandas.show(10, False)\n\n")
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

function newCell(SW, file)

    if file.isPythonBuild
        comment = "# ";
    else
        comment = "// ";
    end

    SW.pf("\n");
    SW.pf("%sCOMMAND ----------\n", comment);
    SW.pf("\n");
end

function groupByArg = chooseGroupbyColumn(file)
    args = file.getInputElements(table=true, individual=false);
    argTypes = [args.MATLABType];
    colIdx = find("string" == argTypes, 1);
    if isempty(colIdx)
        colIdx = find("int32" == argTypes, 1);
    end
    if isempty(colIdx)
        colIdx = find("int64" == argTypes, 1);
    end
    if isempty(colIdx)
        colIdx = 1;
    end
    groupByArg = args(colIdx);

end
