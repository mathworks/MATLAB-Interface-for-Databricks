function [job, jobRun] = runMachineLearningNotebookJob(DI)
    % runMachineLearningNotebook Runs a machine learning notebook on Databricks
    % Script to automate the running of a notebook on Databricks, remotely
    % from MATLAB.

    % Copyright 2021-2026 The MathWorks, Inc.

    arguments(Input)
        DI struct = DemoInfo()
    end
    arguments(Output)
        job databricks.Job
        jobRun databricks.Run
    end

    nbPath = DI.PythonNotebookPath;
    whlFile = dir(fullfile(DI.BuildDir, 'dist', '*.whl'));
    volumesWhlName = DI.VolumesUploadFolder + "/" + string(whlFile.name);
    libraries = {struct("whl", volumesWhlName)};

    % Create a job object
    job = databricks.Job;
    job.name = "machine_learning_example_" + string(datetime('now', 'Format', 'uuuuMMdd''T''HHmmss'));

    % Create a notebook task
    notebookTask = databricks.NotebookTask();
    notebookTask.notebook_path = nbPath;

    % Create and configure the task object
    tasks = databricks.Tasks;
    newCluster = createDatabricksCluster( ...
        '', ... A new cluster for a job should not have a name
        0, ... This is a small test, so we use a single node cluster
        'create', false ... We don't create the cluster directly, the task does it for us
        );
    tasks.addTask(...
        notebookTask, "my_classifier_task", ...
        "description", "A classifier for the diabetes test data", ...
        "new_cluster", newCluster, ...
        "libraries", libraries);

    job.setTask(tasks)

    % Create and execute the job
    job.create
    jobRun = job.runNow();
end
