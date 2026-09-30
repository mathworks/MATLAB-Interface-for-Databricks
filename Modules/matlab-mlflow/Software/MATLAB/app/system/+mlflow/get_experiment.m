function varargout = get_experiment(varargin)
    %GET_EXPERIMENT Retrieve an experiment by experiment_id from the backend store
    %
    %   out = mlflow.get_experiment(experiment_id)
    %
    % Returns: 
    %
    %    :py:class:`mlflow.entities.Experiment`
    %
    % Input arguments:
    %
    %    experiment_id
    %        The string-ified experiment ID returned from ``create_experiment``.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["experiment_id"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.get_experiment(varargin{1:i},pyargs(varargin{i+1:end}));
