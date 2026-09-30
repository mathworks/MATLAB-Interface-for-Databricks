function runTasksTask(options)
    % runTasksTask Simple example for running a tasks task
    %
    % A tasks task, is a task with several subtasks, which can depend on
    % each other.
    %
    % Call this function with options to run with a different number of
    % clusters and a different number of tasks
    %
    %   runTasksTask(numClusters=5, numTasks=16)

    % Copyright 2024-2026 The MathWorks, Inc.

    arguments
        options.numClusters (1,1) double = 2
        options.numTasks (1,1) double = 9
    end

    addpath(databricksRoot("examples", "Tasks", "NotebookTask"));
    addpath(databricksRoot("examples", "Tasks", "SparkPythonTask"));

    % We create a number of notebook tasks
    doUpload = true; % Do uploads on the first pass
    allTasks = {};
    for k = 1:2:options.numTasks
        allTasks{k} = createNotebookTask(N=k, doUpload=doUpload);
        allTasks{k+1} = createSparkPythonTask(N=k+1, doUpload=doUpload);
        doUpload = false;
    end

    % A Tasks task is needed to contain the actual tasks
    tasks = databricks.Tasks();

    % They will be running in parallel on numCluster clusters, but if there
    % are fewer tasks, only that many clusters.
    numClusters = min(options.numClusters, options.numTasks);
    job_cluster_keys(numClusters) = "";

    % Define a number of clusters and add them to the Tasks object
    for k=1:numClusters
        job_cluster_keys(k) = "Tasks_task_example_" + k;
        new_cluster = createDatabricksCluster('', 0, ...
            create=false, ...          % Don't create the cluster(s) This happens when the job runs
            useMATLAB=false, ...       % MATLAB runtime is not enabled
            autoterminationMinutes=0); % No autotermination for job clusters
        tasks.addJobCluster(job_cluster_keys(k), new_cluster);
    end

    % Now add the different tasks to the Tasks object. Well add some
    % dependencies among them.
    numTasks = numel(allTasks);
    task_keys = "task_key_nb_" + (1:numTasks);
    for k=1:numTasks
        curTask = allTasks{k};
        if k > numClusters
            extraArgs = {"depends_on", task_keys(k-numClusters)};
        else
            extraArgs = {};
        end
        tasks.addTask(...
            curTask, task_keys(k), ...
            "timeout_seconds", 900, ...
            "job_cluster_key", job_cluster_keys(1+rem(k-1,numClusters)), ...
            extraArgs{:});
    end

    job = databricks.Job();
    job.name = "Tasksexample_" + string(datetime('now', 'Format', 'uuuuMMdd_HHmmss'));
    job.setTask(tasks);

    % Create the job
    job.create()
    jobRun = job.runNow();

    fprintf('Created job "%s", see run <a href="%s">here</a>\n', job.name, jobRun.run_page_url)
end