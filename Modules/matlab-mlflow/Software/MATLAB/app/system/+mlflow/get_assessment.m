function varargout = get_assessment(varargin)
    %GET_ASSESSMENT Get an assessment entity from the backend store.
    %
    %   out = mlflow.get_assessment(trace_id,assessment_id)
    %
    % Returns: 
    %
    %    :py:class:`~mlflow.entities.Assessment`: The Assessment object.
    %
    % Input arguments:
    %
    %    trace_id
    %        The ID of the trace.
    %
    %    assessment_id
    %        The ID of the assessment to get.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["trace_id","assessment_id"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.get_assessment(varargin{1:i},pyargs(varargin{i+1:end}));
