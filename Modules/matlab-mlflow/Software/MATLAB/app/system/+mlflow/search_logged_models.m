function varargout = search_logged_models(varargin)
    %SEARCH_LOGGED_MODELS Search for logged models that match the specified search criteria.
    %
    %   out = mlflow.search_logged_models(experiment_ids,filter_string,datasets,max_results,order_by,output_format)
    %
    % Returns: 
    %
    %    The search results in the specified output format.
    %
    % Input arguments:
    %
    %    experiment_ids
    %        List of experiment IDs to search for logged models. If not specified,
    %        the active experiment will be used.
    %
    %    filter_string
    %        A SQL-like filter string to parse. The filter string syntax supports:
    %        - Entity specification:
    %            - attributes: `attribute_name` (default if no prefix is specified)
    %            - metrics: `metrics.metric_name`
    %            - parameters: `params.param_name`
    %            - tags: `tags.tag_name`
    %        - Comparison operators:
    %            - For numeric entities (metrics and numeric attributes): <, <=, >, >=, =, !=
    %            - For string entities (params, tags, string attributes): =, !=, IN, NOT IN
    %        - Multiple conditions can be joined with 'AND'
    %        - String values must be enclosed in single quotes
    %        Example filter strings:
    %            - `creation_time > 100`
    %            - `metrics.rmse > 0.5 AND params.model_type = 'rf'`
    %            - `tags.release IN ('v1.0', 'v1.1')`
    %            - `params.optimizer != 'adam' AND metrics.accuracy >= 0.9`
    %
    %    datasets
    %        List of dictionaries to specify datasets on which to apply metrics filters
    %        For example, a filter string with `metrics.accuracy > 0.9` and dataset with name
    %        "test_dataset" means we will return all logged models with accuracy > 0.9 on the
    %        test_dataset. Metric values from ANY dataset matching the criteria are considered.
    %        If no datasets are specified, then metrics across all datasets are considered in
    %        the filter. The following fields are supported:
    %        dataset_name (str):
    %            Required. Name of the dataset.
    %        dataset_digest (str):
    %            Optional. Digest of the dataset.
    %
    %    max_results
    %        The maximum number of logged models to return.
    %
    %    order_by
    %        List of dictionaries to specify the ordering of the search results. The following
    %        fields are supported:
    %        field_name (str):
    %            Required. Name of the field to order by, e.g. "metrics.accuracy".
    %        ascending (bool):
    %            Optional. Whether the order is ascending or not.
    %        dataset_name (str):
    %            Optional. If ``field_name`` refers to a metric, this field
    %            specifies the name of the dataset associated with the metric. Only metrics
    %            associated with the specified dataset name will be considered for ordering.
    %            This field may only be set if ``field_name`` refers to a metric.
    %        dataset_digest (str):
    %            Optional. If ``field_name`` refers to a metric, this field
    %            specifies the digest of the dataset associated with the metric. Only metrics
    %            associated with the specified dataset name and digest will be considered for
    %            ordering. This field may only be set if ``dataset_name`` is also set.
    %
    %    output_format
    %        The output format of the search results. Supported values are 'pandas'
    %        and 'list'.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["experiment_ids","filter_string","datasets","max_results","order_by","output_format"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.search_logged_models(varargin{1:i},pyargs(varargin{i+1:end}));
