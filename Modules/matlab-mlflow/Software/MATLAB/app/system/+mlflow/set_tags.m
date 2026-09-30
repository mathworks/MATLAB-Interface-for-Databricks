function varargout = set_tags(varargin)
    %SET_TAGS Log a batch of tags for the current run. If no run is active, this method will create a
    % new active run.
    %
    %   out = mlflow.set_tags(tags,synchronous)
    %
    % Returns: 
    %
    %    When `synchronous=True`, returns None. When `synchronous=False`, returns an
    %    :py:class:`mlflow.utils.async_logging.run_operations.RunOperations` instance that
    %    represents future for logging operation.
    %
    % Input arguments:
    %
    %    tags
    %        Dictionary of tag_name: String -> value: (String, but will be string-ified if
    %        not)
    %
    %    synchronous
    %        *Experimental* If True, blocks until tags are logged successfully. If False,
    %        logs tags asynchronously and returns a future representing the logging operation.
    %        If None, read from environment variable `MLFLOW_ENABLE_ASYNC_LOGGING`, which
    %        defaults to False if not set.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["tags","synchronous"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.set_tags(varargin{1:i},pyargs(varargin{i+1:end}));
