function varargout = delete_workspace(varargin)
    %DELETE_WORKSPACE .. Note:: Experimental: This function may change or be removed in a future release without warning.
    % Delete an existing workspace.
    %     Args:
    %         name: Name of the workspace to delete.
    %         mode: Deletion mode. One of SET_DEFAULT, CASCADE, or RESTRICT.
    %
    %
    % Input arguments:
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["name"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.delete_workspace(varargin{1:i},pyargs(varargin{i+1:end}));
