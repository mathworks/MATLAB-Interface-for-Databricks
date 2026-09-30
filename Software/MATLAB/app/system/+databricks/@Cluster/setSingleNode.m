function setSingleNode(obj)
    % SETSINGLENODE Configures cluster properties for a single node cluster
    % Calls setNumWorkers(), setCustomTags() & SparkConfPair() with the required
    % arguments needed to create a single node cluster.

    % (c) 2021 MathWorks, Inc.

    % 0 workers
    obj.setNumWorkers(0);

    % Configure a tag to denote a single node cluster
    tagSingleNode = {'ResourceClass','SingleNode'};
    tags = databricks.ClusterTag(tagSingleNode);
    obj.setCustomTags(tags);

    % Configure a SparkConfPair to denote a single node cluster
    scpSingleNode = {'spark.master','local[*,4]';'spark.databricks.cluster.profile','singleNode'};
    scps = databricks.SparkConfPair(scpSingleNode);
    obj.setSparkConf(scps);

end