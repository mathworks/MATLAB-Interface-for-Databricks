function varargout = create_workspace(varargin)
    %CREATE_WORKSPACE .. Note:: Experimental: This function may change or be removed in a future release without warning.
    % Create a new workspace.
    %     Args:
    %         name: The workspace name (lowercase alphanumeric with optional internal hyphens).
    %         description: Optional description of the workspace.
    %         default_artifact_root: Optional artifact root URI; falls back to server default.
    %     Returns:
    %         The newly created workspace.
    %     Raises:
    %         MlflowException: If the name is invalid, already exists, or no artifact root available.
    %
    %
    % Input arguments:
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["name","description","default_artifact_root"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.create_workspace(varargin{1:i},pyargs(varargin{i+1:end}));
