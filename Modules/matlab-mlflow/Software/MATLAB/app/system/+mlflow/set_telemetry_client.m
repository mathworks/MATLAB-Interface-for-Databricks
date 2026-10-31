function varargout = set_telemetry_client(varargin)
    %SET_TELEMETRY_CLIENT This function is part of the fluent MLflow tracking interface
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = [];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.set_telemetry_client(varargin{1:i},pyargs(varargin{i+1:end}));
