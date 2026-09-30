function varargout = log_stream(varargin)
    %LOG_STREAM .. Note:: Experimental: This function may change or be removed in a future release without warning.
    % Log a binary file-like object (e.g., ``io.BytesIO``) as an artifact.
    %
    %
    % Input arguments:
    %
    %    stream
    %        A binary file-like object supporting ``.read()`` method (e.g., ``io.BytesIO``).
    %
    %    artifact_file
    %        The run-relative artifact file path in posixpath format to which
    %        the stream content is saved (e.g. "dir/file.bin").
    %
    %    run_id
    %        If specified, log the artifact to the specified run. If not specified, log the
    %        artifact to the currently active run.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["stream","artifact_file","run_id"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.log_stream(varargin{1:i},pyargs(varargin{i+1:end}));
