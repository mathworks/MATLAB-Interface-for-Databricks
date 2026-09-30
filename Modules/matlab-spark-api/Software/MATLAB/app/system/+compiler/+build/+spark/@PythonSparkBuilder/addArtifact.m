function addArtifact(obj, spark, options)
    % addArtifact Add artifact and import python classes
    %
    % This is a helper method for the PythonSparkBuilder. It performs two
    % important steps when using the addArtifact functionality of
    % Spark-Connect.
    %
    %  1. It adds the artifact to the Spark Session
    %  2. It executes the necessary Python imports of the corresponding
    %     library. This will execute in the local MATLAB and is necessary for
    %     this workflow.
    %
    % If using this with the `plusPi` function in the `CompiledMATLAB`
    % example (the plusPi function simply adds PI to a double column x).
    % This can be found in this directory:
    %   databricksRoot('examples', 'DatabricksConnectWorkflow', 'CompiledMATLAB')
    %
    % PSB = buildLibrary();
    % spark = getDatabricksSession();
    % PSB.addArtifact(spark)
    %
    % R = spark.range(100);
    % DF = R.withColumn("x", R.col("id").cast('double')).select('x');
    % OUT = DF.groupBy("x").applyInPandas("plusPi_applyInPandas", schema="plusPi_output_schema");
    % OUT.show(3, false);
    % +-----------------+
    % |pp               |
    % +-----------------+
    % |3.141592653589793|
    % |4.141592653589793|
    % |5.141592653589793|
    % +-----------------+
    % only showing top 3 rows
    %
    %  Adding artifacts with this function will additionally reload the
    %  module library, which is helpful if the library has been rebuilt in
    %  the same MATLAB session.

    % Copyright 2026 The MathWorks, Inc.

    arguments
        obj (1,1) compiler.build.spark.PythonSparkBuilder
        spark (1,1) databricks.PySparkSession
        options.verbose (1,1) logical = true
    end

    if options.verbose
        fprintf("Add artifact to the Spark session.\n")
    end

    pe = pyenv;
    if pe.ExecutionMode ~= "InProcess"
        fprintf(2, "The ExecutionMode for the Python Environment is not InProcess.\n");
        fprintf(2, "This is necessary when calling MATLAB code on Databricks from within MATLAB.\n");
        fprintf(2, "This can be changed by restarting MATLAB, and running the following (before executing Python commands):\n");
        fprintf(2, "    pyenv('ExecutionMode', 'InProcess')\n");
    end

    spark.addArtifact(obj.ZipArtifactName, pyfile=true);

    % Running the imports of the Python package
    old = cd(obj.OutputDir);
    goBack = onCleanup(@() cd(old));

    if options.verbose
        fprintf("Importing Python functions into local MATLAB session.\n")
    end

    % Load and reload the module. This is helpful in case any changes were
    % done to the module.
    wrapper = py.importlib.import_module(obj.PkgName);
    py.importlib.reload(wrapper);

    % Import the methods and properties exported by this module
    pyrun(obj.getImports);

end
