function varargout = set_registry_uri(varargin)
    %SET_REGISTRY_URI Set the registry server URI. This method is especially useful if you have a registry server
    % that's different from the tracking server.
    %
    %
    % Input arguments:
    %
    %    uri
    %        An empty string, or a local file path, prefixed with ``file:/``. Data is stored
    %        locally at the provided file (or ``./mlruns`` if empty). An HTTP URI like
    %        ``https://my-tracking-server:5000`` or ``http://my-oss-uc-server:8080``. A Databricks
    %        workspace, provided as the string "databricks" or, to use a Databricks CLI
    %        `profile <https://github.com/databricks/databricks-cli#installation>`_,
    %        "databricks://<profileName>".
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["uri"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.set_registry_uri(varargin{1:i},pyargs(varargin{i+1:end}));
