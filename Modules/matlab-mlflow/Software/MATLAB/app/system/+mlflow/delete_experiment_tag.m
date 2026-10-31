function varargout = delete_experiment_tag(varargin)
    %DELETE_EXPERIMENT_TAG Delete a tag from the current experiment.
    %
    %
    % Input arguments:
    %
    %    key
    %        Name of the tag to be deleted.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["key"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.delete_experiment_tag(varargin{1:i},pyargs(varargin{i+1:end}));
