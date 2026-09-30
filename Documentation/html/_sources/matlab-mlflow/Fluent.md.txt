# Fluent MATLAB Interface for Tracking

Logging data to runs in MATLAB works pretty much the same as in the [MLflow Python fluent API](https://mlflow.org/docs/latest/tracking.html#logging-data-to-runs). As a matter of fact the MATLAB interface wraps this MLflow Python API and may even return Python objects in places or throw Python style errors if an error occurs.

For a full overview of the MLflow fluent API functions which are supported through this package in MATLAB directly, see [](./FluentAPI.rst).

```{note}
There is no Automatic MLflow Logging in MATLAB. Include explicit calls to {func}`mlflow.set_experiment`, {func}`mlflow.start_run`, {func}`mlflow.log_param`, {func}`mlflow.log_metric`, etc. in code to log the desired information.
```

To log to a remote server, ensure the [correct tracking URI has been configured](./InstallationPython.md#mlflow-tracking-servers).

## Examples

```matlab
% Start a new experiment or select an existing experiment named myExperiment
mlflow.set_experiment("myExperiment")
% Create a new unnamed run
mlflow.start_run()
% Log a parameter named Gain with value 3.14
mlflow.log_param("Gain",3.14)
% End the run
mlflow.end_run();
% Create another run, named this time
mlflow.start_run(run_name="myRun")
% Log a metric named Score with value 42
mlflow.log_metric("Score",42)
% End the run
mlflow.end_run();
```

## Advanced usage of the Python API directly

Since the MATLAB MLflow fluent interface is based on the Python MLflow fluent interface, and thus also [requires the Python MLflow package to have been installed and configured for MATLAB](./InstallationPython.md), you do also have access to the _entire_ MLflow Python package from within MATLAB through its [external language interface to Python](https://www.mathworks.com/help/matlab/call-python-libraries.html). Meaning that for example {func}`mlflow.log_metric` can be called in MATLAB as either {func}`mlflow.log_metric` (to call it through the MATLAB interface) or {py:func}`py.mlflow.log_metric <mlflow.log_metric>` (to call the Python function _directly_). Now this is of course not that interesting for functions which are available in both interfaces, but it _can_ be useful if you need functionality which is available in the Python SDK but which is not directly exposed through the MATLAB interface provided in this package.

You may also need to make use of this interface to be able to provide the right Python input types to some of the functions which are available in the MATLAB interface, see for example the [logging and image example](#example---logging-an-image) below.

### Example - log metrics in batch

Suppose you already have a function which trains a model and which then apart from the model itself, also returns a table with metrics of how the training progressed over time:

```matlab
[model, metrics] = trainMyModel(data);
```

To log these metrics in MLflow you could then go into this function and modify it to log the metrics as you go, but you could also consider logging all the metrics in one big batch after the fact; which is what we will do in this example. This can be done with the {py:meth}`log_batch <mlflow.client.MlflowClient.log_batch>` method of the {py:class}`mlflow.client.MlflowClient` in the MLflow Python SDK but for which there is no direct MATLAB interface in this package. 

Now first of all, we do want to log these metrics as part of a run in an experiment, so we will want to set the experiment and start a run. Since you can in fact mix the MATLAB interface with the direct Python interface, in this example we use the MATLAB interface for that part:

```matlab
mlflow.set_experiment("Batch Log Example");
mlflow.start_run();
```

Then we call our training function:

```matlab
[model, metrics] = trainMyModel(data);
```

And now let's suppose that `metrics` is a table with columns `iteration`, `timestamp` and `accuracy`. We could then first turn this table into a Python list of {py:class}`MLflow Metric objects <mlflow.entities.Metric>` (as that is what {py:meth}`log_batch <mlflow.client.MlflowClient.log_batch>` expects as input).

```matlab
% Start an empty list
m = py.list;
% Go through all the rows in the table
for i=1:height(metrics)
    % Create a new Metric instance with all the values set correctly and
    % append it to the list
    m.append(py.mlflow.entities.Metric( ...
        key="Accuracy", ...
        value=metrics.accuracy(i), ...
        step=int32(metrics.iteration(i)), ...
        timestamp=int64(metrics.timestamp(i)) ...
    ));
end
```

After this an {py:class}`mlflow.client.MlflowClient` instance can be created and its {py:meth}`log_batch <mlflow.client.MlflowClient.log_batch>` method can be called with the list of metrics and the current run ID as input:

```matlab
mlflowClient = py.mlflow.client.MlflowClient();
mlflowClient.log_batch(mlflow.active_run().info.run_id, m);
```

Finally, the run should be ended:

```matlab
mlflow.end_run();
```

### Example - logging an image

The MATLAB interface _does_ supply the {func}`mlflow.log_image` function, _however_ the image must be provided in the form of an {py:class}`mlflow.Image` which is not directly available in the MATLAB interface (or a {py:class}`numpy.ndarray` or an {py:class}`PIL.Image.Image`). So we will need to use the Python interface to create such an {py:class}`mlflow.Image` instance first. For example:

```matlab
% Set an experiment and start a run
mlflow.set_experiment("Image Example");
mlflow.start_run();

% Create the mlflow.Image instance based on myImage.png from disk
% we will need the direct Python interface for this so the command
% starts with py.
im = py.mlflow.Image('myImage.png');
% We can then use log_image from the MATLAB interface
mlflow.log_image(im,key="MyImage");

% End the run
mlflow.end_run();
```

[//]: #  (Copyright 2024-2026 The MathWorks, Inc.)
