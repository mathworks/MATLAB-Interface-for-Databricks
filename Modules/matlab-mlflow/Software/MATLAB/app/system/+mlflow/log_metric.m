function varargout = log_metric(varargin)
    %LOG_METRIC Log a metric under the current run. If no run is active, this method will create
    % a new active run.
    %
    %   out = mlflow.log_metric(key,value,step,synchronous,timestamp,run_id,model_id,dataset)
    %
    % Returns: 
    %
    %    When `synchronous=True`, returns None.
    %    When `synchronous=False`, returns `RunOperations` that represents future for
    %    logging operation.
    %
    % Input arguments:
    %
    %    key
    %        Metric name. This string may only contain alphanumerics, underscores (_),
    %        dashes (-), periods (.), spaces ( ), and slashes (/).
    %        All backend stores will support keys up to length 250, but some may
    %        support larger keys.
    %
    %    value
    %        Metric value. Note that some special values such as +/- Infinity may be
    %        replaced by other values depending on the store. For example, the
    %        SQLAlchemy store replaces +/- Infinity with max / min float values.
    %        All backend stores will support values up to length 5000, but some
    %        may support larger values.
    %
    %    step
    %        Metric step. Defaults to zero if unspecified.
    %
    %    synchronous
    %        *Experimental* If True, blocks until the metric is logged
    %        successfully. If False, logs the metric asynchronously and
    %        returns a future representing the logging operation. If None, read from environment
    %        variable `MLFLOW_ENABLE_ASYNC_LOGGING`, which defaults to False if not set.
    %
    %    timestamp
    %        Time when this metric was calculated. Defaults to the current system time.
    %
    %    run_id
    %        If specified, log the metric to the specified run. If not specified, log the metric
    %        to the currently active run.
    %
    %    model_id
    %        The ID of the model associated with the metric. If not specified, use the current
    %        active model ID set by :py:func:`mlflow.set_active_model`. If no active model exists,
    %        the models IDs associated with the specified or active run will be used.
    %
    %    dataset
    %        The dataset associated with the metric.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["key","value","step","synchronous","timestamp","run_id","model_id","dataset"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.log_metric(varargin{1:i},pyargs(varargin{i+1:end}));
