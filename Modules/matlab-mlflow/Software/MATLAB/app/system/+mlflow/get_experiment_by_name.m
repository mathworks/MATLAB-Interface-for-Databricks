function varargout = get_experiment_by_name(varargin)
    %GET_EXPERIMENT_BY_NAME Retrieve an experiment by experiment name from the backend store
    %
    %   out = mlflow.get_experiment_by_name(name)
    %
    % Returns: 
    %
    %    An instance of :py:class:`mlflow.entities.Experiment`
    %    if an experiment with the specified name exists, otherwise None.
    %
    % Input arguments:
    %
    %    name
    %        The case sensitive experiment name.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["name"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.get_experiment_by_name(varargin{1:i},pyargs(varargin{i+1:end}));
