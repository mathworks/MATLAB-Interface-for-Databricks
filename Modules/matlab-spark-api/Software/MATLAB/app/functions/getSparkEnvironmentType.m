function envType = getSparkEnvironmentType()
    % getSparkEnvironmentType Get the environment type of Spark
    %
    % Spark can be used in either 'Apache Spark' or 'Databricks'
    % environment. This function will return either "ApacheSpark" or
    % "Databricks", depending on what environment is currently used.
    
    % Copyright 2021 MathWorks Inc.
    
    if isDatabricksEnvironment
        envType = "Databricks";
    else
        envType = "ApacheSpark";
    end
    
end