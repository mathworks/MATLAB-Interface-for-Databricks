classdef SparkPythonTask < databricks.BaseTask
    % SPARKPYTHONTASK Definition of a spark JAR task
    %
    % This class can be used to define a Spark Python task that can be attached
    % to a databricks.Job for execution on a Spark Cluster.
    %
    % spt = databricks.SparkPythonTask('python_file', 'dbfs:/example/databricks/pi.py', 'parameters', "4");
    %
    % job = databricks.Job();
    % job.name = sprintf('pi-calc-%s', datestr(now, 30));
    % job.setCluster(cluster);
    % job.setTask(spt);
    %
    % job.create();
    % jobRun = job.runNow();

    %  Copyright 2022 MathWorks, Inc.

    properties
        python_file (1,1) string
        parameters        string
    end

    methods
        % Constructor
        function obj = SparkPythonTask(opts)
            arguments
                opts.python_file (1,1) string
                opts.parameters        string
            end
            if isfield(opts, 'python_file')
                obj.python_file = opts.python_file;
            end
            if isfield(opts, 'parameters')
                obj.parameters = opts.parameters;
            end
        end

        function entries = getTaskEntries(obj)
            % Create the spark python entry
            entries.spark_python_task = struct(...
                "python_file", obj.python_file, ...
                "parameters", obj.parameters ...
                );

        end
    end

end 
