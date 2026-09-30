function varargout = register_model(varargin)
    %REGISTER_MODEL Create a new model version in model registry for the model files specified by ``model_uri``.
    % Note that this method assumes the model registry backend URI is the same as that of the
    % tracking backend.
    %
    %   out = mlflow.register_model(model_uri,name,await_registration_for)
    %
    % Returns: 
    %
    %    Single :py:class:`mlflow.entities.model_registry.ModelVersion` object created by
    %    backend.
    %
    % Input arguments:
    %
    %    model_uri
    %        URI referring to the MLmodel directory. Supported URI schemes include:
    %        - ``runs:/`` URIs (e.g., ``runs:/<run_id>/<artifact_path>``) to register a model
    %          from a specific run. The run ID is recorded with the model version.
    %        - ``models:/`` URIs, which support two forms:
    %          - ``models:/<model_name>/<version>`` to promote an existing registered
    %            model version. The source run lineage is preserved when the
    %            referenced model version has an associated source run.
    %          - ``models:/<model_id>`` to create a new registered model version from a logged
    %            model (for example, one returned by ``log_model``). The source
    %            run lineage is preserved.
    %        - Local filesystem paths for registering locally-persisted MLflow models that were
    %          previously saved using ``save_model``.
    %
    %    name
    %        Name of the registered model under which to create a new model version. If a
    %        registered model with the given name does not exist, it will be created
    %        automatically.
    %
    %    await_registration_for
    %        Number of seconds to wait for the model version to finish
    %        being created and is in ``READY`` status. By default, the function
    %        waits for five minutes. Specify 0 or None to skip waiting.
    %
    %    tags
    %        A dictionary of key-value pairs that are converted into
    %        :py:class:`mlflow.entities.model_registry.ModelVersionTag` objects.
    %
    %    env_pack
    %        Either a string or an EnvPackConfig. If specified,
    %        the model dependencies are optionally first installed into the current Python
    %        environment, and then the complete environment will be packaged and included
    %        in the registered model artifacts. If the string shortcut "databricks_model_serving" is
    %        used, then model dependencies will be installed in the current environment. This is
    %        useful when deploying the model to a serving environment like Databricks Model Serving.
    %        .. Note:: Experimental: This parameter may change or be removed in a future
    %                                release without warning.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["model_uri","name","await_registration_for"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.register_model(varargin{1:i},pyargs(varargin{i+1:end}));
