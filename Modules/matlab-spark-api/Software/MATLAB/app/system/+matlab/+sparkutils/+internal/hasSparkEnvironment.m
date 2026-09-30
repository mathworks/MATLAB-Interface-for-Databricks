function HSE = hasSparkEnvironment()
    % hasSparkEnvironment Check if this is run in a Spark context
    %
    % Many tests with the matlab-spark-api can only be performed when a
    % Spark Session can be created. This can be available with Apache
    % Spark, Databricks or other custom environments.
    %
    % This function is used to decide to filter certain tests, to enable a
    % testing of the pure Spark package too. To make sure that a test class
    % only runs if a Spark session is available, add this lines as a first
    % line in the TestClassSetup method:
    %
    %   testCase.assumeTrue(matlab.sparkutils.internal.hasSparkEnvironment(), 'Ensure Spark Session is available');
    %
    % If no Spark session is available (by this criteria), the test will
    % not fail, but will be marked as "Filtered out", or in the return
    % values of runtests as "Incomplete".

    % Copyright 2026 MathWorks Inc.

    HSE = false;
    if isDatabricksEnvironment()
        HSE = true;
        return;
    elseif isApacheSparkEnvironment()
        HSE = true;
        return;
    end

end

