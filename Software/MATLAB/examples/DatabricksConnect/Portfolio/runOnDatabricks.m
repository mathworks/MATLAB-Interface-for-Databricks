function result = runOnDatabricks(PSB, deltaPath)
    % RUNONDATABRICKS Run portfolio optimization on Databricks

    % Copyright 2024-2026 The MathWorks, Inc.

    arguments (Input)
        PSB (1,1) compiler.build.spark.PythonPackageBuilder
        deltaPath (1,1) string
    end
    arguments (Output)
        result table
    end

    % Create a spark session
    spark = getDatabricksSession();

    % Import the python functions
    run(fullfile(PSB.OutputDir, 'matlab_udf_helpers', 'import_functions.m'));

    % Read assets data from a predetermined location
    assetsDeltaDS = spark.read.format('delta').load(deltaPath).cache();

    % Add the compiled artifact to the spark session
    spark.addArtifact(PSB.ZipArtifactName, pyfile=true);

    % Call the optimization function on Databricks using mapInPandas
    result = table(assetsDeltaDS.mapInPandas("optimizePortfolio"));
end
