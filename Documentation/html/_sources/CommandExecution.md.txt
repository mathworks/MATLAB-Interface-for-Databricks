# Command Execution

The Command Execution API allows execution of Python&reg;, Scala&reg;, SQL, or R commands
on running Databricks&reg; Clusters.

For more details see: [https://docs.databricks.com/api/workspace/commandexecution/](https://docs.databricks.com/api/workspace/commandexecution/).

## Create an execution context

Before executing a command a `contextId` must be obtained

```matlab
commandExecution = databricks.CommandExecution;
createRequest = databricks.datastructures.commandexecution.CreateRequest;
createRequest.clusterId = "1117-171925-4ipnoi3i";
createRequest.language = databricks.datastructures.commandexecution.Language.python;
createResponse = commandExecution.create(createRequest);
if isa(createResponse, 'databricks.datastructures.commandexecution.ErrorResponse')
    error("Context creation failed:\n  %s", createResponse.error);
else
    contextId = createResponse.id;
end
```

## Check context status

One can check the status of a context using:

```matlab
commandExecution = databricks.CommandExecution;
contextsStatusResponse = commandExecution.contextsStatus(clusterId, contextId);
contextsStatusResponse.status
```

`status` is an enumeration of type: `databricks.datastructures.commandexecution.ContextsStatus`
with values `Error`, `Running` or `Pending`.

## Executing a command

```matlab
executeRequest = databricks.datastructures.commandexecution.ExecuteRequest;
executeRequest.clusterId = clusterId;
executeRequest.contextId = contextId;
executeRequest.command = "print Hello world";
executeRequest.language = databricks.datastructures.commandexecution.Language.python;
executeResponse = commandExecution.execute(executeRequest);
if isa(executeResponse, 'databricks.datastructures.commandexecution.ErrorResponse')
    error("Execute failed:\n  %s", executeResponse.error);
else
    commandId = executeResponse.id;
end
```

## Check an execution status

The state of an executions can be checked as follows:

```matlab
commandExecution = databricks.CommandExecution;
commandsStatusResponse = commandExecution.commandsStatus(clusterId, contextId, commandId);
commandsStatusResponse.status
```

`status` is an enumeration of type `databricks.datastructures.commandexecution.CommandsStatusStatus`
with possible values: `Cancelled`, `Cancelling`, `Error`, `Finished`, `Queued` and `Running`.

## Cancelling an execution

A running execution can be cancelled as follows:

```matlab
cancelRequest = databricks.datastructures.commandexecution.CancelRequest;
cancelRequest.clusterId = clusterId;
cancelRequest.contextId = contextId;
cancelRequest.commandId = commandId;
cancelResponse = commandExecution.cancel(cancelRequest);
```

## Destroying a context

When no longer needed, an execution context should be destroyed as follows:

```matlab
commandExecution = databricks.CommandExecution;
destroyRequest = databricks.datastructures.commandexecution.DestroyRequest;
destroyRequest.clusterId = clusterId;
destroyRequest.contextId = contextId;
destroyResponse = commandExecution.destroy(destroyRequest);
```

## Higher-level functionality

For examples of how this API can be used to build higher-level functionality,
for example executing system/shell commands, see:

* `/Software/MATLAB/app/system/+databricks/+internal/+commandexecution/executePythonCommand.m`
* `/Software/MATLAB/app/system/+databricks/+internal/+commandexecution/executePythonSubprocess.m`
* `/Software/MATLAB/app/system/+databricks/+internal/+commandexecution/waitForCommandFinished.m`
* `/Software/MATLAB/app/system/+databricks/+internal/+commandexecution/waitForContextRunning.m`

> Note these are internal functions and subject to change or removal without notice.

[//]: #  (Copyright 2023 The MathWorks, Inc.)
