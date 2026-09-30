function varargout = set_logged_model_tags(varargin)
    %SET_LOGGED_MODEL_TAGS Set tags on the specified logged model.
    %
    %   out = mlflow.set_logged_model_tags(model_id,tags)
    %
    % Returns: 
    %
    %    None
    %
    % Input arguments:
    %
    %    model_id
    %        ID of the model.
    %
    %    tags
    %        Tags to set on the model.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["model_id","tags"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.set_logged_model_tags(varargin{1:i},pyargs(varargin{i+1:end}));
