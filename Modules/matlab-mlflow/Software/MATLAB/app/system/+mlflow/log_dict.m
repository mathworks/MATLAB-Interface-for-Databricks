function varargout = log_dict(varargin)
    %LOG_DICT Log a JSON/YAML-serializable object (e.g. `dict`) as an artifact. The serialization
    % format (JSON or YAML) is automatically inferred from the extension of `artifact_file`.
    % If the file extension doesn't exist or match any of [".json", ".yml", ".yaml"],
    % JSON format is used.
    %
    %
    % Input arguments:
    %
    %    dictionary
    %        Dictionary to log.
    %
    %    artifact_file
    %        The run-relative artifact file path in posixpath format to which
    %        the dictionary is saved (e.g. "dir/data.json").
    %
    %    run_id
    %        If specified, log the dictionary to the specified run. If not specified, log the
    %        dictionary to the currently active run.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["dictionary","artifact_file","run_id"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.log_dict(varargin{1:i},pyargs(varargin{i+1:end}));
