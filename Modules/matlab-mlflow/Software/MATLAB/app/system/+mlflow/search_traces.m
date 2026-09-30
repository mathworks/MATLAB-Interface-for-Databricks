function varargout = search_traces(varargin)
    %SEARCH_TRACES .. Note:: Parameter ``experiment_ids`` is deprecated. Use ``locations`` instead.
    % Return traces that match the given list of search expressions within the experiments.
    % .. note::
    %     If expected number of search results is large, consider using the
    %     `MlflowClient.search_traces` API directly to paginate through the results. This
    %     function returns all results in memory and may not be suitable for large result sets.
    %
    %   out = mlflow.search_traces(experiment_ids,filter_string,max_results,order_by,extract_fields,run_id,return_type,model_id,sql_warehouse_id,include_spans,locations)
    %
    % Returns: 
    %
    %    Traces that satisfy the search expressions. Either as a list of
    %    :py:class:`Trace <mlflow.entities.Trace>` objects or as a Pandas DataFrame,
    %    depending on the value of the `return_type` parameter.
    %
    % Input arguments:
    %
    %    experiment_ids
    %        List of experiment ids to scope the search.
    %
    %    filter_string
    %        A search filter string.
    %
    %    max_results
    %        Maximum number of traces desired. If None, all traces matching the search
    %        expressions will be returned.
    %
    %    order_by
    %        List of order_by clauses.
    %
    %    extract_fields
    %        .. deprecated:: 3.6.0
    %            This parameter is deprecated and will be removed in a future version.
    %        Specify fields to extract from traces using the format
    %        ``"span_name.[inputs|outputs].field_name"`` or ``"span_name.[inputs|outputs]"``.
    %        .. note::
    %            This parameter is only supported when the return type is set to "pandas".
    %        For instance, ``"predict.outputs.result"`` retrieves the output ``"result"`` field from
    %        a span named ``"predict"``, while ``"predict.outputs"`` fetches the entire outputs
    %        dictionary, including keys ``"result"`` and ``"explanation"``.
    %        By default, no fields are extracted into the DataFrame columns. When multiple
    %        fields are specified, each is extracted as its own column. If an invalid field
    %        string is provided, the function silently returns without adding that field's column.
    %        The supported fields are limited to ``"inputs"`` and ``"outputs"`` of spans. If the
    %        span name or field name contains a dot it must be enclosed in backticks. For example:
    %        .. code-block:: python
    %            # span name contains a dot
    %            extract_fields = ["`span.name`.inputs.field"]
    %            # field name contains a dot
    %            extract_fields = ["span.inputs.`field.name`"]
    %            # span name and field name contain a dot
    %            extract_fields = ["`span.name`.inputs.`field.name`"]
    %
    %    run_id
    %        A run id to scope the search. When a trace is created under an active run,
    %        it will be associated with the run and you can filter on the run id to retrieve the
    %        trace. See the example below for how to filter traces by run id.
    %
    %    return_type
    %        The type of the return value. The following return types are supported. If
    %        the pandas library is installed, the default return type is "pandas". Otherwise, the
    %        default return type is "list".
    %        - `"pandas"`: Returns a Pandas DataFrame containing information about traces
    %            where each row represents a single trace and each column represents a field of the
    %            trace e.g. trace_id, spans, etc.
    %        - `"list"`: Returns a list of :py:class:`Trace <mlflow.entities.Trace>` objects.
    %
    %    model_id
    %        If specified, search traces associated with the given model ID.
    %
    %    sql_warehouse_id
    %        DEPRECATED. Use the `MLFLOW_TRACING_SQL_WAREHOUSE_ID` environment
    %        variable instead. The ID of the SQL warehouse to use for
    %        searching traces in inference tables or UC tables. Only used in Databricks.
    %
    %    include_spans
    %        If ``True``, include spans in the returned traces. Otherwise, only
    %        the trace metadata is returned, e.g., trace ID, start time, end time, etc,
    %        without any spans. Default to ``True``.
    %
    %    locations
    %        A list of locations to search over. To search over experiments, provide
    %        a list of experiment IDs. To search over UC tables on databricks, provide
    %        a list of locations in the format `<catalog_name>.<schema_name>`.
    %        If not provided, the search will be performed across the current active experiment.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["experiment_ids","filter_string","max_results","order_by","extract_fields","run_id","return_type","model_id","sql_warehouse_id","include_spans","locations"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.search_traces(varargin{1:i},pyargs(varargin{i+1:end}));
