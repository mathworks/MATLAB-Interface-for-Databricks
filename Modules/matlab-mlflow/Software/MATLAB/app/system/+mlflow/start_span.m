function varargout = start_span(varargin)
    %START_SPAN Context manager to create a new span and start it as the current span in the context.
    % This context manager automatically manages the span lifecycle and parent-child relationships.
    % The span will be ended when the context manager exits. Any exception raised within the
    % context manager will set the span status to ``ERROR``, and detailed information such as
    % exception message and stacktrace will be recorded to the ``attributes`` field of the span.
    % New spans can be created within the context manager, then they will be assigned as child
    % spans.
    % .. code-block:: python
    %     :test:
    %     import mlflow
    %     with mlflow.start_span("my_span") as span:
    %         x = 1
    %         y = 2
    %         span.set_inputs({"x": x, "y": y})
    %         z = x + y
    %         span.set_outputs(z)
    %         span.set_attribute("key", "value")
    %         # do something
    % When this context manager is used in the top-level scope, i.e. not within another span context,
    % the span will be treated as a root span. The root span doesn't have a parent reference and
    % **the entire trace will be logged when the root span is ended**.
    % .. tip::
    %     If you want more explicit control over the trace lifecycle, you can use
    %     the `mlflow.start_span_no_context()` API. It provides lower
    %     level to start spans and control the parent-child relationships explicitly.
    %     However, it is generally recommended to use this context manager as long as it satisfies
    %     your requirements, because it requires less boilerplate code and is less error-prone.
    % .. note::
    %     The context manager doesn't propagate the span context across threads by default. see
    %     `Multi Threading <https://mlflow.org/docs/latest/tracing/api/manual-instrumentation#multi-threading>`_
    %     for how to propagate the span context across threads.
    %
    %   out = mlflow.start_span()
    %
    % Returns: 
    %
    %    Yields an :py:class:`mlflow.entities.Span` that represents the created span.
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
    %    attributes
    %        A dictionary of attributes to set on the span.
    %
    %    trace_destination
    %        The destination to log the trace to, such as MLflow Experiment. If
    %        not provided, the destination will be an active MLflow experiment or an destination
    %        set by the :py:func:`mlflow.tracing.set_destination` function. This parameter
    %        should only be used for root span and setting this for non-root spans will be
    %        ignored with a warning.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = [];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.start_span(varargin{1:i},pyargs(varargin{i+1:end}));
