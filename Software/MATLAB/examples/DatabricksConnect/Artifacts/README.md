# Databricks Connect with Compiled MATLAB

This example demonstrates the use of compiled MATLAB&reg; code with Databricks&reg; Connect,
whereby the compiled code executes remotely on the Databricks Cluster. The cluster
must be equipped with the MATLAB runtime, the release of which must match the release
of MATLAB used in the compilation step. The scale/parallelism at which code executes
is determined by Spark&trade;.

When passing code for execution via Databricks Connect, aside from the Spark APIs
themselves, this code/binaries is referred to as an *Artifact* by Databricks.
The format of the file is a `.zip` archive containing the compiled MATLAB code.
The compilation process is the same as when creating a `.whl` library for use with
a Python&reg; notebook. Both forms are produced automatically.

## Working directory

Begin by copying the example to a temporary working directory:

```matlab
workDir = fullfile(tempdir, "Artifacts");
copyfile(databricksRoot("examples", "DatabricksConnect", "Artifacts"), workDir)
cd(workDir)
```

## Python environment

When using artifacts with Databricks Connect the underlying Python Libraries must
use an in process `pyenv` that is, `ExecutionMode = "InProcess"` e.g.:

```matlab
pe = pyenv(Version="c:\myPython\venv\Scripts\pythonw.exe", ExecutionMode = "InProcess")
```

See also: [https://www.mathworks.com/help/releases/R2026a/matlab/ref/pyenv.html](https://www.mathworks.com/help/releases/R2026a/matlab/ref/pyenv.html)

## Session management

A Databricks Connection limitation means that once an artifact has been added to
a session it cannot be changed or removed. During development and testing this is
inconvenient when code is required to be updated. A suggested work around is to
create a new spark session for a new version of the artifact.

Ordinarily the `getDatabricksSession` function will reuse an existing session if
one exists, to avoid this use the `forceNewSession=true` named argument. Note that
the server-side data associated with a previous session will not be available in
this new session and will have to be recreated as needed. A spark session can be
closed using the normal MATLAB `clear` functionality.

If the same MATLAB variable is reused to represent the Spark session, and it is the
only reference to this session e.g. `spark = ...`, creating a new session will
automatically close the previous session.

## Execution

Using the debugger step through the `runDBCArtifacts.m` file and helper functions
to see how artifacts can be used as User Defined Functions.

## Clean up

Clean up by removing the temporary working directory:

```matlab
[status,msg,msgID] = rmdir(workDir)
```
