function varargout = start_run(varargin)
    %START_RUN Start a new MLflow run, setting it as the active run under which metrics and parameters
    % will be logged. The return value can be used as a context manager within a ``with`` block;
    % otherwise, you must call ``end_run()`` to terminate the current run.
    % If you pass a ``run_id`` or the ``MLFLOW_RUN_ID`` environment variable is set,
    % ``start_run`` attempts to resume a run with the specified run ID and
    % other parameters are ignored. ``run_id`` takes precedence over ``MLFLOW_RUN_ID``.
    % If resuming an existing run, the run status is set to ``RunStatus.RUNNING``.
    % MLflow sets a variety of default tags on the run, as defined in
    % `MLflow system tags <../../tracking/tracking-api.html#system_tags>`_.
    %
    %   out = mlflow.start_run(run_id,experiment_id,run_name,nested,parent_run_id,tags,description,log_system_metrics)
    %
    % Returns: 
    %
    %    :py:class:`mlflow.ActiveRun` object that acts as a context manager wrapping the
    %    run's state.
    %
    % Input arguments:
    %
    %    run_id
    %        If specified, get the run with the specified UUID and log parameters
    %        and metrics under that run. The run's end time is unset and its status
    %        is set to running, but the run's other attributes (``source_version``,
    %        ``source_type``, etc.) are not changed.
    %
    %    experiment_id
    %        ID of the experiment under which to create the current run (applicable
    %        only when ``run_id`` is not specified). If ``experiment_id`` argument
    %        is unspecified, will look for valid experiment in the following order:
    %        activated using ``set_experiment``, ``MLFLOW_EXPERIMENT_NAME``
    %        environment variable, ``MLFLOW_EXPERIMENT_ID`` environment variable,
    %        or the default experiment as defined by the tracking server.
    %
    %    run_name
    %        Name of new run, should be a non-empty string. Used only when ``run_id`` is
    %        unspecified. If a new run is created and ``run_name`` is not specified,
    %        a random name will be generated for the run.
    %
    %    nested
    %        Controls whether run is nested in parent run. ``True`` creates a nested run.
    %
    %    parent_run_id
    %        If specified, the current run will be nested under the the run with
    %        the specified UUID. The parent run must be in the ACTIVE state.
    %
    %    tags
    %        An optional dictionary of string keys and values to set as tags on the run.
    %        If a run is being resumed, these tags are set on the resumed run. If a new run is
    %        being created, these tags are set on the new run.
    %
    %    description
    %        An optional string that populates the description box of the run.
    %        If a run is being resumed, the description is set on the resumed run.
    %        If a new run is being created, the description is set on the new run.
    %
    %    log_system_metrics
    %        bool, defaults to None. If True, system metrics will be logged
    %        to MLflow, e.g., cpu/gpu utilization. If None, we will check environment variable
    %        `MLFLOW_ENABLE_SYSTEM_METRICS_LOGGING` to determine whether to log system metrics.
    %        System metrics logging is an experimental feature in MLflow 2.8 and subject to change.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["run_id","experiment_id","run_name","nested","parent_run_id","tags","description","log_system_metrics"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.start_run(varargin{1:i},pyargs(varargin{i+1:end}));
