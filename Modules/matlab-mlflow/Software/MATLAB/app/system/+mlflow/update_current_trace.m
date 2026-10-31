function varargout = update_current_trace(varargin)
    %UPDATE_CURRENT_TRACE Update the current active trace with the given options.
    %
    %
    % Input arguments:
    %
    %    tags
    %        A dictionary of tags to update the trace with Tags are designed for mutable values,
    %        that can be updated after the trace is created via MLflow UI or API.
    %
    %    metadata
    %        A dictionary of metadata to update the trace with. Metadata cannot be updated
    %        once the trace is logged. It is suitable for recording immutable values like the
    %        git hash of the application version that produced the trace.
    %
    %    client_request_id
    %        Client supplied request ID to associate with the trace. This is
    %        useful for linking the trace back to a specific request in your application or
    %        external system. If None, the client request ID is not updated.
    %
    %    request_preview
    %        A preview of the request to be shown in the Trace list view in the UI.
    %        By default, MLflow will truncate the trace request naively by limiting the length.
    %        This parameter allows you to specify a custom preview string.
    %
    %    response_preview
    %        A preview of the response to be shown in the Trace list view in the UI.
    %        By default, MLflow will truncate the trace response naively by limiting the length.
    %        This parameter allows you to specify a custom preview string.
    %
    %    state
    %        The state to set on the trace. Can be a TraceState enum value or string.
    %        Only "OK" and "ERROR" are allowed. This overrides the overall trace state without
    %        affecting the status of the current span.
    %
    %    model_id
    %        The ID of the model to associate with the trace. If not set, the active
    %        model ID is associated with the trace.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["tags","metadata","client_request_id","request_preview","response_preview","state","model_id"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.update_current_trace(varargin{1:i},pyargs(varargin{i+1:end}));
