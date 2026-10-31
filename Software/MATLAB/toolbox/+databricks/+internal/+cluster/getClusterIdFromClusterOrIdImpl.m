function [clId, clusterObj] = getClusterIdFromClusterOrIdImpl(cluster, options)
    % getClusterIdFromClusterOrIdImpl Returns the cluster_id
    %
    % The argument can be either a databricks.internal.Cluster object or a
    % cluster_id in the form of a string
    %
    % Will error if cluster_id is empty
    %
    % If called with two return values, the second value will be the actual
    % cluster object, i.e.
    %
    % [clId, clusterObj] = ...
    %    databricks.internal.cluster.getClusterIdFromClusterOrIdImpl(aClusterId)
    %
    % [clId, clusterObj] = ...
    %    databricks.internal.cluster.getClusterIdFromClusterOrIdImpl(aClusterObj)
    %
    % In the first case, clID == aClusterId, and in the second case,
    % clusterObj == aClusterObj.
    % This might seem superfluous, but the advantage is to always get both
    % these values, irregardless of the argument provided.
    %
    % See also databricks.internal.cluster.mustBeScalarClusterOrIdImpl

    % Copyright 2024-2026 The MathWorks, Inc.

    arguments
        cluster {databricks.internal.cluster.mustBeScalarClusterOrIdImpl}
        options.authMethod (1,1) matlab.internal.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    if isa(cluster, 'databricks.internal.Cluster')
         if ~isprop(cluster, 'cluster_id')
             error('DATABRICKS:ClusterWithoutID', "This cluster object has no cluster_id property.");
         end
         clId = string(cluster.cluster_id);
         if isempty(clId) || strlength(clId) == 0
             error('DATABRICKS:ClusterWithEmptyID', "This cluster object has an empty cluster_id property.");
         end
         if nargout > 1
             clusterObj = cluster;
         end
    else
        clId = cluster;
        if nargout > 1
            args = matlab.internal.utils.addArgs(options, ["authMethod", "profileName"]);
            clusterObj = databricks.internal.Cluster.findById(clId, args{:});
        end
    end

end
