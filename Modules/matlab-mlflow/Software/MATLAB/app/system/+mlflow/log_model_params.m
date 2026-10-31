function varargout = log_model_params(varargin)
    %LOG_MODEL_PARAMS Log params to the specified logged model.
    %
    %   out = mlflow.log_model_params(params,model_id)
    %
    % Returns: 
    %
    %    None
    %
    % Input arguments:
    %
    %    params
    %        Params to log on the model.
    %
    %    model_id
    %        ID of the model. If not specified, use the current active model ID.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["params","model_id"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.log_model_params(varargin{1:i},pyargs(varargin{i+1:end}));
