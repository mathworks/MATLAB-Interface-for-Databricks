function varargout = list_workspaces(varargin)
    %LIST_WORKSPACES .. Note:: Experimental: This function may change or be removed in a future release without warning.
    % Return the list of workspaces available to the current user.
    %
    %
    % Input arguments:
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = [];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.list_workspaces(varargin{1:i},pyargs(varargin{i+1:end}));
