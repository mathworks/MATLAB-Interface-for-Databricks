function varargout = set_tag(varargin)
    %SET_TAG Set a tag under the current run. If no run is active, this method will create a new active
    % run.
    %
    %   out = mlflow.set_tag(key,value,synchronous)
    %
    % Returns: 
    %
    %    When `synchronous=True`, returns None. When `synchronous=False`, returns an
    %    :py:class:`mlflow.utils.async_logging.run_operations.RunOperations` instance that
    %    represents future for logging operation.
    %
    % Input arguments:
    %
    %    key
    %        Tag name. This string may only contain alphanumerics, underscores (_), dashes (-),
    %        periods (.), spaces ( ), and slashes (/). All backend stores will support keys up to
    %        length 250, but some may support larger keys.
    %
    %    value
    %        Tag value, but will be string-ified if not. All backend stores will support values
    %        up to length 5000, but some may support larger values.
    %
    %    synchronous
    %        *Experimental* If True, blocks until the tag is logged successfully. If False,
    %        logs the tag asynchronously and returns a future representing the logging operation.
    %        If None, read from environment variable `MLFLOW_ENABLE_ASYNC_LOGGING`, which
    %        defaults to False if not set.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["key","value","synchronous"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.set_tag(varargin{1:i},pyargs(varargin{i+1:end}));
