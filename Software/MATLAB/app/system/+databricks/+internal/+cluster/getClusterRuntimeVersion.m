function clusterRuntimeVersion = getClusterRuntimeVersion(cluster)
    % GETCLUSTERRUNTIMEVERSION Returns the numeric value of a cluster runtime as a string e.g. 16.4
    % Errors if the cluster is empty.
    % Errors if the cluster spark_version property is missing or not set.
    %
    % Example:
    %   ver = databricks.internal.cluster.getClusterRuntimeVersion(clusterObj);

    %  Copyright 2025 MathWorks, Inc.
    
    arguments (Input)
        cluster databricks.Cluster
    end
    arguments (Output)
        clusterRuntimeVersion string
    end

    errBase = "DATABRICKS:GETDATABRICKSSESSION:GETCLUSTERRUNTIMEVERSION";

    if isempty(cluster)
        error(errBase+":NOCLUSTER", ...
            "Specified cluster not found.\n" + ...
            "Provide or update (updateClusterId) cluster value or use serverless to mode.");
    end

    if ~isprop(cluster, "spark_version") || strlength(cluster.spark_version) == 0
        error(errBase+":SPARKVER", "Cluster's spark_version property is missing or not set.");
    else
        % Go from "16.4.x-scala2.12" to "16.4"
        clusterRuntimeVersion = string(databricks.internal.cluster.getSparkBaseVersion(cluster.spark_version));
    end
end