# none sub flavor

To save or log MATLAB/Simulink code and data into a MATLAB flavor MLflow model use {func}`mlflow.matlab.save_model` or {func}`mlflow.matlab.log_model` with the `MATLABFiles` option. The option accepts a string array of separate files as well as directories. For example to save a model:

```matlab
% Save two specific files and an entire directory into a MATLAB flavor MLflow model.
% When saving also specify Path to indicate where to save the model
mlflow.matlab.save_model(MATLABFiles=["someFunction.m","/some/path/file.m","/some/directory"], ...
    Path="/work/models/myModel")
```

Or to log a model:

```matlab
% In order to log a model in a specific run in a specific experiment, first set an experiment
py.mlflow.set_experiment("My MATLAB Experiment")
% And start a run
py.mlflow.start_run()
% Then log the model, when logging a model, Path is not required
mlflow.matlab.log_model(MATLABFiles=["someFunction.m","/some/path/file.m","/some/directory"])
% End the run
py.mlflow.end_run()
```

In order to be able to use a saved model in MATLAB again, use {func}`mlflow.matlab.load_model` to first (if needed) download or copy the model locally, and then obtain the path of the local model. Then for example either `cd` to that path or use `addpath`/`genpath` to add this path to the MATLAB path.

```matlab
% Load a model
p = mlflow.model.load_model("/work/models/myModel")
% Add the directory structure to the MATLAB path such that the code can be run in MATLAB
addpath(genpath(p))
```

With a local model this will typically just return the local location where the MATLAB code and data is already located. For a model on a remote tracking server, the model will be downloaded to a temporary local location and then this location is returned. To download a remote model to a specific local location (or to make a copy of a local model), specify this desired location as second input:

```matlab
% Download model to a specific location
p = mlflow.model.load_model("models:/someModel/1","/work/models/someModel")
% In this example go to that directory instead of adding it to the MATLAB path
cd(p)
```

[//]: #  (Copyright 2025-2026 The MathWorks, Inc.)