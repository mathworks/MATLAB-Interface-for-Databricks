# Introduction

A MATLAB flavor MLflow model can contain various pieces of information:

*   **MATLAB/Simulink code and data _in their original format_**. If this is indeed included, the model can be loaded back into MATLAB such that it can be executed inside MATLAB or can be used for further development of new models.
    ```{admonition} Runtime Requirements
    In order to be able to run the code inside MATLAB/Simulink, an end-user will require a MATLAB installation and license.
    ```

*   **MATLAB/Simulink code and data _compiled into a MATLAB Compiler SDK Python Package (including data marshalling wrappers)_**. This allows the model to be [`pyfunc` compatible](https://mlflow.org/docs/latest/ml/model/#pyfunc-model-flavor). `pyfunc` compatibility enables other MLflow tools to work with the model regardless of which persistence module or framework was used to produce the model.
    ```{admonition} Runtime Requirements
    While running the model does not require a MATLAB installation nor a MATLAB license, the [MATLAB Runtime](https://www.mathworks.com/products/compiler/matlab-runtime.html) is required at runtime. Unfortunately the MATLAB Runtime cannot automatically be installed by MLflow's environment managers. But _if_ the correct MATLAB Runtime version is available in an environment, other MLflow tools *will* indeed be able to simply run the model without needing any MATLAB specific knowledge. Also see [MATLAB Runtime Requirements](./subflavors/compiler_sdk_python.md#matlab-runtime-requirements).
    ```
    
*   **A [Deep Learning Toolbox](https://www.mathworks.com/products/deep-learning.html) network _saved in ONNX format_**. Various Deep Learning Toolbox networks can be exported to the ONNX format using the [`exportONNXNetwork` function](https://www.mathworks.com/help/deeplearning/ref/exportonnxnetwork.html). If a network can indeed be exported as such, it can be included in the MLflow model as [ONNX Flavor](https://mlflow.org/docs/latest/models.html#onnx-onnx) which in turn offers `pyfunc` compatibility.
    ```{admonition} Runtime Requirements
    In this case there is no further dependency on MATLAB or MATLAB Runtime whatsoever. The only dependency will be on the ONNX Runtime which MLflow environment managers will automatically install when needed.
    ```

## Sub Flavors

To indicate what information is saved in the model, a MATLAB flavor model is said to have one or more so called sub flavor. Click on their names to learn more about each sub flavor.

:[none](subflavors/none.md): only contains the MATLAB/Simulink code and data.
:[compiler_sdk_python](subflavors/compiler_sdk_python.md): contains the MATLAB Compiler SDK Python package. *May* also contain the original MATLAB/Simulink code and data.
:[onnx](subflavors/onnx.md): contains a Deep Learning Toolbox network in ONNX format. *May* also contain the original MATLAB/Simulink code and data.

Note that it is possible for a MATLAB flavor model to contain multiple sub flavors. It is for example possible to have a model which contains both the original MATLAB code as well as the MATLAB Compiler SDK Python packaged version of the code such that the model is (re-)usable both inside as well as outside of MATLAB.

```{important}
When your MATLAB model is packaged as MATLAB Compiler SDK Python module, this offers certain [protection of your code and data](https://www.mathworks.com/help/compiler_sdk/ml_code/deployable-archive.html) making it a suitable way to share your model with third parties. Of course this protection will be negated if you choose to also include the original MATLAB code and data in an MLflow MATLAB flavor model and then share the entire model. The Python module would still be protected but the original code would simply be available next to it. Therefore be selective with what different options to include in your MLflow MATLAB flavor model and carefully consider who you want to share which model with.
```

## MATLAB Interface

To learn more about the MATLAB functions which work with the MLflow MATLAB Flavor see [](./Usage.md).

[//]: #  (Copyright 2025-2026 The MathWorks, Inc.)