classdef SparkSubmitTask < databricks.BaseTask
    % SPARKSUBMITTASK Definition of a spark-submit task
    % This class can be used to define a spark-submit task that can be attached
    % to a databricks.Job for execution on a Spark Cluster.
    %
    % An object of this class is configured using its properties and attached
    % to a job using the setTask() method of the Job.
    % 
    %  Example:
    %   cl = databricks.Cluster;
    %   cl.setNumWorkers(4)
    %   job = databricks.Job;
    %   job.setCluster(cl)
    %   task = databricks.SparkSubmitTask;
    %   task.Application = "/dbfs/example/myDemo.jar"
    %   task.Arguments = {"/MATLAB_Runtime",...
    %                     "/dbfs/data/airlinesmall.csv",...
    %                     "/dbfs/output/"};
    %  job.setTask(job);
    %
    % SparkSubmitTask is deprecated and should no longer be used see:
    % https://docs.databricks.com/aws/en/jobs/spark-submit
% Existing support will be removed in a future release

    %  Copyright 2019-2025 MathWorks, Inc.

    properties(Dependent)
        DriverLibraryPath;
        Jars;
    end

    properties
        SparkSubmitClass = "com.mathworks.mlspark.mlsubmit.MatlabSubmit";
        MCRROOT = "/MATLAB_Runtime"
        Application = "";
        Arguments = [];
    end

    methods
    	%% Constructor
    	function obj = SparkSubmitTask(varargin)
        end

        %% Getter/Setters
        function paths = get.DriverLibraryPath(obj) 

            endPaths = [...
                "runtime/glnxa64",...
                "bin/glnxa64",...
                "sys/os/glnxa64",...
                "extern/bin/glnxa64", ...
                "sys/opengl/lib/glnxa64" ...
                ]';
        
            paths = obj.MCRROOT + "/" + endPaths;

            % Destination is Linux based so always use :
            paths = join(paths, ":");
        end

        function str = get.Jars(obj)
            
            str = strcat(...
                obj.MCRROOT, "/toolbox/mlhadoop/jar/a2.2.0/mwmapreduce.jar,",...
                obj.MCRROOT, "/toolbox/shared/bigdata/jar/hadoop.2.jar,", ...
                obj.MCRROOT, "/toolbox/javabuilder/jar/javabuilder.jar,", ...
                obj.MCRROOT, "/toolbox/compiler/mlspark/jars/3.x/mlspark.jar");

            % G2369422
            % obj.MCRROOT,"/toolbox/compiler/mlspark/jars/3.x/mlspark.jar,",...
        end

        function strArray = getParameters(obj)
            strArray = [...
                "--class", obj.SparkSubmitClass,...
                "--driver-library-path", obj.DriverLibraryPath,...
                "--jars", obj.Jars ...
                ];
        end

        function entries = getTaskEntries(obj)
            parameters = [obj.getParameters, obj.Application, obj.Arguments];
            entries.spark_submit_task = struct("parameters", parameters);
        end
    end
end %class
