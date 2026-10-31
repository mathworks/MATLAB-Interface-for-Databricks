function varargout = finalize_logged_model(varargin)
    %FINALIZE_LOGGED_MODEL Finalize a model by updating its status.
    %
    %   out = mlflow.finalize_logged_model(model_id,status)
    %
    % Returns: 
    %
    %    The updated model.
    %
    % Input arguments:
    %
    %    model_id
    %        ID of the model to finalize.
    %
    %    status
    %        Final status to set on the model.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["model_id","status"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.finalize_logged_model(varargin{1:i},pyargs(varargin{i+1:end}));
