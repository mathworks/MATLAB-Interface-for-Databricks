function varargout = log_inputs(varargin)
    %LOG_INPUTS Log a batch of datasets used in the current run.
    % The lists of `datasets`, `contexts`, `tags_list` must have the same length.
    % The entries in these lists can be ``None``, which represents empty value to the
    % corresponding input.
    %
    %
    % Input arguments:
    %
    %    datasets
    %        List of :py:class:`mlflow.data.dataset.Dataset` object to be logged.
    %
    %    contexts
    %        List of context in which the dataset is used. For example: "training", "testing".
    %        This will be set as an input tag with key `mlflow.data.context`.
    %
    %    tags_list
    %        List of tags to be associated with the dataset. Dictionary of
    %        tag_key -> tag_value.
    %
    %    models
    %        List of :py:class:`mlflow.entities.LoggedModelInput` instance to log as input
    %        to the run. Currently only Databricks managed MLflow supports this argument.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["datasets","contexts","tags_list","models"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.log_inputs(varargin{1:i},pyargs(varargin{i+1:end}));
