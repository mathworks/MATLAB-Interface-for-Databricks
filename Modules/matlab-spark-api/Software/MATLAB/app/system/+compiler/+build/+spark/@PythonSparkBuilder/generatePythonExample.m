function generatePythonExample(obj)
    % generatePythonExample Generate a simple example to see how the
    % methods are used

    % Copyright 2022 The MathWorks, Inc.

    old = cd(obj.OutputDir);
    goBack = onCleanup(@() cd(old));



    for k=1:length(obj.Files)
        genPythonFile(obj, k);
        genDeployFile(obj, k);
    end
end

function genDeployFile(obj, idx)


    FILE = obj.Files(idx);
    funcName = FILE.funcName;

    deployName = "deploy_" + funcName + "_example";
    fileName = deployName + ".m";
    fullFileName = fullfile(obj.OutputDir, fileName);

    SW = matlab.sparkutils.StringWriter(fullFileName);

    SW.pf("function [jobRun, job] = %s(cluster)\n", deployName);
    SW.indent();

    SW.pf("%% %s Simple example to deploy %s on databricks\n", deployName, funcName);
    SW.pf("%%\n")
    SW.pf("%% Calling this function will run a job on Databricks\n");
    SW.pf("%% Called without an argument, it will create a job cluster and run it there.\n")
    SW.pf("%%\n")
    SW.pf("%% Called with an argument, the id of an existing cluster, e.g. '1209-072317-u1g6gnbf',\n");
    SW.pf("%% it will run the job there.\n")
    SW.pf("%%\n")
    SW.pf("%% Calling the method will automatically open the runpage of the job in a browser\n\n")
    SW.pf('pythonFile = "%s";\n', obj.ExampleFiles.(funcName).python);
    SW.pf('wheelFile = "%s";\n\n', obj.getWheelFile());
    SW.pf("if nargin > 0\n")
    SW.indent();
    SW.pf("[jobRun, job] = databricks.internal.runSparkPythonTaskExample(pythonFile, wheelFile, cluster=cluster);\n")
    SW.unindent();
    SW.pf("else\n");
    SW.indent();
    SW.pf("[jobRun, job] = databricks.internal.runSparkPythonTaskExample(pythonFile, wheelFile);\n")
    SW.unindent();
    SW.pf("end\n");

    SW.unindent();
    SW.pf("end\n\n");

    obj.ExampleFiles.(funcName).deploy = fullFileName;
end

function genPythonFile(obj, idx)


    allAPIs = obj.getAPIs(false);

    FILE = obj.Files(idx);
    funcName = FILE.funcName;
    api = allAPIs.(funcName);

    extraArgs = getAdditionalArgs(FILE);

    fileName = replace(obj.PkgName + "_" + funcName + "_example" , ".", "_") + ".py";

    fprintf("Generating example file '%s'\n", fileName);

    fullFileName = fullfile(pwd, fileName);
    SW = matlab.sparkutils.StringWriter(fullFileName);

    obj.ExampleFiles.(funcName).python = fullFileName;

    SW.pf("# Example file for generated functions\n\n");

    SW.pf("from __future__ import print_function\n")
    SW.pf("import sys\n")
    SW.pf("from random import random\n\n")

    SW.pf("from pyspark.sql import SparkSession\n")
    SW.pf("from pyspark.sql.functions import col,lit\n")
    SW.pf("from datetime import datetime\n\n")

    SW.pf("# Import special functions from wrapper\n");
    fnAPI = string(fieldnames(api));
    wrapperName = obj.PkgName + ".wrapper";
    for k=1:length(fnAPI)
        FN = fnAPI(k);
        FV = api.(FN);
        if ~apiIsPrivate(FV)
            SW.pf("from %s import %s\n", wrapperName, FV);
        end
    end
    SW.pf('\n');

    SW.pf('if __name__ == "__main__":\n');
    SW.indent();
    SW.pf('"""\n');
    SW.pf('    Usage: %s range_limit out_folder\n', fileName);
    SW.pf('"""\n');
    SW.pf('spark = SparkSession\\\n');
    SW.indent();
    SW.pf('    .builder\\\n');
    SW.pf('    .appName("simple_task")\\\n');
    SW.pf('    .getOrCreate()\n');
    SW.unindent();
    SW.pf('\n');

    SW.pf('now = datetime.now() # current date and time\n');
    SW.pf('suffix = "_" + now.strftime("%%Y%%m%%d_%%H%%M%%S")\n');

    SW.pf('range_limit = int(sys.argv[1]) if len(sys.argv) > 1 else 1000\n\n');

    % SW.pf('out_folder = sys.argv[2] if len(sys.argv) > 2 else "/tmp/simple_task" + suffix\n');

    SW.pf("R = spark.range(range_limit).withColumnRenamed('id', 'xxxx')\n");
    SW.pf('DF = (R\n');
    SW.indent();
    if FILE.TableInterface
        ARGS = FILE.InTypes(1).TableCols;
    else
        ARGS = FILE.InTypes;
    end
    nArgs = length(ARGS);
    for k=1:nArgs
        ARG = ARGS(k);
        SW.pf(".withColumn('%s', R['xxxx'].cast('%s'))\n", ARG.Name, ARG.PrimitiveJavaType);
    end
    SW.unindent();

    inArgNames = join("""" + [ARGS.Name] + """", ",");
    SW.pf(').select(%s)\n\n', inArgNames)

    if isfield(api, 'mapPartitions')
        SW.pf('OUT_mapPartitions = DF.rdd.mapPartitions(%s%s).toDF(%s)\n', ...
            api.mapPartitions, extraArgs, api.outputNames);
        SW.pf("print('mapPartitions result')\n")
        SW.pf('OUT_mapPartitions.show(10, False)\n\n');
    end

    if isfield(api, 'mapInPandas')
        SW.pf('OUT_mapInPandas = DF.mapInPandas(%s%s, %s)\n', ...
            api.mapInPandas, extraArgs, api.outputSchema);
        SW.pf("print('mapInPandas result')\n")
        SW.pf('OUT_mapInPandas.show(10, False)\n\n');
    end

    if isfield(api, 'applyInPandas')
        SW.pf('OUT_applyInPandas = DF.groupBy("%s").applyInPandas(%s%s, %s)\n', ...
            ARGS(1).Name, api.applyInPandas, extraArgs, api.outputSchema);
        SW.pf("print('applyInPandas result')\n")
        SW.pf('OUT_applyInPandas.show(10, False)\n\n');
    end

    SW.pf('print("%s task is now done!")\n', funcName);

    SW.unindent();

    SW.pf('\n');
    SW.pf("# End of file %s\n\n", fileName);

end

function args = getAdditionalArgs(FUNC)
    if ~FUNC.ScopedTables
        args = "";
        return;
    end
    ARGS = FUNC.InTypes(2:end);
    args = "";
    for k=1:length(ARGS)
        ARG = ARGS(k);
        if ARG.MATLABType == "string"
            args(k) = "'Something'";
        else
            args(k) = feval(ARG.MATLABType, rand(1)*100);
        end
    end

    args = "(" + args.join(", ") + ")";
end

function tf = apiIsPrivate(name)
    tf = name.startsWith("__");
end
