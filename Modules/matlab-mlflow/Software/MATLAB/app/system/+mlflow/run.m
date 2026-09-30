function varargout = run(varargin)
    %RUN Run an MLflow project. The project can be local or stored at a Git URI.
    % MLflow provides built-in support for running projects locally or remotely on a Databricks or
    % Kubernetes cluster. You can also run projects against other targets by installing an appropriate
    % third-party plugin. See `Community Plugins <../plugins.html#community-plugins>`_ for more
    % information.
    % For information on using this method in chained workflows, see `Building Multistep Workflows
    % <../projects.html#building-multistep-workflows>`_.
    %
    %   out = mlflow.run(uri,entry_point,version,parameters,docker_args,experiment_name,experiment_id,backend,backend_config,storage_dir,synchronous,run_id,run_name,env_manager,build_image,docker_auth)
    %
    % Returns: 
    %
    %    :py:class:`mlflow.projects.SubmittedRun` exposing information (e.g. run ID)
    %    about the launched run.
    %
    % Input arguments:
    %
    %    uri
    %        URI of project to run. A local filesystem path
    %        or a Git repository URI (e.g. https://github.com/mlflow/mlflow-example)
    %        pointing to a project directory containing an MLproject file.
    %
    %    entry_point
    %        Entry point to run within the project. If no entry point with the specified
    %        name is found, runs the project file ``entry_point`` as a script,
    %        using "python" to run ``.py`` files and the default shell (specified by
    %        environment variable ``$SHELL``) to run ``.sh`` files.
    %
    %    version
    %        For Git-based projects, either a commit hash or a branch name.
    %
    %    parameters
    %        Parameters (dictionary) for the entry point command.
    %
    %    docker_args
    %        Arguments (dictionary) for the docker command.
    %
    %    experiment_name
    %        Name of experiment under which to launch the run.
    %
    %    experiment_id
    %        ID of experiment under which to launch the run.
    %
    %    backend
    %        Execution backend for the run: MLflow provides built-in support for "local",
    %        "databricks", and "kubernetes" (experimental) backends. If running against
    %        Databricks, will run against a Databricks workspace determined as follows:
    %        if a Databricks tracking URI of the form ``databricks://profile`` has been set
    %        (e.g. by setting the MLFLOW_TRACKING_URI environment variable), will run
    %        against the workspace specified by <profile>. Otherwise, runs against the
    %        workspace specified by the default Databricks CLI profile.
    %
    %    backend_config
    %        A dictionary, or a path to a JSON file (must end in '.json'), which will
    %        be passed as config to the backend. The exact content which should be
    %        provided is different for each execution backend and is documented
    %        at https://www.mlflow.org/docs/latest/projects.html.
    %
    %    storage_dir
    %        Used only if ``backend`` is "local". MLflow downloads artifacts from
    %        distributed URIs passed to parameters of type ``path`` to subdirectories of
    %        ``storage_dir``.
    %
    %    synchronous
    %        Whether to block while waiting for a run to complete. Defaults to True.
    %        Note that if ``synchronous`` is False and ``backend`` is "local", this
    %        method will return, but the current process will block when exiting until
    %        the local run completes. If the current process is interrupted, any
    %        asynchronous runs launched via this method will be terminated. If
    %        ``synchronous`` is True and the run fails, the current process will
    %        error out as well.
    %
    %    run_id
    %        Note: this argument is used internally by the MLflow project APIs and should
    %        not be specified. If specified, the run ID will be used instead of
    %        creating a new run.
    %
    %    run_name
    %        The name to give the MLflow Run associated with the project execution.
    %        If ``None``, the MLflow Run name is left unset.
    %
    %    env_manager
    %        Specify an environment manager to create a new environment for the run and
    %        install project dependencies within that environment. The following values
    %        are supported:
    %        - local: use the local environment
    %        - virtualenv: use virtualenv (and pyenv for Python version management)
    %        - uv: use uv
    %        - conda: use conda
    %        If unspecified, MLflow automatically determines the environment manager to
    %        use by inspecting files in the project directory. For example, if
    %        ``python_env.yaml`` is present, virtualenv will be used.
    %
    %    build_image
    %        Whether to build a new docker image of the project or to reuse an existing
    %        image. Default: False (reuse an existing image)
    %
    %    docker_auth
    %        A dictionary representing information to authenticate with a Docker
    %        registry. See `docker.client.DockerClient.login
    %        <https://docker-py.readthedocs.io/en/stable/client.html#docker.client.DockerClient.login>`_
    %        for available options.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["uri","entry_point","version","parameters","docker_args","experiment_name","experiment_id","backend","backend_config","storage_dir","synchronous","run_id","run_name","env_manager","build_image","docker_auth"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.run(varargin{1:i},pyargs(varargin{i+1:end}));
