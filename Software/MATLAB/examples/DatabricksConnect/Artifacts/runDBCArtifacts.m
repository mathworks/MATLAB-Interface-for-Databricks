function T = runDBCArtifacts
    % RUNDBCARTIFACTS Test compiled MATLAB artifacts with a Databricks Connect Spark Session
    %
    % When working with artifacts particularly during the test and development
    % phase, be aware of the *forceNewSession* argument to getDatabricksSession
    % This is required if updating the artifact .zip e.g. due to a bug fix.
    %
    % See also: getDatabricksSession
    % 
    %    forceNewSession - If set to true, this will create a new Spark
    %        Session. If set to false or omitted, it will reuse an existing
    %        Spark Session, if available.
    %        This is especially useful in development workflows, where a
    %        new version of an artifact is uploaded with the addArtifact
    %        method. If an old session is reused, the artifact cannot be
    %        reused. Default: false.

    % Get a spark session
    spark = getDatabricksSession();

    % Create some example data
    R = spark.range(1e5);
    DF = R.withColumn("did", matlab.pyspark.sql.functions.randn()).withColumn("other", R.col('id').cast('double') + 100.0);
    DF.show(3)

    % Build the project
    PSB = buildLibrary();

    % Attach the compiler output to the Spark session
    spark.addArtifact(PSB.ZipArtifactName, pyfile=true);

    % Add path to some helper functions
    addpath(fullfile(PSB.OutputDir, 'matlab_udf_helpers'));

    % Get handle to a UDF function
    udf1 = doMath_ml_udf();

    DF_U1 = DF.withColumn("doMath", udf1(DF.col("did"), DF.col("other")));
    DF_U1.show(5)

    % Generated import function brought in by addpath() above 
    artifacts_example_import();

    DF2 = DF.select("id", "did").mapInPandas("addStringCol");

    DF2.show(5);

    t0 = tic; T = DF2.table(); t1 = toc(t0);
    fprintf("Table conversion took %.1f seconds (%d rows)\n", t1, height(T))
end