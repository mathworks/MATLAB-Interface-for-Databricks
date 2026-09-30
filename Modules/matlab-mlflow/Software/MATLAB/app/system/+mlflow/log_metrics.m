function varargout = log_metrics(varargin)
    %LOG_METRICS Log multiple metrics for the current run. If no run is active, this method will create a new
    % active run.
    %
    %   out = mlflow.log_metrics(metrics,step,synchronous,run_id,timestamp,model_id,dataset)
    %
    % Returns: 
    %
    %    When `synchronous=True`, returns None. When `synchronous=False`, returns an
    %    :py:class:`mlflow.utils.async_logging.run_operations.RunOperations` instance that
    %    represents future for logging operation.
    %
    % Input arguments:
    %
    %    metrics
    %        Dictionary of metric_name: String -> value: Float. Note that some special
    %        values such as +/- Infinity may be replaced by other values depending on
    %        the store. For example, sql based store may replace +/- Infinity with
    %        max / min float values.
    %
    %    step
    %        A single integer step at which to log the specified
    %        Metrics. If unspecified, each metric is logged at step zero.
    %
    %    synchronous
    %        *Experimental* If True, blocks until the metrics are logged
    %        successfully. If False, logs the metrics asynchronously and
    %        returns a future representing the logging operation. If None, read from environment
    %        variable `MLFLOW_ENABLE_ASYNC_LOGGING`, which defaults to False if not set.
    %
    %    run_id
    %        Run ID. If specified, log metrics to the specified run. If not specified, log
    %        metrics to the currently active run.
    %
    %    timestamp
    %        Time when these metrics were calculated. Defaults to the current system time.
    %
    %    model_id
    %        The ID of the model associated with the metric. If not specified, use the current
    %        active model ID set by :py:func:`mlflow.set_active_model`. If no active model
    %        exists, the models IDs associated with the specified or active run will be used.
    %
    %    dataset
    %        The dataset associated with the metrics.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["metrics","step","synchronous","run_id","timestamp","model_id","dataset"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.log_metrics(varargin{1:i},pyargs(varargin{i+1:end}));
