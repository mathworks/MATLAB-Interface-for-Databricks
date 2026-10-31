function varargout = create_experiment(varargin)
    %CREATE_EXPERIMENT Create an experiment.
    %
    %   out = mlflow.create_experiment(name,artifact_location,tags)
    %
    % Returns: 
    %
    %    String ID of the created experiment.
    %    .. code-block:: python
    %       :test:
    %       :caption: Example
    %       import mlflow
    %       from pathlib import Path
    %       # Create an experiment name, which must be unique and case sensitive
    %       experiment_id = mlflow.create_experiment(
    %           "Social NLP Experiments",
    %           artifact_location=Path.cwd().joinpath("mlruns").as_uri(),
    %           tags={"version": "v1", "priority": "P1"},
    %       )
    %       experiment = mlflow.get_experiment(experiment_id)
    %       print(f"Name: {experiment.name}")
    %       print(f"Experiment_id: {experiment.experiment_id}")
    %       print(f"Artifact Location: {experiment.artifact_location}")
    %       print(f"Tags: {experiment.tags}")
    %       print(f"Lifecycle_stage: {experiment.lifecycle_stage}")
    %       print(f"Creation timestamp: {experiment.creation_time}")
    %
    % Input arguments:
    %
    %    name
    %        The experiment name, must be a non-empty unique string.
    %
    %    artifact_location
    %        The location to store run artifacts. If not provided, the server picks
    %        an appropriate default.
    %
    %    tags
    %        An optional dictionary of string keys and values to set as tags on the experiment.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["name","artifact_location","tags"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.create_experiment(varargin{1:i},pyargs(varargin{i+1:end}));
