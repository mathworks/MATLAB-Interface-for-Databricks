function setSparkEnvVars(obj, SparkEnvPairs)
    % SETSPARKENVVARS Method to create and update environment variables for the cluster
    % Set spark_env_vars on the Cluster object. This is useful when creating new
    % clusters.
    %
    % For example:
    %
    %     cl = databricks.internal.Cluster;
    %     var = databricks.internal.SparkEnvPair('SPARK_LOCAL_DIRS','/local_disk0');
    %     cl.setSparkEnvVars(var);

    % Copyright 2022-2026 The MathWorks, Inc.

    arguments (Input)
        obj databricks.internal.Cluster
        SparkEnvPairs databricks.internal.SparkEnvPair
    end

    % Create the property if it does not exist
    % spark_env_vars is a containers.Map
    if ~isprop(obj,'spark_env_vars')
        addprop(obj,'spark_env_vars');
    end

    if isempty(obj.spark_env_vars)
        % Add the spark_env_vars
        if isa(SparkEnvPairs.envVarPairs, 'containers.Map')
            obj.spark_env_vars = SparkEnvPairs.envVarPairs;
        else
            error('DATABRICKS:SETSPARKENVVARS',"Expected SparkEnvPairs.envVarPairs to be of type containers.Map, found: %s", class(SparkEnvPairs.envVarPairs));
        end
    else
        % Append the SparkEnvPair to the existing custom_tags
        newKeys = SparkEnvPairs.envVarPairs.keys;
        for n = 1:length(newKeys)
            obj.spark_env_vars(newKeys{n}) = SparkEnvPairs.envVarPairs(newKeys{n});
        end
    end
end
