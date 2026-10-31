function varargout = delete_logged_model_tag(varargin)
    %DELETE_LOGGED_MODEL_TAG Delete a tag from the specified logged model.
    %
    %
    % Input arguments:
    %
    %    model_id
    %        ID of the model.
    %
    %    key
    %        Tag key to delete.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["model_id","key"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.delete_logged_model_tag(varargin{1:i},pyargs(varargin{i+1:end}));
