function varargout = active_run(varargin)
    %ACTIVE_RUN Get the currently active ``Run``, or None if no such run exists.
    % .. attention::
    %     This API is **thread-local** and returns only the active run in the current thread.
    %     If your application is multi-threaded and a run is started in a different thread,
    %     this API will not retrieve that run.
    % **Note**: You cannot access currently-active run attributes
    % (parameters, metrics, etc.) through the run returned by ``mlflow.active_run``. In order
    % to access such attributes, use the :py:class:`mlflow.client.MlflowClient` as follows:
    % .. code-block:: python
    %     :test:
    %     :caption: Example
    %     import mlflow
    %     mlflow.start_run()
    %     run = mlflow.active_run()
    %     print(f"Active run_id: {run.info.run_id}")
    %     mlflow.end_run()
    % .. code-block:: text
    %     :caption: Output
    %     Active run_id: 6f252757005748708cd3aad75d1ff462
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
    [varargout{1:nargout}] = py.mlflow.active_run(varargin{1:i},pyargs(varargin{i+1:end}));
