function varargout = set_prompt_alias(varargin)
    %SET_PROMPT_ALIAS Set an alias for a :py:class:`Prompt <mlflow.entities.Prompt>` in the MLflow Prompt Registry.
    %
    %
    % Input arguments:
    %
    %    name
    %        The name of the prompt.
    %
    %    alias
    %        The alias to set for the prompt.
    %
    %    version
    %        The version of the prompt.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = [];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.set_prompt_alias(varargin{1:i},pyargs(varargin{i+1:end}));
