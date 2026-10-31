function varargout = end_run(varargin)
    %END_RUN End an active MLflow run (if there is one).
    % .. code-block:: python
    %     :test:
    %     :caption: Example
    %     import mlflow
    %     # Start run and get status
    %     mlflow.start_run()
    %     run = mlflow.active_run()
    %     print(f"run_id: {run.info.run_id}; status: {run.info.status}")
    %     # End run and get status
    %     mlflow.end_run()
    %     run = mlflow.get_run(run.info.run_id)
    %     print(f"run_id: {run.info.run_id}; status: {run.info.status}")
    %     print("--")
    %     # Check for any active runs
    %     print(f"Active run: {mlflow.active_run()}")
    % .. code-block:: text
    %     :caption: Output
    %     run_id: b47ee4563368419880b44ad8535f6371; status: RUNNING
    %     run_id: b47ee4563368419880b44ad8535f6371; status: FINISHED
    %     --
    %     Active run: None
    %
    %
    % Input arguments:
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["status"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.end_run(varargin{1:i},pyargs(varargin{i+1:end}));
