function varargout = set_system_metrics_node_id(varargin)
    %SET_SYSTEM_METRICS_NODE_ID Set the system metrics node id.
    % node_id is the identifier of the machine where the metrics are collected. This is useful in
    % multi-node (distributed training) setup.
    %
    %
    % Input arguments:
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["node_id"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.set_system_metrics_node_id(varargin{1:i},pyargs(varargin{i+1:end}));
