function varargout = enable_system_metrics_logging(varargin)
    %ENABLE_SYSTEM_METRICS_LOGGING Enable system metrics logging globally.
    % Calling this function will enable system metrics logging globally, but users can still opt out
    % system metrics logging for individual runs by `mlflow.start_run(log_system_metrics=False)`.
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
    [varargout{1:nargout}] = py.mlflow.enable_system_metrics_logging(varargin{1:i},pyargs(varargin{i+1:end}));
