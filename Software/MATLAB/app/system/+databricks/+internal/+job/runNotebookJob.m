function [runId, jobId] = runNotebookJob(notebook, options)
    % RUNNOTEBOOKJOB Creates and runs a Job to run a Notebook
    % If a cluster ID is given that cluster will be used, if not
    % if a cluster ID is set via credentials it will be used, otherwise
    % a cluster will be created.
    % Permission to create a new cluster is required if an existing cluster
    % is not used.
    %
    %
    % Required named argument:
    %      notebook : Full path and name of the notebook to run, including the
    %                 username where appropriate.
    %
    % Optional named arguments:
    %     clusterId : ID of an existing cluster, if not provided a value will be
    %                 taken from the credentials file if available and otherwise
    %                 a cluster will be created.
    %
    %          name : Name for notebook job.
    %
    %   autoterminationMinutes : Number of minutes after which a created
    %                            cluster will auto terminate, default is 60
    %
    %    numWorkers : Number of worker nodes to create, default 0, i.e.
    %                 single node cluster
    %
    %    authMethod : A matlab.databricks.AuthMethod
    %
    %   profileName : A configuration file profileName value
    %
    % The job's Job ID and Run ID are returned as int64s.
    % The run's status can be queried as follows:
    %      r = databricks.Run;
    %      result = r.get(runId);
    %      result.state
    %      ans =
    %        struct with fields:
    %          life_cycle_state: 'TERMINATED'
    %              result_state: 'SUCCESS'
    %             state_message: ''
   
    %  (c) 2023-2024 MathWorks, Inc.

    arguments
        notebook string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.name string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.clusterId string
        options.numWorkers {mustBeNonnegative, mustBeReal, mustBeFinite, mustBeNonNan} = 0
        options.autoterminationMinutes int32 {mustBeFinite, mustBeReal, mustBeNonnegative, mustBeNonNan} = 60
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.autoCreateCluster (1,1) logical = true
    end

    if verLessThan('matlab','9.9') %#ok<VERLESSMATLAB> % 9.9 is R2020b
        error('MATLAB release 2020b or later is required');
    end
    
    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    ws = databricks.Workspace(args{:});
    wsList = ws.list(notebook);
    if isempty(wsList)
        error('DATABRICKS:runNotebookJob', 'Notebook not found: %s', notebook);
    end

    if isfield(options, 'name')
        jobName = options.name;
    else
        jobName = "Running: " + notebook;
    end

    if isfield(options, "clusterId")
        clusterId = options.clusterId;
    else
        clusterId = databricks.internal.configurationprofile.ConfigFile.getProfileField("cluster_id", profileName=options.profileName);
    end

    if isempty(clusterId) || strlength(clusterId) == 0
        fprintf('ClusterId not set as an argument or in the configuration file\n');
        noExistingCluster = true;
    else
        cluster = databricks.Cluster.findById(clusterId, args{:});
        if isempty(cluster)
            fprintf('Specified cluster not found: %s\n', clusterId);
            noExistingCluster = true;
        else
            noExistingCluster = false;
        end
    end

    if ~noExistingCluster
        checkJobsAndNoteBookSupport(cluster); % will error if not supported
        job = buildJob(options.clusterId, notebook, "name", jobName, args{:});
    else
        if ~options.autoCreateCluster
            error('DATABRICKS:runNotebookJob', 'No cluster found and automatic cluster creation is disabled using the autoCreateCluster option');
        else
            fprintf('No cluster available, creating cluster\n');
            cluster = databricks.Cluster(args{:});
            cluster.cluster_name = "Running: " + notebook;
            if options.numWorkers == 0
                cluster.setSingleNode();
            else
                cluster.setNumWorkers(options.numWorkers);
            end
            % If the job takes an hour (default) something has gone wrong, kill it
            cluster.setAutoterminationMinutes(options.autoterminationMinutes);
            job = buildJob(cluster, notebook, "name", jobName, args{:});
        end
    end
    job.create();
    runResult = job.runNow();
    runId = int64(runResult.run_id);
    jobId = int64(job.job_id);
end


function tf = checkJobsAndNoteBookSupport(cluster)
    arguments
        cluster (1,1) databricks.Cluster
    end

    % Cluster exists so we can check if it supports Jobs
    if ~databricks.internal.cluster.isJobsSupported(cluster)
        error('DATABRICKS:runNotebookJob', 'Cluster: %s does not support executing jobs', clusterId);
    end
    if ~databricks.internal.cluster.isNotebooksSupported(cluster)
        error('DATABRICKS:runNotebookJob', 'Cluster: %s does not support executing notebooks', clusterId);
    end
    tf = true;
end


function job = buildJob(clusterOrId, notebookPath, options)
    arguments
        clusterOrId
        notebookPath string {mustBeNonzeroLengthText, mustBeTextScalar}
        options.name string {mustBeNonzeroLengthText, mustBeTextScalar} = "runNotebookJob job";
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    job = databricks.Job(args{:});
    job.name = options.name;
    job.setCluster(clusterOrId);

    % Configure the task
    task = databricks.NotebookTask;
    task.notebook_path = notebookPath;
    % Associate the task with the job
    job.setTask(task);
end