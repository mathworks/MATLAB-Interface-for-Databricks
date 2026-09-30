function varargout = login(varargin)
    %LOGIN Configure MLflow server authentication and connect MLflow to tracking server.
    % This method provides a simple way to connect MLflow to its tracking server. Currently only
    % Databricks tracking server is supported. Users will be prompted to enter the credentials if no
    % existing Databricks profile is found, and the credentials will be saved to `~/.databrickscfg`.
    %
    %
    % Input arguments:
    %
    %    backend
    %        string, the backend of the tracking server. Currently only "databricks" is
    %        supported.
    %
    %    interactive
    %        bool, controls request for user input on missing credentials. If true, user
    %        input will be requested if no credentials are found, otherwise an exception will be
    %        raised if no credentials are found.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["backend","interactive"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.login(varargin{1:i},pyargs(varargin{i+1:end}));
