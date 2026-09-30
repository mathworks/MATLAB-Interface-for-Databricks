# MATLAB Interface *for MLflow*

This package consists of three interfaces which can be used independently:

1. A fluent MATLAB interface for MLflow tracking based on the fluent interface in the Python MLflow package. Apart from the package itself this interface also requires [Python and the official mlflow Python package](./InstallationPython.md).

2. A MATLAB interface for creating MATLAB flavor MLflow models. This also requires [Python and the official mlflow Python package](./InstallationPython.md). This interface is often used in combination with the fluent MATLAB interface for MLflow tracking, such that you can for example log a MATLAB flavor model as part of a run logged using that interface. 

3. A MATLAB interface for interacting with MLflow tracking servers through their RESTful interface. This interface will work out-the-box when the package has been [installed in MATLAB](./Installation.md).

Note that option 1 and 3 offer similar functionality, so why choose the one over the other?

*   The fluent interface is more convenient to work with, but does require a Python installation. Whereas the RESTful interface is more verbose and requires you to write more code to achieve the same results but it does _not_ require a Python installation and should just immediately work out-of-the-box.
*   The MATLAB flavor feature only works in combination with the fluent tracking interface. I.e. MATLAB flavor MLflow models can be logged as part of a run started with the fluent interface but not with runs as started using the RESTful interface. This is of course only relevant if you want to be able to _log_ models as part of runs. _Saving_ models is always possible independent of any tracking interface.
*   The fluent interface supports working with MLflow (Python based) plugins. For example, if the `azureml-mlflow` package has been installed, the fluent interface can directly work with Azure Machine Learning `azureml://` style MLflow tracking URIs, including authentication. Whereas with the RESTful interface you would have to manually work with the `https://` equivalent and obtain- and configure authentication manually.

Concluding, the fluent interface is easier to work with and provides more features than the RESTful interface and is therefore recommended over the RESTful interfaces _if_ it is indeed possible to setup the Python environment it requires. If it is not possible to- or you prefer not to- setup the Python environment, choose the RESTful interface.

Regardless of the interface, to get started with this package, clone the repository:

```console
$ git clone https://github.com/mathworks-ref-arch/matlab-mlflow.git
```

Then consult [Installation (fluent interface and MATLAB flavor)](./InstallationPython.md) and/or [Installation (RESTful interface)](./Installation.md) for further installation instructions and see the documentation outline below for further information.

```{toctree}
:maxdepth: 2
:caption: Tracking (fluent interface)

Installation and Configuration <InstallationPython>
Fluent
FluentAPI
```

```{toctree}
:maxdepth: 2
:caption: MATLAB Flavor Interface

Installation and Configuration <InstallationPython>
matlab_flavor/Introduction
matlab_flavor/Usage
```

```{toctree}
:maxdepth: 2
:caption: Subflavors
matlab_flavor/subflavors/none
matlab_flavor/subflavors/compiler_sdk_python
matlab_flavor/subflavors/onnx
```

```{toctree}
:maxdepth: 2
:caption: Tracking (REST interface)

Installation <Installation>
QuickStart
Authentication <Authentication>
```

```{toctree}
:maxdepth: 2
:caption: References

MLflowAPI
```

[//]: #  (Copyright 2021-2026 The MathWorks, Inc.)
