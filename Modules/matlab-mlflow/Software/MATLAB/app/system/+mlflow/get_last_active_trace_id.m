function varargout = get_last_active_trace_id(varargin)
    %GET_LAST_ACTIVE_TRACE_ID Get the **LAST** active trace in the same process if exists.
    % .. warning::
    %     This function is not thread-safe by default, returns the last active trace in
    %     the same process. If you want to get the last active trace in the current thread,
    %     set the `thread_local` parameter to True.
    %
    %   out = mlflow.get_last_active_trace_id(thread_local)
    %
    % Returns: 
    %
    %    The ID of the last active trace if exists, otherwise None.
    %
    % Input arguments:
    %
    %    thread_local
    %        If True, returns the last active trace in the current thread. Otherwise,
    %        returns the last active trace in the same process. Default is False.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["thread_local"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.get_last_active_trace_id(varargin{1:i},pyargs(varargin{i+1:end}));
