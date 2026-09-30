function varargout = log_text(varargin)
    %LOG_TEXT Log text as an artifact.
    %
    %
    % Input arguments:
    %
    %    text
    %        String containing text to log.
    %
    %    artifact_file
    %        The run-relative artifact file path in posixpath format to which
    %        the text is saved (e.g. "dir/file.txt").
    %
    %    run_id
    %        If specified, log the artifact to the specified run. If not specified, log the
    %        artifact to the currently active run.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["text","artifact_file","run_id"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.log_text(varargin{1:i},pyargs(varargin{i+1:end}));
