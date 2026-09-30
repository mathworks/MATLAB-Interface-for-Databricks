function varargout = initialize_logged_model(varargin)
    %INITIALIZE_LOGGED_MODEL Initialize a LoggedModel. Creates a LoggedModel with status ``PENDING`` and no artifacts. You
    % must add artifacts to the model and finalize it to the ``READY`` state, for example by calling
    % a flavor-specific ``log_model()`` method such as :py:func:`mlflow.pyfunc.log_model()`.
    %
    %   out = mlflow.initialize_logged_model(name,source_run_id,tags,params,model_type,experiment_id)
    %
    % Returns: 
    %
    %    A new :py:class:`mlflow.entities.LoggedModel` object with status ``PENDING``.
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
    %        The type of the model.
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
    [varargout{1:nargout}] = py.mlflow.initialize_logged_model(varargin{1:i},pyargs(varargin{i+1:end}));
