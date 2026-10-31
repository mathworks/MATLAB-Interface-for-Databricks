function varargout = flush_artifact_async_logging(varargin)
    %FLUSH_ARTIFACT_ASYNC_LOGGING Flush all pending artifact async logging.
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
    [varargout{1:nargout}] = py.mlflow.flush_artifact_async_logging(varargin{1:i},pyargs(varargin{i+1:end}));
