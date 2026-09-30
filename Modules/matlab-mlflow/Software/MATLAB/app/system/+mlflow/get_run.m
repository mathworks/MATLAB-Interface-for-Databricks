function varargout = get_run(varargin)
    %GET_RUN Fetch the run from backend store. The resulting Run contains a collection of run metadata --
    % RunInfo as well as a collection of run parameters, tags, and metrics -- RunData. It also
    % contains a collection of run inputs (experimental), including information about datasets used by
    % the run -- RunInputs. In the case where multiple metrics with the same key are logged for the
    % run, the RunData contains the most recently logged value at the largest step for each metric.
    %
    %   out = mlflow.get_run(run_id)
    %
    % Returns: 
    %
    %    A single Run object, if the run exists. Otherwise, raises an exception.
    %
    % Input arguments:
    %
    %    run_id
    %        Unique identifier for the run.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["run_id"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.get_run(varargin{1:i},pyargs(varargin{i+1:end}));
