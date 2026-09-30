# Workspaces API

The Workspace API allows the listing, importing, exporting, and deletion of
notebooks and directories. The maximum allowed size of a request to the
Workspace API is 500MB. For further details see [https://docs.databricks.com/dev-tools/api/latest/workspace.html](https://docs.databricks.com/dev-tools/api/latest/workspace.html.)

Note that notebooks can be executed using the ```NotebookTask``` class.

Workspaces to be imported or exported can have the following formats:

* SOURCE
* HTML
* JUPYTER
* DBC

Where the format is SOURCE then the language value can one of the following:

* SCALA
* PYTHON
* SQL
* R

>> See [Libraries](LibraryAPI.md) for information on installing notebook scoped libraries using `%pip`.

## Sample usage

The following example shows sample usage of the Workspace API.

## Create a workspace object

Create a Databricks&reg; Workspace object

```matlabsession
>> ws = databricks.Workspace()

ws = 

  Workspace with properties:

    username: 'user@example.com'
```

## List existing objects and directories in a workspace

Use the object to list existing objects and directories

```matlabsession
>> wsArray = ws.list(sprintf('/Users/%s',ws.username))

wsArray = 

  1x42 ObjectInfo array with properties:

    object_type
    object_id
    path
    language
```

## Examine objects (in this case a notebook)

Examining the output:

```matlabsession
>> wsArray(10)

ans = 

  ObjectInfo with properties:

    object_type: NOTEBOOK
      object_id: 2181061688109446
           path: "/Users/user@example.com/foo"
       language: "PYTHON"
```

## Fetch the status of an object/directory

The getStatus method will return the status of the object

```matlabsession
% Use getStatus to check on the same entry
>> ws.getStatus('/Users/user@example.com/foo')

ans = 

  struct with fields:

    object_type: 'NOTEBOOK'
           path: '/Users/user@example.com/foo'
       language: 'PYTHON'
      object_id: 2181061688109446
```

## Export the content of the notebook to examine it

```matlabsession
>> result = ws.export('/Users/user@example.com/myScript', 'SOURCE', false)

result =
  struct with fields:
      content: '# Databricks notebook source print("Hello World")'
    file_type: 'py'
```

## Import a notebook from a string

Create a new Python&reg; notebook using uppercase HELLO WORLD
Confirm its creation using the Databricks Workspace

```matlab
ws.import('path', '/Users/joe@example.com/MYSCRIPT', 'format', 'SOURCE',...
          'language', 'PYTHON', 'content', 'print("HELLO WORLD")',...
          'overwrite', true);

% Delete the initial notebook
recurse = true;
ws.delete('/Users/joe@example.com/MYSCRIPT', recurse)
Deleted object or directory: /Users/joe@example.com/MYSCRIPT
```

## Importing a notebook from a file

The above example shows how to import a Workspace using a *content* argument to
specify the commands as a scalar string or character vector. For short examples as
above or programmatically generated content this may be useful however more typically
a Workspace will be imported from an existing file. The import command to do so is
similar as shown:

```matlab
ws.import('path', '/Users/joe@example.com/MYSCRIPT', 'format', 'SOURCE',...
          'language', 'PYTHON', 'file', '/myPath/myFile.py',...
          'overwrite', true);
```

## Create a job to run a notebook

See [Jobs API](JobsAPI.md) for full details of how to submit a job to Databricks.
When running the key difference is setting the task to type ```databricks.NotebookTask```
and adding the ```notebook_path``` argument.

```matlab
% Find the cluster on which the job is to be run, e.g.
cl = databricks.Cluster.findByName('myCluster');

% Create the job
job = databricks.Job;
% Assign an uniquely identifiable semi-random name
job.name = ['job-', char(java.util.UUID.randomUUID)];
% Specify to run the job on the existing cluster
job.setCluster(cl.cluster_id);

% Optionally configure notifications
job.setJobEmailNotifications('joe@example.com');

% Add the notebook as a task to the job
task = databricks.NotebookTask;
task.notebook_path = '/Users/joe@example.com/MYSCRIPT';
job.setTask(task);

% Run the job
job.create();
run = job.runNow();
job.refresh();
```

## Retrieve the job result & view the notebook

Wait for the job to enter a terminated state, i.e. the job has completed. This uses
the `run` returned by `runNow()` and calls `get()` on it to refresh its state. When terminated ```run.state.life_cycle_state``` will equal ```'TERMINATED'```.

```matlab
% As long as state is not TERMINATED yet
while ~strcmp(run.state.life_cycle_state,'TERMINATED')
    % Wait for a second
    pause(1);
    % And refresh the run to get an updated state
    run = run.get();
end
```

If the notebook has a return value it can be retrieved by:

```matlab
returnVal = run.getOutput();
disp(returnVal.notebook_output.result);
```

If the result field is not present, update the notebook, at the end use `dbutils.notebook.exit` to return a value, e.g.:

```python
dbutils.notebook.exit("myReturnValue")
```

The notebook itself can be viewed by exporting the run to HTML, writing it to a file and then viewing the file:

```matlab
% Export the run result
result = run.export()
% Create a temporary HTML file and write the HTML content to it
tmpName = [tempname,'.html'];
fileID = fopen(tmpName,'w');
% Write the HTML
nbytes = fprintf(fileID,'%s',result.views.content);
fclose(fileID);
% Open the file in the system web browser
web(tmpName, '-browser');
```

## References

Please see:

* https://docs.databricks.com/dev-tools/api/latest/workspace.html

[//]: #  (Copyright 2020-2024 The MathWorks, Inc.)
