function setTask(obj, taskObj)
    % SETTASK Method to attach a task to the configured job
    % Attaching a task to a job configures the job to execute the task when
    % run. This task can be a configured:
    %   databricks.SparkJarTask,
    %   databricks.SparkSubmitTask (Deprecated)
    %   databricks.NotebookTask
    %   databricks.SparkPythonTask
    %
    %   % Create a task and attach to a job
    %   task = databricks.NotebookTask;
    %   jb = databricks.Job;
    %   jb.setTask(task);
    %
    % SparkSubmitTask is deprecated and should no longer be used see:
    % https://docs.databricks.com/aws/en/jobs/spark-submit
    % Existing support will be removed in a future release


    %  (c) 2019-2025 MathWorks, Inc.

    arguments
        obj (1,1) databricks.Job
        taskObj (1,1)
    end

    % Remove any existing task properties on obj before setting
    rmpropif(obj, 'notebook_task')
    rmpropif(obj, 'spark_jar_task')
    rmpropif(obj, 'spark_python_task')
    rmpropif(obj, 'spark_submit_task')
    rmpropif(obj, 'tasks');

    % Add the properties needed for a specific task
%    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    %entries = taskObj.getTaskEntries(args{:});
    
    entries = taskObj.getTaskEntries();
    obj.addStructureAsDynProps(entries);
    
    if isa(taskObj, 'databricks.Tasks')
        obj.Version = '2.1';
    else
        obj.Version = '2.0';
    end
end %function
