function varargout = log_params(varargin)
    %LOG_PARAMS Log a batch of params for the current run. If no run is active, this method will create a
    % new active run.
    %
    %   out = mlflow.log_params(params,synchronous,run_id)
    %
    % Returns: 
    %
    %    When `synchronous=True`, returns None. When `synchronous=False`, returns an
    %    :py:class:`mlflow.utils.async_logging.run_operations.RunOperations` instance that
    %    represents future for logging operation.
    %
    % Input arguments:
    %
    %    params
    %        Dictionary of param_name: String -> value: (String, but will be string-ified if
    %        not)
    %
    %    synchronous
    %        *Experimental* If True, blocks until the parameters are logged
    %        successfully. If False, logs the parameters asynchronously and
    %        returns a future representing the logging operation. If None, read from environment
    %        variable `MLFLOW_ENABLE_ASYNC_LOGGING`, which defaults to False if not set.
    %
    %    run_id
    %        Run ID. If specified, log params to the specified run. If not specified, log
    %        params to the currently active run.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["params","synchronous","run_id"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.log_params(varargin{1:i},pyargs(varargin{i+1:end}));
