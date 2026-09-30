function varargout = log_feedback(varargin)
    %LOG_FEEDBACK Logs feedback to a Trace. This API only takes keyword arguments.
    %
    %   out = mlflow.log_feedback()
    %
    % Returns: 
    %
    %    :py:class:`~mlflow.entities.Assessment`: The created feedback assessment.
    %
    % Input arguments:
    %
    %    trace_id
    %        The ID of the trace.
    %
    %    name
    %        The name of the feedback assessment e.g., "faithfulness". Defaults to
    %        "feedback" if not provided.
    %
    %    value
    %        The value of the feedback. Must be one of the following types:
    %        - float
    %        - int
    %        - str
    %        - bool
    %        - list of values of the same types as above
    %        - dict with string keys and values of the same types as above
    %
    %    source
    %        The source of the feedback assessment. Must be an instance of
    %        :py:class:`~mlflow.entities.AssessmentSource`. If not provided, defaults to
    %        CODE source type
    %
    %    error
    %        An error object representing any issues encountered while computing the
    %        feedback, e.g., a timeout error from an LLM judge. Accepts an exception
    %        object, or an :py:class:`~mlflow.entities.AssessmentError` object. Either
    %        this or `value` must be provided.
    %
    %    rationale
    %        The rationale / justification for the feedback.
    %
    %    metadata
    %        Additional metadata for the feedback.
    %
    %    span_id
    %        The ID of the span associated with the feedback, if it needs be
    %        associated with a specific span in the trace.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = [];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.log_feedback(varargin{1:i},pyargs(varargin{i+1:end}));
