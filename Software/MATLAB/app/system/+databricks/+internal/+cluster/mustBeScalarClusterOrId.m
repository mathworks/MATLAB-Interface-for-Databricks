function mustBeScalarClusterOrId(arg)
    % mustBeClusterOrId Check if an argument is a cluster or cluster id
    % 
    % This can be used as a validator in arguments blocks.
    % 
    % It cannot be a cluster or cluster_id array.
    %
    % Example:
    %   arguments
    %       clusterOrId {databricks.internal.cluster.mustBeScalarClusterOrId}
    %   end

    % A clusterId string might also be "serverless", for use with Databricks Connect.

    % Copyright 2024-2025 The MathWorks, Inc.

    switch class(arg)
        case 'databricks.Cluster'
            if ~isscalar(arg)
                error('DATABRICKS:CLUSTER_ARGUMENT_NON_SCALAR', ...
                    'A databricks.Cluster cluster argument must be scalar');
            end
        case 'string'
            if ~isscalar(arg)
                error('DATABRICKS:CLUSTER_ARGUMENT_NON_SCALAR', ...
                    'A string cluster argument must be scalar');
            end
            if strlength(arg) == 0
                error('DATABRICKS:CLUSTER_ARGUMENT_EMPTY_STRING', ...
                    'A string cluster id argument must be a non-empty string');
            end
        case 'char'
            arg = string(arg);
            if ~isscalar(arg)
                error('DATABRICKS:CLUSTER_ARGUMENT_NON_SCALAR', ...
                    'A char cluster id argument must be be convertible to a scalar string');
            end            
            if strlength(arg) == 0
                error('DATABRICKS:CLUSTER_ARGUMENT_EMPTY_STRING', ...
                    'A char cluster Id argument must be convertible to a non-empty string.');
            end
        otherwise
            error('DATABRICKS:CLUSTER_ARGUMENT_BAD_TYPE', ...
                'Unsupported cluster argument type: %s', class(arg));
    end
end