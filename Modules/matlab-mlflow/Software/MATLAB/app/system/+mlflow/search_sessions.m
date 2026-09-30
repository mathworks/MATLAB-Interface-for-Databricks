function varargout = search_sessions(varargin)
    %SEARCH_SESSIONS .. Note:: Experimental: This function may change or be removed in a future release without warning.
    % Return complete sessions that match the given search criteria.
    % A session is a collection of traces that share the same session ID, typically representing
    % a multi-turn conversation or a series of related interactions. This API retrieves complete
    % sessions by first identifying unique session IDs from traces, then fetching all traces
    % belonging to each session in parallel.
    %
    %   out = mlflow.search_sessions(max_results,run_id,model_id,include_spans,locations)
    %
    % Returns: 
    %
    %    A list of :py:class:`Session <mlflow.entities.Session>` objects, where each session
    %    contains :py:class:`Trace <mlflow.entities.Trace>` objects that share the same
    %    session ID. Sessions are ordered by the timestamp of their first trace (most recent first).
    %    Each Session object provides convenient access via ``session.id`` and supports
    %    iteration with ``for trace in session``.
    %
    % Input arguments:
    %
    %    max_results
    %        Maximum number of sessions to return. Default is 100.
    %
    %    run_id
    %        A run id to scope the search. When a trace is created under an active run,
    %        it will be associated with the run and you can filter on the run id to retrieve
    %        traces.
    %
    %    model_id
    %        If specified, search traces associated with the given model ID.
    %
    %    include_spans
    %        If ``True``, include spans in the returned traces. Otherwise, only
    %        the trace metadata is returned. Default is ``True``.
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
    args = ["max_results","run_id","model_id","include_spans","locations"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.search_sessions(varargin{1:i},pyargs(varargin{i+1:end}));
