function runMATLABBatchTask(options)
    % runMATLABBatchTask Simple example for running a MATLAB Batch Task
    %
    % To run with an existing cluster, provide a clusterId or a cluster
    % object as an option.

    % Copyright 2026 The MathWorks, Inc.

    arguments (Input)
        options.cluster {databricks.internal.cluster.mustBeScalarClusterOrId}
        options.dockerAuthFile string {mustBeFile}
    end

    if isfield(options, 'cluster')
        cluster = options.cluster;
        if isa(cluster, 'databricks.Cluster')
            cluster = cluster.cluster_id;
        end
        namePrefix = "MATLABBatchTask-Example-RunOnExistingCluster";
    else
        namePrefix = "MATLABBatchTask-Example-RunOnNewCluster";
        if isfield(options, "dockerAuthFile")
            scp = databricks.SparkConfPair('spark.databricks.unityCatalog.volumes.enabled', 'true');
            cluster = createDatabricksCluster(namePrefix, 0, useMATLAB=false, dockerAuthFile=options.dockerAuthFile, create=false, sparkConfig=scp);
        else
            error("dockerAuthFile must be provided when creating a new cluster.");
        end
    end

    timeExt = string(datetime("now", "Format", "uuuuMMdd_HHmmss_SSS"));

    statement = sprintf("disp(""Hello from MATLAB Batch Task""); disp(""%s""); exit(0)", timeExt);

    ws = databricks.Workspace();
    baseFolder = "/Workspace/Users/" + string(ws.username) + "/tmp";
    notebookPath = baseFolder + "/" + "MATLABBatchTaskExample_" + timeExt + ".py";

    % See sample argument values above
    % Customize the licenseManager value
    task = databricks.MATLABBatchTask(statement, notebookPath=notebookPath,licenseManager="27000@10.0.0.4");

    % Create the job and assign the task and cluster:
    job = databricks.Job;
    job.name = namePrefix + "_" + timeExt;
    job.setTask(task);
    % Assign the cluster to the job
    job.setCluster(cluster);
    job.create();

    % Run the job
    jobRun = job.runNow();

    fprintf('Created job "%s", see run <a href="%s">here</a>\n', job.name, jobRun.run_page_url)

    % Delete the temporary notebook
    % ws.delete(notebookPath);
end