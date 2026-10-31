# Job Workflows

Databricks&reg; provides different options for
[Job workflows](https://docs.databricks.com/en/jobs/index.html).
This interface supports several workflows, namely:

* MATLAB&reg; batch task
* MATLAB runtime task
* NotebookTask
* SparkPythonTask
* Tasks (task)

The basic recipe for running a task is the following:

1. Create a `databricks.Job` object and add a cluster.
2. Create a Task and set it as a task in the job.
3. Run the job, or schedule it to run later.

Different tasks have different attributes and options, and simple examples are
provided below. Corresponding examples can be found in `Software/MATLAB/examples/Tasks`.

## Creating a Job object

A `databricks.Job` object is used to run one or more `Tasks`. It has several
properties, but typically, as a minimum, has a name and a cluster.

> A cluster can be either an existing cluster by using a `cluster_id`, or a new
> cluster using a databricks.Cluster object. In the latter case the cluster is created
> when the job runs. When testing, using an existing cluster has a much
> faster turnaround time.

```matlab
% Create a cluster object, but do not create the actual cluster - yet
cl = databricks.Cluster;
cl.setNumWorkers(1);
% If compiled MATLAB code is needed on the cluster, the MATLAB runtime must be enabled.
cl.enableMATLABRuntime('enableLogging', true);
% Set a spark version if needed.
cl.spark_version = "17.3.x-scala2.13";
```

> The current cluster Id can be obtained by querying the .databrickscfg file as follows:
> clusterId = databricks.internal.configurationprofile.ConfigFile.getProfileField("cluster_id", profileName="DEFAULT");

Having created this cluster object, a Job can be created:

```matlab
jb = databricks.Job;
jb.name = "my-job-name";
% Assign the cluster to the job
jb.setCluster(cl);

jb.setTask(myTask);

jb.create();
jobRun = jb.runNow();
```

> **Note:** The "Tasks" task type treats clusters differently, see below.

## Creating a task

The following is a description of the various kinds of supported Tasks.

### A MATLAB batch task

A MATLAB batch task runs MATLAB code, which has not been compiled, as a Databricks
job. The cluster running a job must be based on a Docker&reg; image that contains
desktop MATLAB. It may be the same image as used to provide the MATLAB interactive
desktop *on* Databricks, however in this case the GUI is not used and the associated
web proxy tool is not started. If an interactive desktop MATLAB is being used on
the cluster be aware that it will compete for resources with the task.

If creating a cluster from MATLAB, `createDatabricksCluster` can be used:

```matlab
% Create a single node cluster from a Desktop MATLAB docker file
c = createDatabricksCluster("batchCluster", 0, dockerAuthFile="C:\mydir\dockerAuth.json");
```

> For details on docker registry access & authentication see: [Authentication.md](Authentication.md)

Cluster creation will typically take c. 8 minutes, thus if submitting numerous
short-lived jobs it is best to create a cluster and then assign jobs to it.

To create a task that defines MATLAB code to execute, begin by defining the
statement to execute. Typically, this invokes a top-level script that encompasses
the more complex functionality making the statement handling less error prone.
An exit value of non zero returned to Databricks from MATLAB will be cause the job
to fail.

> Previously (pre 7.0.5) some manual escaping of the statement was required depending
> on its content. This is now automatic and statements should not be
> escaped, aside from conventional escaping of single and double quotes
> as normal to yield a valid MATLAB string.

```matlab
statement = "run(""myScriptName""); exit(0)";
% or
statement = 'run("myScriptName"); exit(0)';
```

Optional "pre" and "post" execution Python&reg; commands can be specified. These are
executed before and after the MATLAB statement respectively. For example, this may
be used to interact with PySpark without integrating that functionality directly
into the MATLAB code.

```matlab
preExecPyCmd = 'print("Running preExecPy")';
postExecPyCmd = 'print("Running postExecPy")';
```

Optional "pre" and "post" execution Shell commands can be specified. These are
executed before and after the MATLAB statement respectively. For example, this may
be used for house keeping tasks like moving files outside of the MATLAB code.
Shell commands are appended to a "%sh" magic prefix.

```matlab
preExecShCmd = 'echo "Running preExecSh"';
postExecShCmd = 'echo "Running postExecSh"';
```

> Note that the optional Shell and Python commands run as root in the notebook
> environment where as the MATLAB commands run as the job user, hence permission
> adjustments may be required.

> The username the MATLAB command runs as can be queried at runtime using the
> MW_ACCOUNTNAME environment variable, in the pre-exec, post-exec and MATLAB sections.

The overall order of execution is:

1. preExecPyCmd
2. preExecShCmd
3. MATLAB statement
4. postExecShCmd
5. postExecPyCmd

A temporary file is created and its name can be retrieved from the environment
variable `MW_RESULT_TEMPFILE` This file can be appended to in steps 1,2,4 & 5
along with the results from step 3. The first 5 MB of output can be retrieved
from the job run when the task finishes. Only the output of step 3, the MATLAB
statement, is captured in this file and the returned result, not the pre and post
execution commands. For the pre & post commands see the Notebook URL via the
Databricks UI or the job run return value.

A notebook path can be specified, if not the job's generated notebook will be
saved with a name of the form: `/Users/username@example.com/tmp/MATLABBatchTask-<UUID>.py`.
By default an existing notebook of the same name will be overwritten.
A `/Volumes` path can also be used.

```matlab
notebookPath = "/Workspace/Users/joe@example.com/MATLABBatchTask.py";
```

The `MATLABCommand` argument is that used to specify how MATLAB is launched.
If it is not specified, the command `matlab -batch` is used as a prefix to the
statement. In some specific circumstances, where a preferences directory is required
and provisioned, `matlab -nodesktop -r` can be specified.

>Note that if setting the `MATLABCommand` argument only the Linux&reg; MATLAB startup
>options apply in the case of Databricks.
>See also: [https://mathworks.com/help/matlab/ref/matlablinux.html](https://mathworks.com/help/matlab/ref/matlablinux.html)

The `licenseManager` argument is used to specify where MATLAB should get its license.
If specified the `MLM_LICENSE_FILE` environment variable is set to the provided
value in the notebook. If this value is already set in the docker image or cluster
definition it is not required at this point.

If using batch token based licensing for CI/CD workflows then `matlab-batch`
(no space) is used.

Optional base parameters can be passed as a struct. Values must be specified as
scalar text and can be retrieved by the MATLAB code at runtime using:

```matlab
valueString = getenv('structFieldName');
```

Create the task:

```matlab
% Minimal MATLAB task:
t = databricks.MATLABBatchTask('disp("Hello World")');
```

Create the job and assign the task and cluster:

```matlab
jb = databricks.Job;
jb.name = "Example MATLAB batch Job";
jb.setTask(t);
% Assign the cluster to the job
jb.setCluster(<clusterId> or <databricks.Cluster object>);
jb.create();

% Run the job
jobRun = jb.runNow();

output = jobRun.getOutput;

output.notebook_output
  ans = 
    NotebookOutput with properties:
       result: "['Hello world\n']"
    truncated: 0
```

The `notebook_output` field will contain only the first 5 MB characters of the
MATLAB output, during the execution of the notebook the full MATLAB output is
available in a file given by the `MW_RESULT_TEMPFILE` environment variable.
Thus a `postExecShCmd` could be used to copy that file to permanent storage e.g.
in `/Volumes`. Best practice to to keep the MATLAB console output minimal and write
to a `/local_disk0/<username>` or `/tmp` path and then `copyfile()` the result to
permanent storage in MATLAB code. This can typically happen in a wrapper command
that is used to keep MATLAB statement argument minimal.

To see the full list of optional arguments for `MATLABBatchTask`, use:

```matlab
help databricks.MATLABBatchTask
% or
doc databricks.MATLABBatchTask
```

### Run a MATLAB runtime task

A MATLAB runtime task runs compiled MATLAB code as a Databricks job. The cluster
running a job must be based on either:

1. A docker image that contains the MATLAB runtime.
2. A docker image that contains desktop MATLAB.
3. A cluster that used an init script to install the MATLAB runtime at boot.

If creating a cluster from MATLAB `createDatabricksCluster` can be used:

```matlab
% Create a single node cluster from a Desktop MATLAB docker file
c = createDatabricksCluster("batchCluster", 0, dockerAuthFile="C:\mydir\dockerAuth.json");
```

> For details on docker file registry access & authentication see: [Authentication.md](Authentication.md)

Cluster creation will typically take c. 8 minutes, thus if submitting numerous
short-lived jobs it is best to create a cluster and then assign jobs to it.

#### Required Argument

Command:
A scalar string specifying the compiled code to be executed.

#### Optional Named Arguments

arguments:
Arguments passed to the compiled code as a scalar string.
Single quotes in the arguments value will be substituted with '\'' ideally
only double quotes should be used.

notebookPath:
If a notebook path is not provided one is created and used for the
dynamically generated notebook. The Workspace path has the form:
   `/Users/username@example.com/tmp/MATLABRuntimeTask-<UUID>.py`
On completion of the task the file should be deleted. This is not done
automatically.
By default an existing notebook of the same name will be overwritten.
A /Volumes path may also be provided.

If provided the path of the notebook should be an absolute path.

baseParameters:
Optional base parameters can be passed as a struct. Values must be specified
as scalar text and can be retrieved by the MATLAB code at runtime using:
  valueString = getenv('structFieldName');

preExecPyCmd, postExecPyCmd, preExecShCmd and postExecShCmd:
Optional preExecPyCmd, postExecPyCmd, preExecShCmd and postExecShCmd arguments
can be used to add Python code and shell commands to the notebook that are
invoked before and or after the MATLAB code. This may be useful "house keeping"
or invoking other workflows. The order of execution is:

  1. preExecPyCmd
  2. preExecShCmd
  3. Compiled MATLAB command
  4. postExecShCmd
  5. postExecPyCmd

Shell commands are appended to a "%%sh" magic prefix.

A temporary file is created and its name can be retrieved from the environment
variable `MW_RESULT_TEMPFILE` This file can be appended to in steps 1,2,4 & 5
along with the results from step 3.  The first 1 MB of output can be retrieved
from the job run when the task finishes.

mcrRoot:
The path to the root of the MATLAB runtime installation, if set this is used
to build up the LD_LIBRARY_PATH environment variable and set the MCRROOT
environment variable. By default it is expected that this is set in the
Cluster definition or docker file.

ldLibraryPath:
Used to the set the LD_LIBRARY_PATH environment variable, if set this overrides
a value which may have been set based on mcrRoot. By default it is expected
that this is set in the Cluster definition or docker file.

overwriteNotebook:
A logical flag that is true by default, meaning that if the created
notebook will be overwritten if it already exists.

authMethod:
The authentication method to use for REST API calls.

profileName:
The name of the profile to use from the .databrickscfg configuration file.

For details on docker file registry access & authentication see:
[Authentication.md](Authentication.md)

Example:

```matlab
  t = databricks.MATLABRuntimeTask("/Workspace/Users/joe@example.com/myCompiledCode",...
                                 arguments="3.14",...
                                 baseParameters=struct('massLow', '1200', 'massHigh', '1400'),...
                                 notebookPath="/Workspace/Users/joe@example.com/MATLABRuntimeTask.py",...
                                 preExecPyCmd='print("Running preExec Python")',...
                                 postExecPyCmd='print("Running postExec Python")',...
                                 preExecShCmd='echo "Running preExec Shell"',...
                                 postExecShCmd='echo "Running postExec Shell"');

  c = createDatabricksCluster("runtimeTestCluster", 0, dockerAuthFile="C:\myDir\dockerAuth.json");

  jb = databricks.Job;
  jb.name = "my-job-name";

  % Assign the cluster to the job
  jb.setCluster(c);
  
  jb.setTask(t);
  jb.create();
  jobRun = jb.runNow();

  output = jobRun.getOutput
  output = 
    struct with fields:
           metadata: [1×1 databricks.Run]
    notebook_output: [1×1 databricks.datastructures.NotebookOutput]
  output.notebook_output
    ans = 
      NotebookOutput with properties:
         result: "['Input: 3.140000\n', 'Output: 6.280000\n']"
      truncated: 0
```

A license is not required for MATLAB runtime based tasks.

> MATLAB runtime tasks run as root.

### databricks.internal.runMATLABTask

The internal *preview* function `databricks.internal.runMATLABTask()` can be used to
abstract some of the distinction between task types and to automatically create
a cluster based on a docker image.

Examples:

```matlab
jobRun = databricks.internal.runMATLABTask(cluster="1031-081221-u31ejni1", command="/Workspace/Users/joe@example.com/times2", arguments="3.14", ldLibraryPath=ldLibraryPath)

jobRun = databricks.internal.runMATLABTask(cluster="1031-081221-u31ejni1", statement='disp("Hello World"); exit(0)', licenseManager="27000@10.0.0.4")
```

See also: `doc databricks.internal.runMATLABTask`.

### NotebookTask

A `NotebookTask` will simply run a Notebook on a cluster. It can be run on an existing cluster,
or on a job cluster (created for the sole purpose of running a given job/task).

A `NotebookTask` needs at least the path of a notebook to run, and it optionally takes some
additional parameters, `base_parameters`.

The parameters can be used for setting widget values in the notebook, if present.
The `base_parameters` should be in the form of a struct, like this:

```matlab
params = struct('ds_limit', '100');
nbTask = databricks.NotebookTask("/Users/user@example.com/myfolder/myNotebook", params);
```

See this example: `Software/MATLAB/examples/Tasks/NotebookTask`.

### Tasks Task

A `Tasks` task is a specific task that runs other tasks, e.g. a task that run a
series of different notebook tasks.

A `Tasks` task is somewhat more complex, but gives more control of the
tasks to be run. When using a `Tasks` task, at a high-level, the user must define:

* The actual tasks to run.
* The clusters on which they can run.
* Any dependencies between the tasks.
* Any libraries that are needed.

```matlab
tasks = databricks.Tasks();

# Create some clusters (don't start them)
for k=1:2
    % Create a cluster key
    cl_keys(k) = "cluster_" + k;

    % Create a cluster
    new_cluster = createDatabricksCluster('', 0, create=false, useMATLAB=false, autoterminationMinutes=0);

    % Add cluster to list of clusters to use
    tasks.addJobCluster(cl_keys(k), new_cluster);
end

% Add the tasks
% TT is a list with 4 different tasks (any permissible type)
tasks.addTask(TT(1), "t1", "job_cluster_key", cl_keys(1));
tasks.addTask(TT(2), "t2", "job_cluster_key", cl_keys(2));
tasks.addTask(TT(3), "t3", "job_cluster_key", cl_keys(3), "depends_on", "t1");
tasks.addTask(TT(4), "t4", "job_cluster_key", cl_keys(4), "depends_on", "t2");
```

A simple example running several of the notebooks from the previous example can be
found here: `Software/MATLAB/examples/Tasks/TasksTask`.

### SparkPythonTask

A `SparkPythonTask` simply runs a Python file with a Spark&trade; operation. It needs a parameter
for the `python_file` and zero or more `parameters`. The latter is a string or an array of
strings, and can be retrieved as command line arguments in the Python file executed.

```matlab
task = databricks.SparkPythonTask(...
    python_file="/Volumes/<some_path>/mypythonfile.py", ...
    parameters=string(["foo", "bar"]));
```

A simple example can be found here:
`Software/MATLAB/examples/Tasks/SparkPythonTask`.

## Storing files on Databricks

The different examples here assume that the user can store and/or access
different kinds of files and artifacts on Databricks. Jar-files, Wheel-files,
Notebooks, Python-files, and maybe different data files too.

This will not be described in any detail here, but is partly used in the
example files mentioned here.

The Databricks portal can be used both for uploading and installing files.
The Databricks Support package also has different functions and classes for
interacting with the resources. Documentation on the different formats can
be found in the [Working with files](WorkingWithFiles.md)
section.

### References

* For more information on job submission see: [https://docs.databricks.com/jobs.html](https://docs.databricks.com/jobs.html).
* For more information on the MATLAB RDD interface see: [https://www.mathworks.com/help/compiler/spark/matlab.compiler.mlspark.rdd-class.html](https://www.mathworks.com/help/compiler/spark/matlab.compiler.mlspark.rdd-class.html)

[//]: # "Copyright 2020-2026 The MathWorks, Inc."
