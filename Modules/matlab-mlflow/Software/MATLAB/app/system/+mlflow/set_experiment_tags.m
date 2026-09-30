function varargout = set_experiment_tags(varargin)
    %SET_EXPERIMENT_TAGS Set tags for the current active experiment.
    %
    %
    % Input arguments:
    %
    %    tags
    %        Dictionary containing tag names and corresponding values.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["tags"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.set_experiment_tags(varargin{1:i},pyargs(varargin{i+1:end}));
