function varargout = last_logged_model(varargin)
    %LAST_LOGGED_MODEL Fetches the most recent logged model in the current session.
    % If no model has been logged, None is returned.
    %
    %   out = mlflow.last_logged_model()
    %
    % Returns: 
    %
    %    The logged model.
    %
    % Input arguments:
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = [];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.last_logged_model(varargin{1:i},pyargs(varargin{i+1:end}));
