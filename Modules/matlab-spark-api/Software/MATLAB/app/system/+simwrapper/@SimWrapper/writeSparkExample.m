function cName = writeSparkExample(swo)
    % writeSparkExample Write MATLAB example to call Databricks

    % Copyright 2024-2026 MathWorks, Inc.

    arguments
        swo (1,1) simwrapper.SimWrapper
    end

    funcName = string(swo.CI.Name) + "_spark_example";
    mName = funcName + ".m";

    sw = matlab.sparkutils.StringWriter(mName);

    sw.pf("function T_OUT = %s(options)\n", funcName);
    sw.indent();
    sw.pf("%% %s\n", funcName);
    sw.pf("%% Example to call DLL from MATLAB.\n")
    sw.pf("%% The default is to use a serverless session. If this is\n")
    sw.pf("%% not desired, please specify the additonal argument serverless=false.\n")
    sw.pf("%% NOTE: This example currently only works with Databricks\n\n")

    sw.pf("arguments\n");
    sw.indent();
    sw.pf("options.N (1,1) double = 100\n")
    sw.pf("options.serverless (1,1) logical = true\n")
    sw.pf("options.profileName (1,1) string\n")
    sw.pf("options.authMethod (1,1) matlab.databricks.AuthMethod\n")
    sw.pf("options.addArtifact (1,1) logical = true\n")
    sw.pf("options.spark (1,1) matlab.pyspark.sql.session.SparkSession\n");
    % sw.pf("options.uploadSO (1,1) logical = false\n")
    sw.pf("options.cluster {databricks.internal.cluster.mustBeScalarClusterOrId}\n")
    sw.pf("options.forceNewSession (1,1) logical = true\n")
    
    sw.unindent();
    sw.pf("end\n\n")
    
    sw.pf("%% Get a Spark Session\n");
    sw.pf("if isfield(options, 'spark')\n");
    sw.indent();
    sw.pf("spark = options.spark;\n");
    sw.unindent();
    sw.pf("else\n");
    sw.indent();
    sw.pf('args = matlab.utils.addArgs(options, ["authMethod", "profileName", "serverless", "cluster", "forceNewSession"]);\n')
    sw.pf("spark = getDatabricksSession(args{:});\n")
    sw.unindent();
    sw.pf("end\n\n");

    sw.pf("%% Add the zip artifact to the session\n");
    sw.pf("if options.addArtifact\n");
    sw.indent();
    sw.pf("spark.addArtifact('%s', pyfile=true);\n", swo.ArtifactName);
    soName = fullfile("..", string(swo.CI.Name) + ".so");
    sw.pf("spark.addArtifact('%s', file=true);\n", soName);

    sw.unindent();
    sw.pf("end\n\n");
    sw.pf("%% Create some example data\n");
    sw.pf("R = spark.range(options.N);\n");

    sw.pf("DF = R ...\n");

    numIn = numel(swo.CI.Inports);
    inNames = [swo.Inports.Name];
    sw.indent();
    for k=1:numIn
        P = swo.Inports(k);
        switch P.MLType
            case {"double", "single"}
                sw.pf(".withColumn('%s', R.col('id').cast('%s')) ...\n", P.Name, P.SparkType);
            case {"int64", "int32", "int16"}
                sw.pf(".withColumn('%s', rem(R.col('id'), intmax('%s')).cast('%s')) ...\n", P.Name, P.MLType, P.SparkType);
            otherwise
                sw.pf(".withColumn('%s', R.col('id').cast('%s')) ...\n", P.Name, P.SparkType);
        end
    end
    sw.pf(".select(%s);\n", join("'" + inNames + "'", ", "));
    sw.unindent();  
    sw.pf("\n");

    sw.pf("%% Run as mapInPandas\n");
    importStmt = sprintf("from %s import run_sim_iter", swo.getFullPyPkgName());
    sw.pf('pyrun("%s")\n', importStmt);
    sw.pf('DF_OUT = DF.mapInPandas("run_sim_iter", schema="%s");\n\n', swo.getSparkOutputSchema());

    sw.pf("%% Create MATLAB table\n")
    sw.pf("T_OUT = DF_OUT.table();\n\n")
    sw.unindent();
    sw.pf('end\n\n')
    sw.pf("%% End of file: %s \n\n", mName);
end