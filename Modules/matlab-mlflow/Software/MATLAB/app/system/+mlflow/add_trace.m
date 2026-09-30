function varargout = add_trace(varargin)
    %ADD_TRACE Add a completed trace object into another trace.
    % This is particularly useful when you call a remote service instrumented by
    % MLflow Tracing. By using this function, you can merge the trace from the remote
    % service into the current active local trace, so that you can see the full
    % trace including what happens inside the remote service call.
    % The following example demonstrates how to use this function to merge a trace from a remote
    % service to the current active trace in the function.
    % .. code-block:: python
    %     @mlflow.trace(name="predict")
    %     def predict(input):
    %         # Call a remote service that returns a trace in the response
    %         resp = requests.get("https://your-service-endpoint", ...)
    %         # Extract the trace from the response
    %         trace_json = resp.json().get("trace")
    %         # Use the remote trace as a part of the current active trace.
    %         # It will be merged under the span "predict" and exported together when it is ended.
    %         mlflow.add_trace(trace_json)
    % If you have a specific target span to merge the trace under, you can pass the target span
    % .. code-block:: python
    %     def predict(input):
    %         # Create a local span
    %         with mlflow.start_span(name="predict") as span:
    %             resp = requests.get("https://your-service-endpoint", ...)
    %             trace_json = resp.json().get("trace")
    %             # Merge the remote trace under the span created above
    %             mlflow.add_trace(trace_json, target=span)
    %
    %
    % Input arguments:
    %
    %    trace
    %        A :py:class:`Trace <mlflow.entities.Trace>` object or a dictionary representation
    %        of the trace. The trace **must** be already completed i.e. no further updates should
    %        be made to it. Otherwise, this function will raise an exception.
    %        .. attention:
    %            The spans in the trace must be ordered in a way that the parent span comes
    %            before its children. If the spans are not ordered correctly, this function
    %            will raise an exception.
    %
    %    target
    %        The target span to merge the given trace.
    %        - If provided, the trace will be merged under the target span.
    %        - If not provided, the trace will be merged under the current active span.
    %        - If not provided and there is no active span, a new span named "Remote Trace <...>"
    %          will be created and the trace will be merged under it.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["trace","target"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.add_trace(varargin{1:i},pyargs(varargin{i+1:end}));
