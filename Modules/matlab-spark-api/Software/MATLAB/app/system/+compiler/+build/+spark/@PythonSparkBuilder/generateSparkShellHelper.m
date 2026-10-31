function generateSparkShellHelper(obj)
    % generateSparkShellHelper Generate a shell script for interactive test

    % Copyright 2022 The MathWorks, Inc.

    old = cd(obj.OutputDir);
    goBack = onCleanup(@() cd(old));

    fileName = genFile(obj);
    if isunix
        [r, s] = system(sprintf("chmod +x %s", fileName));
    end
end

function fileName = genFile(obj)

    baseDir = fileparts(pwd);
    templateFile = fullfile(baseDir, '.psb.py');
    hasOwnTemplate = isfile(templateFile);

    fileName = fullfile('.', 'runPySparkShell.sh');
    SW = matlab.sparkutils.StringWriter(fileName);


    SW.pf("#!//bin/bash\n\n");

    SW.pf("set -xeuo pipefail\n\n");

    SW.pf("echo ""This script requires that the variable SPARK_HOME is set and pointing to a valid Spark installation""\n");
    SW.pf("echo ""This cannot be used on Databricks""\n");
    SW.pf("echo ""Starting Spark shell from $SPARK_HOME""\n\n");

    MCR_ROOT = "R" + string(version('-release'));

    SW.pf("export MCR_ROOT=/usr/local/MATLAB/MATLAB_Runtime\n");
    SW.pf("export MCR=$MCR_ROOT/%s\n", MCR_ROOT);
    SW.pf("export LD_LIBRARY_PATH=${MCR}/runtime/glnxa64:${MCR}/bin/glnxa64:${MCR}/sys/os/glnxa64:${MCR}/sys/opengl/lib/glnxa64\n\n");
    SW.pf("export PYSPARK_PYTHON=python3\n\n");
    
    SW.pf("SCRIPT_DIR=""$( cd ""$( dirname ""${BASH_SOURCE[0]}"" )"" >/dev/null 2>&1 && pwd )""\n");

    SW.pf("cd $SCRIPT_DIR\n");
    SW.pf("# Get some starting code into the clipboard\n");
    SW.pf("cat > somefile <<- END_OF_CODE\n");

    SW.pf("from %s.wrapper import Wrapper as W\n", obj.PkgName);
    SW.pf("from pyspark.sql.functions import col,lit\n")

    if hasOwnTemplate
        SW.insertFile(templateFile);
        SW.pf("\n");
    else

        SW.pf("df = spark.range(1, 240)\n");
        SW.pf("df1 = df.withColumnRenamed(""id"", ""col_long"")\n")
        SW.pf("df2 = df1.withColumn(""col_string1"", lit(""abcxzy"")).withColumn(""col_string2"", col(""col_long"").cast(""string""))\n")
        SW.pf("df3 = df2.withColumn(""col_int"", col(""col_long"").cast(""int""))\n")
        SW.pf("df4 = df3.withColumn(""col_short"", col(""col_int"").cast(""short""))\n");
        SW.pf("df5 = df4.withColumn(""col_bool1"", col(""col_long"") %% 2 == 0)\n");
        SW.pf("df6 = df5.withColumn(""col_bool2"", col(""col_long"") %% 3 == 0)\n");
        SW.pf("df7 = df6.withColumn(""col_double"", col(""col_long"").cast(""double""))\n");

        SW.pf("df7.printSchema()\n")
        SW.pf("df7.show(10, False)\n")
    end
    SW.pf("END_OF_CODE\n\n");

    
    SW.pf('if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then\n');
    SW.indent();
    SW.pf('cat somefile | clip.exe\n');
    SW.unindent();
    SW.pf('else\n');
    SW.indent();
    SW.pf('xclip -i somefile\n');
    SW.unindent();
    SW.pf('fi\n');
    
    SW.pf("rm somefile\n\n");
    %     SW.pf("# Prepend with SPARK_SUBMIT_OPTS for debugging\n");
    %     SW.pf("# SPARK_SUBMIT_OPTS=""-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005""\n");
    SW.pf("$SPARK_HOME/bin/pyspark " + ...
        "--total-executor-cores 4 " + ...
        "--py-files %s\n\n", obj.getWheelFile());
    SW.pf("# End of file\n\n");

end
