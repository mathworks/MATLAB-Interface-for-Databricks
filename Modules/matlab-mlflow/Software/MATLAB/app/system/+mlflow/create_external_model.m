function varargout = create_external_model(varargin)
    %CREATE_EXTERNAL_MODEL Create a new LoggedModel whose artifacts are stored outside of MLflow. This is useful for
    % tracking parameters and performance data (metrics, traces etc.) for a model, application, or
    % generative AI agent that is not packaged using the MLflow Model format.
    %
    %   out = mlflow.create_external_model(name,source_run_id,tags,params,model_type,experiment_id)
    %
    % Returns: 
    %
    %    A new :py:class:`mlflow.entities.LoggedModel` object with status ``READY``.
    %
    % Input arguments:
    %
    %    name
    %        The name of the model. If not specified, a random name will be generated.
    %
    %    source_run_id
    %        The ID of the run that the model is associated with. If unspecified and a
    %        run is active, the active run ID will be used.
    %
    %    tags
    %        A dictionary of string keys and values to set as tags on the model.
    %
    %    params
    %        A dictionary of string keys and values to set as parameters on the model.
    %
    %    model_type
    %        The type of the model. This is a user-defined string that can be used to
    %        search and compare related models. For example, setting ``model_type="agent"``
    %        enables you to easily search for this model and compare it to other models of
    %        type ``"agent"`` in the future.
    %
    %    experiment_id
    %        The experiment ID of the experiment to which the model belongs.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["name","source_run_id","tags","params","model_type","experiment_id"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.create_external_model(varargin{1:i},pyargs(varargin{i+1:end}));
