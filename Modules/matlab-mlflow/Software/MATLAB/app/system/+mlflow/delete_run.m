function varargout = delete_run(varargin)
    %DELETE_RUN Deletes a run with the given ID.
    %
    %
    % Input arguments:
    %
    %    run_id
    %        Unique identifier for the run to delete.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["run_id"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.delete_run(varargin{1:i},pyargs(varargin{i+1:end}));
