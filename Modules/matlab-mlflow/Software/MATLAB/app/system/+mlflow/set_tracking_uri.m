function varargout = set_tracking_uri(varargin)
    %SET_TRACKING_URI Set the tracking server URI. This does not affect the
    % currently active run (if one exists), but takes effect for successive runs.
    %
    %
    % Input arguments:
    %
    %    uri
    %        - An empty string, or a local file path, prefixed with ``file:/``. Data is stored
    %          locally at the provided file (or ``./mlruns`` if empty).
    %        - An HTTP URI like ``https://my-tracking-server:5000``.
    %        - A Databricks workspace, provided as the string "databricks" or, to use a Databricks
    %          CLI `profile <https://github.com/databricks/databricks-cli#installation>`_,
    %          "databricks://<profileName>".
    %        - A :py:class:`pathlib.Path` instance
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["uri"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.set_tracking_uri(varargin{1:i},pyargs(varargin{i+1:end}));
