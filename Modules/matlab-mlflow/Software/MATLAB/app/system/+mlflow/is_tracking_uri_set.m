function varargout = is_tracking_uri_set(varargin)
    %IS_TRACKING_URI_SET Returns True if the tracking URI has been set, False otherwise.
    %
    %
    % Input arguments:
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = [];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.is_tracking_uri_set(varargin{1:i},pyargs(varargin{i+1:end}));
