function varargout = log_trace(varargin)
    %LOG_TRACE .. Warning:: ``mlflow.tracing.fluent.log_trace`` is deprecated since 3.6.0. This method will be removed in a future release.
    % Create a trace with a single root span.
    % This API is useful when you want to log an arbitrary (request, response) pair
    % without structured OpenTelemetry spans. The trace is linked to the active experiment.
    %
    %   out = mlflow.log_trace()
    %
    % Returns: 
    %
    %    The ID of the logged trace.
    %
    % Input arguments:
    %
    %    name
    %        The name of the trace (and the root span). Default to "Task".
    %
    %    request
    %        Input data for the entire trace. This is also set on the root span of the trace.
    %
    %    response
    %        Output data for the entire trace. This is also set on the root span of the trace.
    %
    %    intermediate_outputs
    %        A dictionary of intermediate outputs produced by the model or agent
    %        while handling the request. Keys are the names of the outputs,
    %        and values are the outputs themselves. Values must be JSON-serializable.
    %
    %    attributes
    %        A dictionary of attributes to set on the root span of the trace.
    %
    %    tags
    %        A dictionary of tags to set on the trace.
    %
    %    start_time_ms
    %        The start time of the trace in milliseconds since the UNIX epoch.
    %        When not specified, current time is used for start and end time of the trace.
    %
    %    execution_time_ms
    %        The execution time of the trace in milliseconds since the UNIX epoch.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = [];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.log_trace(varargin{1:i},pyargs(varargin{i+1:end}));
