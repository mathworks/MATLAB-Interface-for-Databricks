function runNotebookTask(options)
    % runNotebookTask Simple example for running a notebook
    %
    % To run with an existing cluster, provide a clusterId or a cluster
    % object as an option.

    % Copyright 2024-2026 The MathWorks, Inc.

    arguments
        options.cluster {databricks.internal.cluster.mustBeScalarClusterOrId}
        options.N (1,1) int64 = 100
    end

    if isfield(options, 'cluster')
        cluster = options.cluster;
        if isa(cluster, 'databricks.Cluster')
            cluster = cluster.cluster_id;
        end
        namePrefix = "TasksExample-RunOnExistingCluster";
    else
        cluster = createDatabricksCluster('', 0, useMATLAB=false, create=false);
        namePrefix = "TasksExample-RunOnNewCluster";
    end

    nbTask = createNotebookTask(N=options.N);

    job = databricks.Job();
    job.name = namePrefix + "Tasks_NotebookExample_" + string(datetime('now', 'Format', 'uuuuMMdd_HHmmss'));
    job.setTask(nbTask);

    job.setCluster(cluster);
  
    % Create the job
    job.create()

    jobRun = job.runNow();

    fprintf('Created job "%s", see run <a href="%s">here</a>\n', job.name, jobRun.run_page_url)
end