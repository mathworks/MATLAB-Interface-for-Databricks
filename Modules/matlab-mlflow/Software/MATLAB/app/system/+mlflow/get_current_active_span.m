function varargout = get_current_active_span(varargin)
    %GET_CURRENT_ACTIVE_SPAN Get the current active span in the global context.
    % .. attention::
    %     This only works when the span is created with fluent APIs like `@mlflow.trace` or
    %     `with mlflow.start_span`. If a span is created with the
    %     `mlflow.start_span_no_context` APIs, it won't be
    %     attached to the global context so this function will not return it.
    % .. code-block:: python
    %     :test:
    %     import mlflow
    %     @mlflow.trace
    %     def f():
    %         span = mlflow.get_current_active_span()
    %         span.set_attribute("key", "value")
    %         return 0
    %     f()
    %
    %   out = mlflow.get_current_active_span()
    %
    % Returns: 
    %
    %    The current active span if exists, otherwise None.
    %
    % Input arguments:
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = [];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.get_current_active_span(varargin{1:i},pyargs(varargin{i+1:end}));
