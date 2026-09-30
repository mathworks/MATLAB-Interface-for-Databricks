function varargout = get_active_trace_id(varargin)
    %GET_ACTIVE_TRACE_ID Get the active trace ID in the current process.
    % This function is thread-safe.
    %
    %   out = mlflow.get_active_trace_id()
    %
    % Returns: 
    %
    %    The ID of the current active trace if exists, otherwise None.
    %
    % Input arguments:
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = [];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.get_active_trace_id(varargin{1:i},pyargs(varargin{i+1:end}));
