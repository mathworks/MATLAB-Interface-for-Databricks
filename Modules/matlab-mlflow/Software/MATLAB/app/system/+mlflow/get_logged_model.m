function varargout = get_logged_model(varargin)
    %GET_LOGGED_MODEL Get a logged model by ID.
    %
    %   out = mlflow.get_logged_model(model_id)
    %
    % Returns: 
    %
    %    The logged model.
    %
    % Input arguments:
    %
    %    model_id
    %        The ID of the logged model.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["model_id"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.get_logged_model(varargin{1:i},pyargs(varargin{i+1:end}));
