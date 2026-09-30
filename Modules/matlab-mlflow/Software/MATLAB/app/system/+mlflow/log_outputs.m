function varargout = log_outputs(varargin)
    %LOG_OUTPUTS Log outputs, such as models, to the active run. If there is no active run, a new run will be
    % created.
    %
    %   out = mlflow.log_outputs(models)
    %
    % Returns: 
    %
    %    None.
    %
    % Input arguments:
    %
    %    models
    %        List of :py:class:`mlflow.entities.LoggedModelOutput` instances to log
    %        as outputs to the run.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["models"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.log_outputs(varargin{1:i},pyargs(varargin{i+1:end}));
