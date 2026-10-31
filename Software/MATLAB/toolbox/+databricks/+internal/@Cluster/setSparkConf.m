function setSparkConf(obj, sparkConfPairs)
% SETSPARKCONF Method to create and update spark_conf for the cluster
% Set custom spark_conf on the Cluster object. This is useful when creating new
% clusters, particularly if creating a single node cluster.
%
% For example:
%
%     cl = databricks.internal.Cluster;
%     scpCell = {'spark_master', 'local[*,4]'; 'spark_databricks_cluster_profile', 'singleNode'};
%     scps = databricks.internal.SparkConfPair(scpCell);
%     cl.setSparkConf(scps);

% Possible uses:
% An object containing a set of optional, user-specified Spark configuration key-value
% pairs. You can also pass in a string of extra JVM options to the driver and the executors
% via spark.driver.extraJavaOptions and spark.executor.extraJavaOptions respectively. %Example
% Spark confs: {"spark.speculation": true, "spark.streaming.ui.retainedBatches": 5} or
% {"spark.driver.extraJavaOptions": "-verbose:gc -XX:+PrintGCDetails"}

% Copyright 2020-2026 The MathWorks, Inc.

% Create the property if it does not exist
% spark_conf is a containers.Map
if ~isprop(obj,'spark_conf')
    addprop(obj,'spark_conf');
end

if isa(sparkConfPairs, 'databricks.internal.SparkConfPair')
    if isempty(obj.spark_conf)
        % Add the SparkConfPair
        obj.spark_conf = sparkConfPairs.pairs;
    else
        % Append the SparkConfPair to the existing spark_conf
        newKeys = sparkConfPairs.pairs.keys;
        for n = 1:length(newKeys)
            obj.spark_conf(newKeys{n}) = sparkConfPairs.pairs(newKeys{n});
        end
    end
else
    error('DATABRICKS:INVALID','Invalid conf specified. Use a databricks.internal.SparkConfPair to specify values');
end

end %function
