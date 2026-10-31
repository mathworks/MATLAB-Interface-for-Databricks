classdef Tasks < databricks.BaseTask
    % Tasks an entry for orchestration jobs
    %
    % The new 2.1 REST API from Databricks supports jobs with several
    % tasks, with dependencies between them. This class captures this
    % functionality.
    %
    % To use this form, first create the concrete tasks to be part of the
    % job. See doc for the different task types for more information on how
    % to configure these.
    %   T1 = databricks.SparkJarTask()
    %   T2 = databricks.NotebookTask()
    %
    % Now create the Tasks object
    %   tasks = databricks.Tasks()
    %
    % Add the different tasks, adding information about where to run (e.g.
    % if on a new cluster or an existing one), if the tasks depend on each
    % other, etc. The clusters mentioned here were created with the
    % databricks.Custer class, see corresponding documentation.
    %
    %  tasks.addTask(T1, "task_key_1", ...
    %     "description", "My SparkJar task", ...
    %     "new_cluster", cl1);
    %  tasks.addTask(T2, "task_key_2", ...
    %     "description", "My Notebook task", ...
    %     "depends_on", ["task_key_1"], ...
    %     "existing_cluster_id", "1101-140344-qwerquor");
    %
    % Finally, set the 'tasks' as the task for the job
    %  job.setTask(tasks)
    %
    % No error checking is done to verify if correct settings are used, as
    % the Databricks API will respond to this. 

    % Copyright 2021-2025 MathWorks, Inc.

    properties
        tasks = {};
    end

    methods
        function obj = Tasks()

        end

        function entries = getTaskEntries(obj)
            entries.tasks = obj.tasks;
            if isprop(obj, 'job_clusters')
                entries.job_clusters = obj.job_clusters;
            end
        end
    end

end
