function varargout = log_input(varargin)
    %LOG_INPUT Log a dataset used in the current run.
    %
    %
    % Input arguments:
    %
    %    dataset
    %        :py:class:`mlflow.data.dataset.Dataset` object to be logged.
    %
    %    context
    %        Context in which the dataset is used. For example: "training", "testing".
    %        This will be set as an input tag with key `mlflow.data.context`.
    %
    %    tags
    %        Tags to be associated with the dataset. Dictionary of tag_key -> tag_value.
    %
    %    model
    %        A :py:class:`mlflow.entities.LoggedModelInput` instance to log as input to
    %        the run.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["dataset","context","tags","model"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.log_input(varargin{1:i},pyargs(varargin{i+1:end}));
