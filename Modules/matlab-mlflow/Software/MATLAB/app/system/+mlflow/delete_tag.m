function varargout = delete_tag(varargin)
    %DELETE_TAG Delete a tag from a run. This is irreversible. If no run is active, this method
    % will create a new active run.
    %
    %
    % Input arguments:
    %
    %    key
    %        Name of the tag
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["key"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.delete_tag(varargin{1:i},pyargs(varargin{i+1:end}));
