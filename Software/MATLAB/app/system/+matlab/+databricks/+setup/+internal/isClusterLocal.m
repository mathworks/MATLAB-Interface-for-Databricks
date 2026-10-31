function tf = isClusterLocal(clusterId)
    % isClusterLocal Returns true if clusterId is same as local cluster
    %
    % Example
    %   tf = matlab.databricks.setup.internal.isClusterLocal('0825-123456-abcdde')

    % Copyright 2025 The MathWorks, Inc.

    arguments
        clusterId (1,1) string
    end

    hostClusterId = string(getenv("MW_CLUSTER_ID"));

    tf = hostClusterId == clusterId;

end