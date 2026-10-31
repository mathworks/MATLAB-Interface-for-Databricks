function varargout = load_prompt(varargin)
    %LOAD_PROMPT Load a :py:class:`Prompt <mlflow.entities.Prompt>` from the MLflow Prompt Registry.
    % The prompt can be specified by name and version, or by URI.
    %
    %
    % Input arguments:
    %
    %    name_or_uri
    %        The name of the prompt, or the URI in the format "prompts:/name/version".
    %
    %    version
    %        The version of the prompt (required when using name, not allowed when using URI).
    %
    %    allow_missing
    %        If True, return None instead of raising Exception if the specified prompt
    %        is not found.
    %
    %    link_to_model
    %        If True, the prompt will be linked to the model with the ID specified
    %        by `model_id`, or the active model ID if `model_id` is None and
    %        there is an active model.
    %
    %    model_id
    %        The ID of the model to which to link the prompt, if `link_to_model` is True.
    %
    %    cache_ttl_seconds
    %        Time-to-live in seconds for the cached prompt. If not specified,
    %        uses the value from `MLFLOW_ALIAS_PROMPT_CACHE_TTL_SECONDS` environment variable for
    %        alias-based prompts (default 60), and the value from
    %        `MLFLOW_VERSION_PROMPT_CACHE_TTL_SECONDS` environment variable for version-based prompts
    %        (default None, no TTL). Set to 0 to bypass the cache and always fetch from the server.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = [];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.load_prompt(varargin{1:i},pyargs(varargin{i+1:end}));
