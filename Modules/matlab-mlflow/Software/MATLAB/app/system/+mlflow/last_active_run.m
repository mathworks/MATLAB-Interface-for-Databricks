function varargout = last_active_run(varargin)
    %LAST_ACTIVE_RUN Gets the most recent active run.
    %
    %   out = mlflow.last_active_run()
    %
    % Returns: 
    %
    %    The active run (this is equivalent to ``mlflow.active_run()``) if one exists.
    %    Otherwise, the last run started from the current Python process that reached
    %    a terminal status (i.e. FINISHED, FAILED, or KILLED).
    %
    % Input arguments:
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = [];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.last_active_run(varargin{1:i},pyargs(varargin{i+1:end}));
