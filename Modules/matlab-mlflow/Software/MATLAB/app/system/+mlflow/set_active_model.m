function varargout = set_active_model(varargin)
    %SET_ACTIVE_MODEL Set the active model with the specified name or model ID, and it will be used for linking
    % traces that are generated during the lifecycle of the model. The return value can be used as
    % a context manager within a ``with`` block; otherwise, you must call ``set_active_model()``
    % to update active model.
    %
    %   out = mlflow.set_active_model()
    %
    % Returns: 
    %
    %    :py:class:`mlflow.ActiveModel` object that acts as a context manager wrapping the
    %    LoggedModel's state.
    %
    % Input arguments:
    %
    %    name
    %        The name of the :py:class:`mlflow.entities.LoggedModel` to set as active.
    %        If a LoggedModel with the name does not exist, it will be created under the current
    %        experiment. If multiple LoggedModels with the name exist, the latest one will be
    %        set as active.
    %
    %    model_id
    %        The ID of the :py:class:`mlflow.entities.LoggedModel` to set as active.
    %        If no LoggedModel with the ID exists, an exception will be raised.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = [];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.set_active_model(varargin{1:i},pyargs(varargin{i+1:end}));
