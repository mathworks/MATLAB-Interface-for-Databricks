function isDB = isApacheSparkEnvironment()
    % isApacheSparkEnvironment Check if this is run in Apache Spark context
    %
    % Spark can be used in either 'Apache Spark' or 'Databricks'
    % environment. This function will return either true if this is a
    % Apache Spark environment.

    % Copyright 2026 MathWorks Inc.

    try
        ignoreMe = apacheSparkRoot(); %#ok<NASGU>
        isDB = true;
    catch ME 
        isDB = false;
    end

end

