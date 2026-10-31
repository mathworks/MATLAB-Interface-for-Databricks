classdef NotebookTask < databricks.BaseTask
    % NOTEBOOKTASK Definition of a notebook task
    % This class can be used to define a notebook task that can be attached
    % to a databricks.Job for execution on a Spark Cluster.
    %
    %     NT = databricks.NotebookTask();
    %     nbPath = '/Shared/UnitTests/Simulink_3DOFs';
    %     baseParams = struct('massLow', '1200', 'massHigh', '1400');
    %     NT.notebook_path = nbPath;
    %     NT.base_parameters = baseParams;
    %
    % The notebook parameter can also be given to the constructor.
    %     NT = databricks.NotebookTask(nbPath);
    %     baseParams = struct('massLow', '1200', 'massHigh', '1400');
    % 
    % As can both parameters
    %     NT = databricks.NotebookTask(nbPath, baseParams);

    % Copyright 2020-2022, The MathWorks, Inc.
    
    properties
        % The absolute path of the notebook to be run in the Databricks workspace
        % This path must begin with a slash, this field is required
        notebook_path = string.empty;
        base_parameters = string.empty;
    end
    
    methods
        function obj = NotebookTask(notebookPath, baseParams)
            if nargin > 0
                obj.notebook_path = notebookPath;
                if nargin > 1
                    obj.base_parameters = baseParams;
                end
            end

        end
       
        function entries = getTaskEntries(obj)
            taskReq.notebook_path = obj.notebook_path;
            if ~isempty(obj.base_parameters)
                taskReq.base_parameters = obj.base_parameters;
            end
            entries.notebook_task = taskReq;
        end
    end
end
