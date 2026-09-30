function varargout = get_tracking_uri(varargin)
    %GET_TRACKING_URI Get the current tracking URI. This may not correspond to the tracking URI of
    % the currently active run, since the tracking URI can be updated via ``set_tracking_uri``.
    %
    %   out = mlflow.get_tracking_uri()
    %
    % Returns: 
    %
    %    The tracking URI.
    %
    % Input arguments:
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = [];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.get_tracking_uri(varargin{1:i},pyargs(varargin{i+1:end}));
