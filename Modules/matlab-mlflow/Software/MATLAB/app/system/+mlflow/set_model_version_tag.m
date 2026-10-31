function varargout = set_model_version_tag(varargin)
    %SET_MODEL_VERSION_TAG Set a tag for the model version.
    %
    %
    % Input arguments:
    %
    %    name
    %        Registered model name.
    %
    %    version
    %        Registered model version.
    %
    %    key
    %        Tag key to log. key is required.
    %
    %    value
    %        Tag value to log. value is required.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["name","version","key","value"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.set_model_version_tag(varargin{1:i},pyargs(varargin{i+1:end}));
