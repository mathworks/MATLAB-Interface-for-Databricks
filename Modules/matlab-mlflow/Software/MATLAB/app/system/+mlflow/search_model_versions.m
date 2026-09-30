function varargout = search_model_versions(varargin)
    %SEARCH_MODEL_VERSIONS Search for model versions that satisfy the filter criteria.
    % .. warning:
    %     The model version search results may not have aliases populated for performance reasons.
    %
    %   out = mlflow.search_model_versions(max_results,filter_string,order_by)
    %
    % Returns: 
    %
    %    A list of :py:class:`mlflow.entities.model_registry.ModelVersion` objects
    %    that satisfy the search expressions.
    %
    % Input arguments:
    %
    %    max_results
    %        If passed, specifies the maximum number of models desired. If not
    %        passed, all models will be returned.
    %
    %    filter_string
    %        Filter query string
    %        (e.g., ``"name = 'a_model_name' and tag.key = 'value1'"``),
    %        defaults to searching for all model versions. The following identifiers, comparators,
    %        and logical operators are supported.
    %        Identifiers
    %          - ``name``: model name.
    %          - ``source_path``: model version source path.
    %          - ``run_id``: The id of the mlflow run that generates the model version.
    %          - ``tags.<tag_key>``: model version tag. If ``tag_key`` contains spaces, it must be
    %            wrapped with backticks (e.g., ``"tags.`extra key`"``).
    %        Comparators
    %          - ``=``: Equal to.
    %          - ``!=``: Not equal to.
    %          - ``LIKE``: Case-sensitive pattern match.
    %          - ``ILIKE``: Case-insensitive pattern match.
    %          - ``IN``: In a value list. Only ``run_id`` identifier supports ``IN`` comparator.
    %        Logical operators
    %          - ``AND``: Combines two sub-queries and returns True if both of them are True.
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
    [varargout{1:nargout}] = py.mlflow.search_model_versions(varargin{1:i},pyargs(varargin{i+1:end}));
