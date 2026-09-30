function addTask(obj, task, task_key, options)
    % addTask Add a task to a Jobs 2.1 API job
    %
    % Arguments
    %    task  A task object. Supported types are
    %          databricks.SparkSubmitTask, databricks.SparkJarTask
    %          databricks.NotebookTask, SparkPythonTask
    %    task_key A text string for identifying a task
    % Optional arguments (different tasks may need different
    % arguments)
    %    description A simple description of the task
    %    new_cluster A databricks.Cluster object (not created)
    %    timeout_seconds An integer number
    %    max_retries An integer number
    %    min_retry_interval_millis A number
    %    retry_on_timeout "true"/"false"
    %
    % A new_cluster for a task may not have autotermination set. If it's
    % set, it will be removed automatically.
    %
    % SparkSubmitTask is deprecated and should no longer be used see:
    % https://docs.databricks.com/aws/en/jobs/spark-submit
    % Existing support will be removed in a future release

    % Copyright 2021-2025 MathWorks, Inc.

    arguments
        obj databricks.Tasks
        task databricks.BaseTask
        task_key string
        options.description (1,1) string
        options.depends_on string
        options.new_cluster (1,1) databricks.Cluster
        options.existing_cluster_id (1,1) string
        options.job_cluster_key (1,1) string
        options.timeout_seconds (1,1) double {mustBeNumeric,mustBePositive, mustBeInteger}
        options.max_retries (1,1) double {mustBeNumeric, mustBePositive, mustBeInteger}
        options.min_retry_interval_millis  (1,1) double {mustBeNumeric, mustBePositive, mustBeInteger}
        options.retry_on_timeout (1,1) logical
        options.libraries cell
    end


    S = struct('task_key', task_key);
    if isfield(options, 'description')
        S.description = options.description;
    end

    if isfield(options, 'depends_on')
        S.depends_on = arrayfun(@(x) struct('task_key', x), ...
            options.depends_on, 'UniformOutput', false);
    end

    if isfield(options, 'new_cluster')
        S.new_cluster = removeAutoTermination(options.new_cluster);
    end
    if isfield(options, 'existing_cluster_id')
        S.existing_cluster_id = options.existing_cluster_id;
    end
    if isfield(options, 'job_cluster_key')
        S.job_cluster_key = options.job_cluster_key;
    end
    if isfield(options, 'timeout_seconds')
        S.timeout_seconds = options.timeout_seconds;
    end
    if isfield(options, 'max_retries')
        S.max_retries = options.max_retries;
    end
    if isfield(options, 'min_retry_interval_millis')
        S.min_retry_interval_millis = options.min_retry_interval_millis;
    end
    if isfield(options, 'retry_on_timeout')
        S.retry_on_timeout = options.retry_on_timeout;
    end
    if isfield(options, 'libraries')
        S.libraries = options.libraries;
    end

    % Now add the Task info
    if isa(task, "databricks.SparkSubmitTask")
        fprintf(2, "Tasks of type databricks.SparkSubmitTask have been deprecated.\n");
        fprintf(2, "See: %s\n", matlab.utils.URL2Link("https://docs.databricks.com/aws/en/jobs/spark-submit"));
        fprintf(2, "Existing support will be removed in release 7.0.0.\n");
    end

    entries = task.getTaskEntries;
    fn = fieldnames(entries);
    for k=1:length(fn)
        FN = fn{k};
        val = entries.(FN);
        if strcmp(FN, 'libraries') && isfield(S, 'libraries')
            for n=1:numel(val)
                S.libraries{end+1} = val(n);
            end
        else
            S.(FN) = val;
        end
    end

    obj.tasks{end+1} = S;

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