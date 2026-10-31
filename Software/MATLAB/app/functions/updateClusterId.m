function updateClusterId(clusterOrId, options)
    % updateClusterId Updates cluster_id and or serverless_compute_id fields in the.databrickscfg file
    % The DATABRICKS_CLUSTER_ID environment variable is not updated.
    %
    % The fields are set in the default profile if the profileName named
    % argument is not set.
    %
    % If an Id argument of "serverless" (case insensitive) is provided then
    % the serverless_compute_id will be added if needed and set to "auto". This 
    % can be used with Databricks Connect. If present a cluster_id field will be
    % removed.
    %
    % If a cluster Id or cluster object is provided, the cluster_id field will be
    % set to the cluster Id. If present a serverless_compute_id field will be
    % removed.
    %
    % Example:
    %   % Update the default profile with a cluster Id
    %   updateClusterId("1204-203818-01j3wxif")
    %
    %   % Update the default profile with a cluster object
    %   updateClusterId(myDatabricksClusterObject)
    %
    %   % Update the default profile to use serverless compute
    %   updateClusterId("serverless");
    %
    % An optional nondefault profile name can also be provided.

    %  Copyright 2022-2025 MathWorks, Inc.

    arguments
        clusterOrId {databricks.internal.cluster.mustBeScalarClusterOrId}
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.verbose (1,1) logical = false
    end

    if isa(clusterOrId, 'databricks.Cluster')
        if isprop(clusterOrId, 'cluster_id')
            clusterId = clusterOrId.cluster_id;
        else
            error('DATABRICKS:updateClusterId', 'databricks.Cluster object does not have a cluster_id property');
        end
    else
        clusterId = string(clusterOrId);
    end

    if strcmpi(clusterId, "serverless")
        % Update .databrickscfg with serverless_compute_id = auto
        if ~databricks.internal.configurationprofile.ConfigFile.writeProfileField(options.profileName, "serverless_compute_id", "auto", verbose=options.verbose)
            warning("DATABRICKS:updateClusterId", "Error writing: cluster_id to profile: %s, in .databrickscfg file", options.profileName);
        end
        
        clusterId = databricks.internal.configurationprofile.ConfigFile.getProfileField("cluster_id", profileName=options.profileName);
        if ~isempty(clusterId) && strlength(clusterId) > 0
            fprintf("Removing the cluster_id field: %s in profile: %s from the .databrickscfg file to enable serverless mode.\n",clusterId, options.profileName);
            tf = databricks.internal.configurationprofile.ConfigFile.deleteProfileField("cluster_id", profileName=options.profileName, verbose=options.verbose); %#ok<NASGU>
        end
    else
        % Update .databrickscfg with the cluster_id
        if ~databricks.internal.configurationprofile.ConfigFile.writeProfileField(options.profileName, "cluster_id", clusterId, verbose=options.verbose)
            warning("DATABRICKS:updateClusterId", "Error writing: cluster_id to profile: %s, in .databrickscfg file", options.profileName);
        end

        serverlessComputeId = databricks.internal.configurationprofile.ConfigFile.getProfileField("serverless_compute_id", profileName=options.profileName);
        if ~isempty(serverlessComputeId) && strlength(serverlessComputeId) > 0
            fprintf("Removing the serverless_compute_id field: %s in profile: %s from the .databrickscfg file to enable classic mode.\n", serverlessComputeId, options.profileName);
            tf = databricks.internal.configurationprofile.ConfigFile.deleteProfileField("serverless_compute_id", profileName=options.profileName, verbose=options.verbose); %#ok<NASGU>
        end
    end
end