function varargout = get_parent_run(varargin)
    %GET_PARENT_RUN Gets the parent run for the given run id if one exists.
    %
    %   out = mlflow.get_parent_run(run_id)
    %
    % Returns: 
    %
    %    A single :py:class:`mlflow.entities.Run` object, if the parent run exists. Otherwise,
    %    returns None.
    %
    % Input arguments:
    %
    %    run_id
    %        Unique identifier for the child run.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["run_id"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.get_parent_run(varargin{1:i},pyargs(varargin{i+1:end}));
