function release = getClusterMATLABRelease(options)
    % GETCLUSTERMATLABRELEASE Get the value of the MW_RUNTIME_RELEASE Spark Environment Variable
    % The result is returned as a string.
    % If the variable is not defined an empty string is returned.
    % The required cluster argument can be specified as a scalar text or as a
    % databricks.Cluster object.
    %
    % Example:
    %   release = matlab.databricks.cluster.getClusterMATLABRelease(cluster=clusterId)

    % Copyright 2024 The MathWorks, Inc.

    arguments
        options.cluster {databricks.internal.cluster.mustBeScalarClusterOrId}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.verbose (1,1) logical = true
    end

    release = string.empty;

    if ~isfield(options, "cluster")
        args = matlab.utils.addArgs(options, ["profileName", "verbose"]);
        cluster = databricks.internal.configurationprofile.ConfigFile.getProfileField("cluster_id", args{:});
        if isempty(cluster) || strlength(cluster) == 0
            % No cluster in options struct or cfg file
            if options.verbose
                fprintf(2, "Cluster not set in configuration file.\n");
            end
            return;
        end
    else
        cluster = options.cluster;
    end

    if isa(cluster, "databricks.Cluster")
        if ~isprop(cluster, "cluster_id")
            if options.verbose
                fprintf(2, "Cluster does not have a cluster_id property.\n");
            end
            return;
        end
        clusterId = string(cluster.cluster_id);
    else
        clusterId = string(cluster);
    end

    if isempty(clusterId) || strlength(clusterId) == 0
        if options.verbose
            fprintf(2, "Cluster Id value not set.\n");
        end
        return;
    end

    if isa(cluster, "databricks.Cluster")
        clusterObj = cluster;
    else
        args = matlab.utils.addArgs(options, ["profileName", "authMethod"]);
        clusterObj = databricks.Cluster.findById(clusterId, args{:});
        if isempty(clusterObj)
            if options.verbose
                fprintf(2, "Cluster: %s not found.\n", clusterId);
            end
            return;
        end
    end

    if isprop(clusterObj, "spark_env_vars")
        if isa(clusterObj.spark_env_vars, "containers.Map")
            keys = clusterObj.spark_env_vars.keys;
            if any(contains(keys, "MW_RUNTIME_RELEASE"))
                release = string(clusterObj.spark_env_vars("MW_RUNTIME_RELEASE"));
            else
                if options.verbose
                    fprintf("MW_RUNTIME_RELEASE Spark environment variable not defined for cluster: %s\n", clusterId);
                end
            end
        else
            if options.verbose
                fprintf(2, "Cluster spark_env_vars property is not a containers.Map, found: %s\n", class(clusterObj.spark_env_vars));
            end
            return;
        end
    else
        if options.verbose
            fprintf(2, "Cluster does not have a spark_env_vars property.\n");
        end
        return;
    end
end