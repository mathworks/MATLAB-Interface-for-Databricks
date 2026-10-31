function varargout = search_registered_models(varargin)
    %SEARCH_REGISTERED_MODELS Search for registered models that satisfy the filter criteria.
    %
    %   out = mlflow.search_registered_models(max_results,filter_string,order_by)
    %
    % Returns: 
    %
    %    A list of :py:class:`mlflow.entities.model_registry.RegisteredModel` objects
    %    that satisfy the search expressions.
    %
    % Input arguments:
    %
    %    max_results
    %        If passed, specifies the maximum number of models desired. If not
    %        passed, all models will be returned.
    %
    %    filter_string
    %        Filter query string (e.g., "name = 'a_model_name' and tag.key = 'value1'"),
    %        defaults to searching for all registered models. The following identifiers, comparators,
    %        and logical operators are supported.
    %        Identifiers
    %          - "name": registered model name.
    %          - "tags.<tag_key>": registered model tag. If "tag_key" contains spaces, it must be
    %            wrapped with backticks (e.g., "tags.`extra key`").
    %        Comparators
    %          - "=": Equal to.
    %          - "!=": Not equal to.
    %          - "LIKE": Case-sensitive pattern match.
    %          - "ILIKE": Case-insensitive pattern match.
    %        Logical operators
    %          - "AND": Combines two sub-queries and returns True if both of them are True.
    %
    %    order_by
    %        List of column names with ASC|DESC annotation, to be used for ordering
    %        matching search results.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["max_results","filter_string","order_by"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.search_registered_models(varargin{1:i},pyargs(varargin{i+1:end}));
