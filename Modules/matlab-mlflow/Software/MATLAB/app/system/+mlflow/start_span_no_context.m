function varargout = start_span_no_context(varargin)
    %START_SPAN_NO_CONTEXT Start a span without attaching it to the global tracing context.
    % This is useful when you want to create a span without automatically linking
    % with a parent span and instead manually manage the parent-child relationships.
    % The span started with this function must be ended manually using the
    % `end()` method of the span object.
    %
    %   out = mlflow.start_span_no_context(name,span_type,parent_span,inputs,attributes,tags,metadata,experiment_id,start_time_ns)
    %
    % Returns: 
    %
    %    A :py:class:`mlflow.entities.Span` that represents the created span.
    %
    % Input arguments:
    %
    %    name
    %        The name of the span.
    %
    %    span_type
    %        The type of the span. Can be either a string or
    %        a :py:class:`SpanType <mlflow.entities.SpanType>` enum value
    %
    %    parent_span
    %        The parent span to link with. If None, the span will be treated as a root span.
    %
    %    inputs
    %        The input data for the span.
    %
    %    attributes
    %        A dictionary of attributes to set on the span.
    %
    %    tags
    %        A dictionary of tags to set on the trace.
    %
    %    metadata
    %        A dictionary of metadata to set on the trace.
    %
    %    experiment_id
    %        The experiment ID to associate with the trace. If not provided,
    %        the current active experiment will be used.
    %
    %    start_time_ns
    %        The start time of the span in nanoseconds. If not provided,
    %        the current time will be used.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["name","span_type","parent_span","inputs","attributes","tags","metadata","experiment_id","start_time_ns"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.start_span_no_context(varargin{1:i},pyargs(varargin{i+1:end}));
