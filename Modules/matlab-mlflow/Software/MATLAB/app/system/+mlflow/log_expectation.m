function varargout = log_expectation(varargin)
    %LOG_EXPECTATION Logs an expectation (e.g. ground truth label) to a Trace. This API only takes keyword arguments.
    %
    %   out = mlflow.log_expectation()
    %
    % Returns: 
    %
    %    :py:class:`~mlflow.entities.Assessment`: The created expectation assessment.
    %
    % Input arguments:
    %
    %    trace_id
    %        The ID of the trace.
    %
    %    name
    %        The name of the expectation assessment e.g., "expected_answer
    %
    %    value
    %        The value of the expectation. It can be any JSON-serializable value.
    %
    %    source
    %        The source of the expectation assessment. Must be an instance of
    %        :py:class:`~mlflow.entities.AssessmentSource`. If not provided,
    %        default to HUMAN source type.
    %
    %    metadata
    %        Additional metadata for the expectation.
    %
    %    span_id
    %        The ID of the span associated with the expectation, if it needs be
    %        associated with a specific span in the trace.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = [];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.log_expectation(varargin{1:i},pyargs(varargin{i+1:end}));
