function varargout = set_system_metrics_samples_before_logging(varargin)
    %SET_SYSTEM_METRICS_SAMPLES_BEFORE_LOGGING Set the number of samples before logging system metrics.
    % Every time `samples` samples have been collected, the system metrics will be logged to mlflow.
    % By default `samples=1`.
    %
    %
    % Input arguments:
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["samples"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.set_system_metrics_samples_before_logging(varargin{1:i},pyargs(varargin{i+1:end}));
