function tf = isLibraryPolicySet(options)
    % ISLIBRARYPOLICYSET Returns true if a Cluster has one or more libraries defined in a policy
    % Returns false a library is not defined in a policy or there is no policy set.
    % If there is an error determined a cluster an empty logical is returned.
    
    % (c) 2024 MathWorks, Inc.

    arguments
        options.cluster {databricks.internal.cluster.mustBeScalarClusterOrId}
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.verbose (1,1) logical = false
    end

    if isfield(options, 'cluster')
        args = matlab.utils.addArgs(options, ["profileName", "authMethod"]);
        [clusterId, cluster] = databricks.internal.cluster.getClusterIdFromClusterOrId(options.cluster, args{:});
    else
        args = matlab.utils.addArgs(options, ["profileName", "verbose"]);
        clusterId = databricks.internal.configurationprofile.ConfigFile.getProfileField("cluster_id", args{:});
        if isempty(clusterId)
            fprintf(2, "Failed to get a cluster ID.\n");
            tf = logical.empty;
            return;
        end
        args = matlab.utils.addArgs(options, ["profileName", "authMethod"]);
        cluster = databricks.Cluster.findById(clusterId, args{:});
    end

    if isempty(cluster)
        fprintf(2, "Failed to get a cluster object.\n");
        tf = logical.empty;
        return;
    end

    if isprop(cluster, "policy_id")
        args = matlab.utils.addArgs(options, ["profileName", "verbose"]);
        policy = databricks.ClusterPolicy(args{:});
        currPol = policy.get(cluster.policy_id);
        if isprop(currPol, "libraries")
            if isempty(currPol.libraries)
                tf = false;
            else
                tf = true;
            end
        else
            tf = false;
        end
    else
        tf = false;
    end
end