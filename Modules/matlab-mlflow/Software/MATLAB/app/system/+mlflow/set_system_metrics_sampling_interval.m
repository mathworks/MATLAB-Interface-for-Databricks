function varargout = set_system_metrics_sampling_interval(varargin)
    %SET_SYSTEM_METRICS_SAMPLING_INTERVAL Set the system metrics sampling interval.
    % Every `interval` seconds, the system metrics will be collected. By default `interval=10`.
    %
    %
    % Input arguments:
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["interval"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.set_system_metrics_sampling_interval(varargin{1:i},pyargs(varargin{i+1:end}));
