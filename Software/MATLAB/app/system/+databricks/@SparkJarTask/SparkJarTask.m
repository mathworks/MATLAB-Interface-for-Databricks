classdef SparkJarTask < databricks.BaseTask
    % SPARKJARTASK Definition of a spark JAR task
    %   
    % This class can be used to define a spark-jar task that can be attached
    % to a databricks.Job for execution on a Spark Cluster.
    %
    %   job = databricks.Job;
    %   job.setCluster("1101-121324-qweuiozn")
    %   task = databricks.SparkJarTask;
    %   task.Application = "/dfbs/example/runSLModel.jar";
    %   task.Arguments = [...
    %       inputLocation,...
    %       outputLocation];
    %   task.main_class_name = 'com.mathworks.example.3DOFExample';
    %   task = databricks.SparkSubmitTask;
    %   task.Application = "/dbfs/example/meanArrivalDemo.jar"
    %   task.Arguments = {"/MATLAB_Runtime",...
    %                     "/dbfs/data/airlinesmall.csv",...
    %                     "/dbfs/output/"};
    %   job.setTask(job);

    %  Copyright 2019-2023 MathWorks, Inc.

    properties(Dependent)
        parameters;
    end

    properties
        %jar_uri; DEPRECATED
        main_class_name = string.empty;
        Arguments = string.empty;
        Application = string.empty;
        jar_params = string.empty;
    end

    methods
    	% Constructor
    	function obj = SparkJarTask(~, varargin)

        end

        function strArray = get.parameters(obj)
            strArray = obj.Arguments;
        end

        function entries = getTaskEntries(obj, options)
            arguments
                obj (1,1) databricks.SparkJarTask
                options.authMethod (1,1) matlab.databricks.AuthMethod
                options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
            end

            % Create the library entry
            args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
            appLib = databricks.Library(args{:});
            appLib.setType('jar');
            appLib.jar = obj.Application;
            entries.libraries = appLib;

            % Add additional libraries
            extraLibs = matlab.databricks.getDefaultRuntimeJars();
            entries.libraries = [entries.libraries, extraLibs];

            % Create the spark jar entry
            entries.spark_jar_task = struct(...
                "main_class_name", obj.main_class_name, ...
                "parameters", obj.parameters ...
                );

            % Create the jar_params entry %TODO: Check JSON encoding does not exceed 10,000 bytes
            entries.jar_params = obj.jar_params;
        end
    end

end %class