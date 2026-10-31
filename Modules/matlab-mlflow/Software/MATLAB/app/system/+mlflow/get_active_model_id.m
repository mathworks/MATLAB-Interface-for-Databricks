function varargout = get_active_model_id(varargin)
    %GET_ACTIVE_MODEL_ID Get the active model ID. If no active model is set with ``set_active_model()``, the
    % default active model is set using model ID from the environment variable
    % ``MLFLOW_ACTIVE_MODEL_ID`` or the legacy environment variable ``_MLFLOW_ACTIVE_MODEL_ID``.
    % If neither is set, return None. Note that this function only get the active model ID from the
    % current thread.
    %
    %   out = mlflow.get_active_model_id()
    %
    % Returns: 
    %
    %    The active model ID if set, otherwise None.
    %
    % Input arguments:
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = [];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.get_active_model_id(varargin{1:i},pyargs(varargin{i+1:end}));
