function varargout = set_workspace(varargin)
    %SET_WORKSPACE .. Note:: Experimental: This function may change or be removed in a future release without warning.
    % Set the active workspace for subsequent MLflow operations.
    %
    %
    % Input arguments:
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["workspace"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.set_workspace(varargin{1:i},pyargs(varargin{i+1:end}));
