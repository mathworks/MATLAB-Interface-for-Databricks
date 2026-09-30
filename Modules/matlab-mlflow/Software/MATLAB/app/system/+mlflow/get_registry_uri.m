function varargout = get_registry_uri(varargin)
    %GET_REGISTRY_URI Get the current registry URI. If none has been specified, defaults to the tracking URI.
    %
    %   out = mlflow.get_registry_uri()
    %
    % Returns: 
    %
    %    The registry URI.
    %
    % Input arguments:
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = [];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.get_registry_uri(varargin{1:i},pyargs(varargin{i+1:end}));
