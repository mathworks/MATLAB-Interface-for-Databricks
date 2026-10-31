function varargout = update_assessment(varargin)
    %UPDATE_ASSESSMENT Updates an existing expectation (ground truth) in a Trace.
    %
    %   out = mlflow.update_assessment(trace_id,assessment_id,assessment)
    %
    % Returns: 
    %
    %    :py:class:`~mlflow.entities.Assessment`: The updated feedback or expectation assessment.
    %
    % Input arguments:
    %
    %    trace_id
    %        The ID of the trace.
    %
    %    assessment_id
    %        The ID of the expectation or feedback assessment to update.
    %
    %    assessment
    %        The updated assessment.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["trace_id","assessment_id","assessment"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.update_assessment(varargin{1:i},pyargs(varargin{i+1:end}));
