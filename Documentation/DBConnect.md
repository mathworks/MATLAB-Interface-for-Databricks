# Databricks Connect Setup

## Introduction

Databricks&reg; Connect enables access to many Spark&trade; API calls from within MATLAB&reg;.
The MATLAB interface uses the Databricks Connect Python&reg; library when doing so.

> Version 17.3 is the first "GA" release of Databricks Connect and is strongly recommended.

### Using MATLAB on Databricks

If using [MATLAB on Databricks](https://github.com/mathworks-ref-arch/matlab-on-databricks),
Databricks Connect can be pre-configured using the client version included in the
Databricks Runtime of that cluster. No additional setup is required.
For details see: [Use Spark in MATLAB](https://github.com/mathworks-ref-arch/matlab-on-databricks/guides/PSP%20docs/SparkInMATLAB.md)

### Connecting remotely (i.e. MATLAB not on Databricks)

The setup process requires a compatible Python environment with the `databricks-connect`
package installed. The compatibility between this Python environment and the Databricks
cluster version is critical. If connecting to Databricks clusters with different
Spark versions multiple configured Python versions are required.

> The Python environment used can be altered using MATLAB's `pyenv` command.
> MATLAB supports using only one version of Python at a time.
> See: [https://www.mathworks.com/help/matlab/ref/pyenv.html](https://www.mathworks.com/help/matlab/ref/pyenv.html)

The [Setup](Setup.md) process typically:

* Determines if Python & pip are installed.
* Builds a Python virtual environment(s) for Databricks Connect.
* Downloads the required Databricks Connect libraries.

There are scenarios whereby it may be necessary to rerun this setup process
or further customize it. The `Software/MATLAB/setup` function can be rerun and
unrelated steps can be skipped. Alternatively, the `matlab.databricks.setup.configureDBC`
function can be called directly.

> Python virtual environments are preferred as they isolate changes to the Python
> installation, but are not required if an externally configured environment is used.

> The `.whl` files for the Databricks Connect Python library are *no* longer included
> in the package and must be downloaded during setup. This change reflects the
> increasing trend towards local dependency supply chain management for security
> reasons. The download can be from the public internet or a specified local package
> repository.

> The licenses for the Databricks-Connect Python package and its
> dependencies can be found in: `3rdPartyLicenses/databricks-connect`.

Serverless mode is supported by more recent releases of the Databricks Connect
Library and cluster runtime.

Typically using the latest release of Databricks Connect is recommended where
possible based on Cluster versions.

### Requirements

* Python 3.10, 3.11 and or 3.12.
* Ideally Python virtual environment support, Python 3 typically supports `virtualenv` or `venv` as a built in module.
* pip package manager, pip is typically available in Python 3 installations.
* Access to a public Python package repository (e.g., PyPI) or a configured private package repository.

In general Databricks require that the Databricks Connect version matches that of the
Databricks cluster runtime version being connected to and use the same Python version
on the client as the runtime.  The relationship for LTS versions is described below.

| Databricks Runtime (LTS) | Required Python |
| ------------------------ | --------------- |
|         17.3             |      3.12       |
|         16.4             |      3.12       |
|         15.4             |      3.11       |
|         14.3             |      3.10       |
|         13.3             |      3.10       |

For MATLAB Python version compatibility see:

* [SupportMatrix.md](SupportMatrix.md)
* [https://www.mathworks.com/support/requirements/python-compatibility.html](https://www.mathworks.com/support/requirements/python-compatibility.html)

Databricks Connect version compatibility with compute types and Python versions:

| Databricks Connect version     | Compute type          | Compatible Python version |
| ------------------------------ | --------------------- | ------------------------- |
| 18.0 - 18.1                    | Cluster               | 3.12                      |
| 18.0                           | Serverless version 5  | 3.12                      |
| 17.2 - 17.3                    | Serverless version 4  | 3.12                      |
| 17.2 - 17.3                    | Cluster               | 3.12                      |
| 16.4.1 - <17                   | Serverless version 3  | 3.12                      |
| 16.4                           | Cluster               | 3.12                      |
| 15.4.10 - <16                  | Serverless version 2  | 3.11                      |
| 15.4                           | Cluster               | 3.11                      |
| 14.3                           | Cluster               | 3.10                      |
| 13.3                           | Cluster               | 3.10                      |

See: [https://docs.databricks.com/aws/en/dev-tools/databricks-connect/requirements](https://docs.databricks.com/aws/en/dev-tools/databricks-connect/requirements)

## Configuration

`matlab.databricks.setup.configureDBC` has the following optional arguments:

| Argument         | Description |
| ---------------- | ----------- |
| dbcVersions      | Databricks Connect versions to support. A corresponding  directory is expected in `Software/MATLAB/Connect` e.g. `Software/MATLAB/Connect/15.4/` By default the supported versions in `Software/MATLAB/Connect` are used. |
| alternativeRepo  | URL for an alternative library source, e.g. Artifactory&reg;. |
| pythonExecutable | Version argument for `pyenv` command to specify the Python used to create virtual environments. Can be used if Python is not found on the system path. |
| verbose          | Produce additional output. Default: true. |

During [setup](Setup.md), MATLAB will detect at most one Python version, e.g. 3.11,
if installed. Consequently, if all listed Databricks Connect versions are required,
changing the Python version is also required. If doing so, one can do one of the following:

1. Update the system path to point to an alternative Python version, restart MATLAB
in that context, and rerun setup to detect it etc. skipping non Databricks Connect steps.
2. Use the `pythonExecutable` argument and call `matlab.databricks.setup.configureDBC`
directly.
3. Use MATLAB's `pyenv` command to point to an alternative Python and rerun `setup`.

> The matlab `pyenv` command can be used to examine and control which Python environment
> is being used by MATLAB. Note that if the environment is changed e.g to select a
> virtual environment this change is persistent until reset with `pyenv`.

The Databricks Connect library and its dependencies are no longer included in the
package. The required packages as specified by the version specific `requirements.txt`
file should be downloaded inline with organizational policy and security requirements.
If `Python/pip` is configured appropriately the packages can be downloaded automatically.

If `alternativeRepo` argument is set, an alternative source for Databricks Connect
and its dependencies can be used.

> The packages downloaded are specific to a given operating system.

### Python version selection

The `spark = getDatabricksSession()` command assumes that the appropriate Python
Environment has already been configured using MATLAB's `pyenv` command.

```matlab
spark = getDatabricksSession();
```

`doc getDatabricksSession` for more information on additional arguments, e.g.:

```matlab
spark = getDatabricksSession(cluster="1006-200022-cv9r8lwc");
```

### Virtual environment configuration from a shell

Should it be necessary for some reason to manually install the package it
can be done as follows:

```bash
python3 -m venv .venv
source ./.venv/bin/activate
pip install --requirement Software/MATLAB/Connect/<version>/requirements.txt
# e.g. pip install Software/MATLAB/Connect/17.3/requirements.txt
```

Ensure that the `databricks-connect` is the version that will be used on
the cluster.

Make sure to activate the virtual environment from a shell and then start MATLAB
from that shell or configure a MATLAB `pyenv` object to point to the virtual
environment's `python` link.

## Usage

The use of Databricks Connect Spark Session is discussed in: [DBConnectWorkflow.md](DBConnectWorkflow.md).

## macOS

Databricks Connect is not supported on the Apple&reg; Intel&reg; architecture.
A native Apple silicon release of MATLAB is available for R2023b and later.
Thus Databricks Connect can only be used on macOS&reg; with MATLAB R2023b and later.

> Use the `computer('arch')` command to determine the architecture used by a given
> release of MATLAB. A result of `maca64` indicates Apple silicon and `maci64` indicates
> the Intel architecture.

[//]: #  (Copyright 2020-2026 The MathWorks, Inc.)
