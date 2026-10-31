# Tasks Example README

These samples scripts show how a subset of task types can be used.
Call the `run<TaskType>Task.m` scripts to test a given task type.

More generally, the following task types are supported:

* [MATLABBatchTask](#matlabbatchtask)
* [MATLABRuntimeTask](#matlabruntimetask)
* [NotebookTask](#notebooktask)
* [SparkPythonTask](#sparkpythontask)
* [TasksTask](#taskstask)

See also: Documentation/html/JobWorkflow.html

## MATLABBatchTask

Demonstrates the use a MATLAB&reg; desktop Docker&reg; image based cluster to run uncompiled
MATLAB code in batch mode as a task. Use an existing running cluster for faster
responses when testing. The cluster will require access to a MATLAB license manager.
Step through `runMATLABBatchTask.m` to see how the task is created and run.

## MATLABRuntimeTask

Shows the use of a task designed to run standalone binary requiring the MATLAB runtime.
Requires compilation on Linux&reg;. Step through `runMRTTask.m` to see how the task is
created and run. Use an existing running cluster for faster responses when testing.

## NotebookTask

Imports and executes a Python&reg; notebook from a workspace as a notebook rather than a
script. Step through `runNotebookTask.m` to see how the task is created and run.

## SparkPythonTask

Imports and executes a Python script from a workspace as a script rather than a
notebook. Step through `runSparkPythonTask.m` to see how the task is created and
run.

Example to run a script on an existing cluster based on its Id.

```matlab
runSparkPythonTask(cluster='0417-080746-8oy4uhkz')
```

## TasksTask

Task creates a number of dependent tasks that form a task graph. Step through `runTasksTask.m`
to see how multiple tasks are created, linked with dependencies, and executed as
part of a job workflow.
