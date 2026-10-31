function varargout = get_trace(varargin)
    %GET_TRACE .. Note:: Parameter ``request_id`` is deprecated. Use ``trace_id`` instead.
    % Get a trace by the given request ID if it exists.
    % This function retrieves the trace from the in-memory buffer first, and if it doesn't exist,
    % it fetches the trace from the tracking store. If the trace is not found in the tracking store,
    % it returns None.
    %
    %   out = mlflow.get_trace(trace_id,silent)
    %
    % Returns: 
    %
    %    A :py:class:`mlflow.entities.Trace` objects with the given request ID.
    %
    % Input arguments:
    %
    %    trace_id
    %        The ID of the trace.
    %
    %    silent
    %        If True, suppress the warning message when the trace is not found. The API will
    %        return None without any warning. Default to False.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["trace_id","silent"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.get_trace(varargin{1:i},pyargs(varargin{i+1:end}));
