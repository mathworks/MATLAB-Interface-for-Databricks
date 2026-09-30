# Installation - Python based Interfaces

```{important}
This installation step is only required when wanting to work with the [fluent mlflow interface in MATLAB](./Fluent.md) and/or the [MATLAB flavor](./matlab_flavor/Introduction.md). It is not necessary to perform these steps when you only want to work with the [RESTful interface to mlflow](./QuickStart.md).
```

```{note}
When working with this mlflow package as part of another MathWorks Product Support Package like "MATLAB Interface *for Databricks*" or "MATLAB Interface *for Azure Machine Learning*" then under certain circumstances, your environment may already have been pre-configured with Python and the `mlflow` package, in which case these steps do _not_ have to be repeated. This is for example true when working with "MATLAB as Custom Application on AzureML".
```

## Requirements

*   Python 3.10 (or newer) environment with:
    *   mlflow
    *   matlab-mlflow (this package)
    *   onnx (if working with ONNX sub flavor)

## Python Environment

A `requirements.txt` and `pyproject.toml` are included inside the `Software/Python` directory which can help with setting up such a Python (virtual) environment with the correct tools. Instructions are included below on how to setup the environment using [Python Virtual Environment (venv)](#python-virtual-environment-venv) or alternatively using [uv](#uv). You are of course also free to setup this environment in any other way you like (conda, virtualenv, system package manager, etc.)

### uv

Apart from managing virtual environments and Python packages, [uv](https://docs.astral.sh/uv/) can also manage Python versions itself and create virtual environments with/for specific Python versions. For most `uv` commands a `-p <version>` option can be added, e.g. `-p 3.10` or `-p 3.12` to target Python version 3.10 or 3.12 respectively. In the examples below `-p 3.10` is used but this can be changed. Make sure to choose a Python version which is compatible with the MATLAB release(s) you want to work with, see:

<https://www.mathworks.com/support/requirements/python-compatibility.html>

#### Linux

To create a virtual environment `.venv` inside the `Software/Python` directory with the correct packages for the project using `uv`, use:

```console
$ cd Software/Python
$ uv sync -p 3.10
```

#### Windows

To create a virtual environment `.venv` inside the `Software/Python` directory with the correct packages for the project using `uv`, use:

```doscon
c:\work\matlab-mlflow> cd Software\Python
c:\work\matlab-mlflow\Software\Python> uv sync -p 3.10
```

### Python Virtual Environment `venv`

When working with Python standard `venv` module to create a virtual environment you first need to install a particular Python (with `venv` module) version and then you create the virtual environment using that Python version. Make sure to install a Python version that is compatible with the MATLAB version(s) you want to work with, see:

<https://www.mathworks.com/support/requirements/python-compatibility.html>

On Linux you will typically install Python using your system package manager, on Windows you typically download an installer from <https://python.org>. If your Linux distro version does not have a standard package for the Python version you want/need or if you cannot find a Windows installer for the right version, consider using a tool like [uv](#uv) which can also download and manage Python versions for you.

#### Linux

To create a virtual environment `.venv` inside the `Software/Python` directory, use:

```console
$ cd Software/Python
$ python3.10 -m venv .venv
```

```{note}
We explicitly call `python3.10` here and not just `python` to ensure we indeed create a virtual environment for that Python version specifically and not using any other Python version which may have been on `PATH`.
```

And then install the required packages by activating the environment:

```console
$ source .venv/bin/activate
```

and then using `pip`:

```console
$ pip install -r requirements.txt
```

#### Windows

To create a virtual environment `.venv` inside the `Software/Python` directory, use:

```doscon
c:\work\matlab-mlflow> cd Software\Python
c:\work\matlab-mlflow\Software\Python> %LOCALAPPDATA%\Programs\Python\Python310\python.exe -m venv .venv
```

> _Assuming CPython 3.10 has been installed in its default (user-based) location. If it (or a different version) has been installed elsewhere, replace the path `%LOCALAPPDATA%\Programs\Python\Python310` as appropriate._

And then install the required packages by activating the environment:

```doscon
c:\work\matlab-mlflow\Software\Python> .venv\Scripts\activate
```

and then using `pip`:

```doscon
c:\work\matlab-mlflow\Software\Python> pip install -r requirements.txt
```



## MATLAB Configuration

To add the relevant MATLAB code to your MATLABPATH inside MATLAB, use `startup.m` from the `Software/MATLAB` directory:

```matlabsession
% For example, cd to the right directory and run startup
>> cd Software/MATLAB
>> startup
% Or for example use run with the absolute path of the script
>> run('/work/matlab-mlflow/Software/MATLAB/startup.m')
```

Further, to configure MATLAB's Python Interface to work with the (virtual) environment which contains the [required Python packages](#requirements), use the [`pyenv`](https://www.mathworks.com/help/matlab/ref/pyenv.html) function:

```matlabsession
% For example on Linux
>> pyenv('Version','/work/matlab-mlflow/Software/Python/.venv/bin/python')
% Or on Windows
>> pyenv('Version','c:\work\matlab-mlflow\Software\Python\.venv\Scripts/pythonw.exe')
```

_This is a persistent setting and does not have to be repeated every MATLAB session._


## MLflow Tracking servers

Both the Fluent interface and the MATLAB MLflow flavor support working with MLflow (compatible[^1]) Tracking servers. This is supported in the same way as in other Python MLflow packages, see:

<https://mlflow.org/docs/latest/self-hosting/architecture/tracking-server/#logging_to_a_tracking_server>

So that is by either setting environment variable `MLFLOW_TRACKING_URI` before using the package or by explicitly calling `mlflow.set_tracking_uri` in your MATLAB code.

```{hint}
In some environments `MLFLOW_TRACKING_URI` may have been automatically set for you. E.g. if you are working on AzureML Compute Instances, Microsoft will automatically set it to point the Model storage of your AzureML Workspace.
```

[^1]: For example, Databricks and Azure Machine Learning offer experiment and model tracking through a MLflow _compatbile_ interface. I.e. they do not literally use [_the_ MLflow Tracking Server](https://mlflow.org/docs/latest/self-hosting/architecture/tracking-server/) but they _do_ offer endpoints which are fully API compatible with MLflow and are therefore also compatible with this package.

### Self-signed HTTPS servers

If you are working with a server accessed over HTTPS and the server is using a self-signed certificate you can set environment variable `MLFLOW_TRACKING_SERVER_CERT_PATH` and point it to the (PEM encoded) certificate of the server to allow the MATLAB Fluent interface to work with it.

```{note}
This must be set _before_ interacting with _any_ of the functionality in the Fluent- or MATLAB flavor interfaces. Setting the variable after the interfaces have already been used in a MATLAB session will have no effect. Restart MATLAB as appropriate.
```

### Server authentication

If your server requires username/password or token authentication, configure environment variables `MLFLOW_TRACKING_USERNAME` and `MLFLOW_TRACKING_PASSWORD`, or `MLFLOW_TRACKING_TOKEN` respectively.

If your server requires a custom authentication plugin, install the plugin in the [Python environment as used by MATLAB](#python-environment) and provide any further configurations as documented in the plugin documentation.


[//]: #  (Copyright 2025-2026 The MathWorks, Inc.)