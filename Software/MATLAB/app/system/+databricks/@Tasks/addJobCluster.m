function addJobCluster(obj, clusterKey, clusterObject)
    % addJobCluster Add a job-level cluster to this task
    %
    % Arguments
    %    clusterKey A string denoting this cluster
    %    clusterObject An object representing a cluster to run
    % Example:
    %  T = databricks.Tasks();
    %  cl1 = createDatabricksCluster(...
    %      '', ...  No name for this kind of cluster
    %      2, ... Two workers
    %      'create', false ... Don't create the cluster
    %      );
    %  cl2 = createDatabricksCluster(...
    %      '', ...  No name for this kind of cluster
    %      0, ... Single-node cluster
    %      'create', false ... Don't create the cluster
    %      );
    %  T.addJobCluster('cl1', cl1);
    %  T.addJobCluster('cl2', cl2);
    %

    % Copyright 2022-2023 MathWorks, Inc.

    arguments
        obj databricks.Tasks
        clusterKey string
        clusterObject databricks.Cluster
    end

    clusterObject = removeAutoTermination(clusterObject);

    if ~isprop(obj, 'job_clusters')
        addprop(obj, 'job_clusters');
        obj.job_clusters = struct(...
            'job_cluster_key', clusterKey, ...
            'new_cluster', clusterObject);
    else
        obj.job_clusters(end+1) = struct(...
            'job_cluster_key', clusterKey, ...
            'new_cluster', clusterObject);
    end
end

function cl = removeAutoTermination(cl)
    % A cluster for a task may not have autotermination set
    prop = findprop(cl, 'autotermination_minutes');
    if ~isempty(prop)
        warning('DATABRICKS:autotermination_set_for_jobcluster', ...
            'auto_termination may not be set for a job cluster.\n');
        delete(prop)
    end
end