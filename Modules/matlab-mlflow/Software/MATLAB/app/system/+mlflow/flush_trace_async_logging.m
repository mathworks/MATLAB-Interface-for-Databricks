function varargout = flush_trace_async_logging(varargin)
    %FLUSH_TRACE_ASYNC_LOGGING Flush all pending trace async logging.
    %
    %
    % Input arguments:
    %
    %    terminate
    %        If True, shut down the logging threads after flushing.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["terminate"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.flush_trace_async_logging(varargin{1:i},pyargs(varargin{i+1:end}));
