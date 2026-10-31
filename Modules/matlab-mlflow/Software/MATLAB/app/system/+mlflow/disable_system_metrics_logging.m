function varargout = disable_system_metrics_logging(varargin)
    %DISABLE_SYSTEM_METRICS_LOGGING Disable system metrics logging globally.
    % Calling this function will disable system metrics logging globally, but users can still opt in
    % system metrics logging for individual runs by `mlflow.start_run(log_system_metrics=True)`.
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
    [varargout{1:nargout}] = py.mlflow.disable_system_metrics_logging(varargin{1:i},pyargs(varargin{i+1:end}));
