function varargout = doctor(varargin)
    %DOCTOR Prints out useful information for debugging issues with MLflow.
    %
    %
    % Input arguments:
    %
    %    mask_envs
    %        If True, mask the MLflow environment variable values
    %        (e.g. `"MLFLOW_ENV_VAR": "***"`) in the output to prevent leaking sensitive
    %        information.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["mask_envs"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.doctor(varargin{1:i},pyargs(varargin{i+1:end}));
