function varargout = set_trace_tag(varargin)
    %SET_TRACE_TAG .. Note:: Parameter ``request_id`` is deprecated. Use ``trace_id`` instead.
    % Set a tag on the trace with the given trace ID.
    % The trace can be an active one or the one that has already ended and recorded in the
    % backend. Below is an example of setting a tag on an active trace. You can replace the
    % ``trace_id`` parameter to set a tag on an already ended trace.
    % .. code-block:: python
    %     :test:
    %     import mlflow
    %     with mlflow.start_span(name="span") as span:
    %         mlflow.set_trace_tag(span.trace_id, "key", "value")
    %
    %
    % Input arguments:
    %
    %    trace_id
    %        The ID of the trace to set the tag on.
    %
    %    key
    %        The string key of the tag. Must be at most 250 characters long, otherwise
    %        it will be truncated when stored.
    %
    %    value
    %        The string value of the tag. Must be at most 250 characters long, otherwise
    %        it will be truncated when stored.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["trace_id","key","value"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.set_trace_tag(varargin{1:i},pyargs(varargin{i+1:end}));
