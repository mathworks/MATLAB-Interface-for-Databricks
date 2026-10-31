function varargout = update_workspace(varargin)
    %UPDATE_WORKSPACE .. Note:: Experimental: This function may change or be removed in a future release without warning.
    % Update metadata for an existing workspace.
    %     Args:
    %         name: The name of the workspace to update.
    %         description: New description, or ``None`` to leave unchanged.
    %         default_artifact_root: New artifact root URI, empty string to clear, or ``None``.
    %     Returns:
    %         The updated workspace.
    %     Raises:
    %         MlflowException: If the workspace does not exist or no artifact root available.
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
    [varargout{1:nargout}] = py.mlflow.update_workspace(varargin{1:i},pyargs(varargin{i+1:end}));
