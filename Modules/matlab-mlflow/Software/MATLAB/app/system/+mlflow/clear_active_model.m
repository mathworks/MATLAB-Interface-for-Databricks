function varargout = clear_active_model(varargin)
    %CLEAR_ACTIVE_MODEL Clear the active model. This will clear the active model previously set by
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
    [varargout{1:nargout}] = py.mlflow.clear_active_model(varargin{1:i},pyargs(varargin{i+1:end}));
