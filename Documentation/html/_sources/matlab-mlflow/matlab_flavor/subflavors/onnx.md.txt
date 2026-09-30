# onnx sub flavor
 
To save an `exportONNXNetwork` compatible Deep Learning Toolbox model, use {func}`mlflow.matlab.save_model` or {func}`mlflow.matlab.log_model` with the `Network` option:

```matlab
% Save a network, specify the output location
mlflow.matlab.save_model(Network=net, Path="/work/models/mymodel")
```

Or to log a model:

```matlab
% In order to log a model in a specific run in a specific experiment, first set an experiment
py.mlflow.set_experiment("My MATLAB Experiment")
% And start a run
py.mlflow.start_run()
% Then log the model, when logging a model, Path is not required
mlflow.matlab.log_model(Network=net)
% End the run
py.mlflow.end_run()
```

Again, it is possible to additionally specify `MATLABFiles` to include those in the model as well. Such that users who do have MATLAB and Deep Learning Toolbox installed and licensed can also load the original Deep Learning Toolbox network back into MATLAB and use it there.

[//]: #  (Copyright 2025-2026 The MathWorks, Inc.)