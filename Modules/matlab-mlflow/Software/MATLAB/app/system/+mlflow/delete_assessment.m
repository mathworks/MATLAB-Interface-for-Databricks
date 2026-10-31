function varargout = delete_assessment(varargin)
    %DELETE_ASSESSMENT Deletes an assessment associated with a trace.
    %
    %
    % Input arguments:
    %
    %    trace_id
    %        The ID of the trace.
    %
    %    assessment_id
    %        The ID of the assessment to delete.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["trace_id","assessment_id"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.delete_assessment(varargin{1:i},pyargs(varargin{i+1:end}));
