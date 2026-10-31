function varargout = log_table(varargin)
    %LOG_TABLE Log a table to MLflow Tracking as a JSON artifact. If the artifact_file already exists
    % in the run, the data would be appended to the existing artifact_file.
    %
    %
    % Input arguments:
    %
    %    data
    %        Dictionary or pandas.DataFrame to log.
    %
    %    artifact_file
    %        The run-relative artifact file path in posixpath format to which
    %        the table is saved (e.g. "dir/file.json").
    %
    %    run_id
    %        If specified, log the table to the specified run. If not specified, log the
    %        table to the currently active run.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["data","artifact_file","run_id"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.log_table(varargin{1:i},pyargs(varargin{i+1:end}));
