function varargout = set_experiment(varargin)
    %SET_EXPERIMENT Set the given experiment as the active experiment. The experiment must either be specified by
    % name via `experiment_name` or by ID via `experiment_id`. The experiment name and ID cannot
    % both be specified.
    % .. note::
    %     If the experiment being set by name does not exist, a new experiment will be
    %     created with the given name. After the experiment has been created, it will be set
    %     as the active experiment. On certain platforms, such as Databricks, the experiment name
    %     must be an absolute path, e.g. ``"/Users/<username>/my-experiment"``.
    %
    %   out = mlflow.set_experiment(experiment_name,experiment_id)
    %
    % Returns: 
    %
    %    An instance of :py:class:`mlflow.entities.Experiment` representing the new active
    %    experiment.
    %
    % Input arguments:
    %
    %    experiment_name
    %        Case sensitive name of the experiment to be activated.
    %
    %    experiment_id
    %        ID of the experiment to be activated. If an experiment with this ID
    %        does not exist, an exception is thrown.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["experiment_name","experiment_id"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.set_experiment(varargin{1:i},pyargs(varargin{i+1:end}));
