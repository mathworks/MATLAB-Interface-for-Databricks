function varargout = get_artifact_uri(varargin)
    %GET_ARTIFACT_URI Get the absolute URI of the specified artifact in the currently active run.
    % If `path` is not specified, the artifact root URI of the currently active
    % run will be returned; calls to ``log_artifact`` and ``log_artifacts`` write
    % artifact(s) to subdirectories of the artifact root URI.
    % If no run is active, this method will create a new active run.
    %
    %   out = mlflow.get_artifact_uri(artifact_path)
    %
    % Returns: 
    %
    %    An *absolute* URI referring to the specified artifact or the currently active run's
    %    artifact root. For example, if an artifact path is provided and the currently active
    %    run uses an S3-backed store, this may be a uri of the form
    %    ``s3://<bucket_name>/path/to/artifact/root/path/to/artifact``. If an artifact path
    %    is not provided and the currently active run uses an S3-backed store, this may be a
    %    URI of the form ``s3://<bucket_name>/path/to/artifact/root``.
    %
    % Input arguments:
    %
    %    artifact_path
    %        The run-relative artifact path for which to obtain an absolute URI.
    %        For example, "path/to/artifact". If unspecified, the artifact root URI
    %        for the currently active run will be returned.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["artifact_path"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.get_artifact_uri(varargin{1:i},pyargs(varargin{i+1:end}));
