function varargout = log_artifact(varargin)
    %LOG_ARTIFACT Log a local file or directory as an artifact of the currently active run. If no run is
    % active, this method will create a new active run.
    %
    %
    % Input arguments:
    %
    %    local_path
    %        Path to the file to write.
    %
    %    artifact_path
    %        If provided, the directory in ``artifact_uri`` to write to.
    %
    %    run_id
    %        If specified, log the artifact to the specified run. If not specified, log the
    %        artifact to the currently active run.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["local_path","artifact_path","run_id"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.log_artifact(varargin{1:i},pyargs(varargin{i+1:end}));
