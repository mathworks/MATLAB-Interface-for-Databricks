function setClusterLogConf(obj, logObj)
    % SETCLUSTERLOGCONF Method to set the location of cluster logs
    % Set the location for logs produced by the cluster e.g. during the
    % initialization of the cluster.
    %
    % For example:
    %
    %   cl = databricks.Cluster;
    %   conf = databricks.ClusterLogConf;
    %   conf.setDestination("dbfs:/logs/cluster_logs");
    %
    %   cl.setClusterLogConf(conf);
    %
    % For simplicity, a string can be used, which will create the underlying
    % ClusterLogConf object.
    %
    %   cl = databricks.Cluster;
    %   cl.setClusterLogConf("dbfs:/logs/cluster_logs");

    %   (c) 2020-2026 MathWorks, Inc.

    arguments
        obj (1,1) databricks.Cluster
        logObj (1,1) databricks.ClusterLogConf
    end

    % Check if we have a valid object
    if ~isprop(obj,'cluster_log_conf')
        addprop(obj,'cluster_log_conf');
    end

    % set it as a property value
    obj.cluster_log_conf = logObj;

end %function
