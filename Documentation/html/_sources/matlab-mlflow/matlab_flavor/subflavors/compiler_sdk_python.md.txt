# compiler_sdk_python sub flavor

The MATLAB Compiler SDK Python package sub flavor is more involved than the other sub flavors. Wrapper code must be generated to facilitate `pyfunc` compatibility and this requires information about function in- and output types to be provided first. It is recommended to review the sections below at least once to understand the _entire_ workflow. But then in practice one would typically work with the higher level {func}`mlflow.matlab.save_model` and {func}`mlflow.matlab.log_model` convenience functions to save and log models.

These higher level MATLAB functions can be used to perform all steps in one convenient function call where you specify which MATLAB function to package, what its example input is and where to save the model. For example:

```matlab
mlflow.matlab.save_model(FunctionFile="myFunction.m",Path="mymodel",InputExample={[1,2,3],[4,5,6]})
```

Where it is also possible to omit `InputExample` if a correct signature YAML-file (see below) already exists for the function.

Lastly, it is possible to combine this sub flavor with the [](./none.md), i.e. you can add `MATLABFiles` in the call to {func}`mlflow.matlab.save_model` or {func}`mlflow.matlab.log_model` to also include the original MATLAB code with the model. This allows users who do have MATLAB installed and have a valid MATLAB license to also load the original code back into MATLAB and use it there.

```{important}
When your MATLAB model is packaged as MATLAB Compiler SDK Python module, this offers certain [protection of your code and data](https://www.mathworks.com/help/compiler_sdk/ml_code/deployable-archive.html) making it a suitable way to share your model with third parties. Of course this protection will be negated if you choose to also include the original MATLAB code and data and then share the model with third parties.
```

## Workflow overview

In order to be able to generate the Python and MATLAB Wrappers for data marshalling and `pyfunc` compatibility, it is necessary to declare the in- and output types of the MATLAB function which is to be saved as MLflow model. This is done in a YAML-file which is placed next to MATLAB function files. The file is placed in the same directory as the MATLAB function and its name is the same as the function, only its extension is `.yaml` instead of `.m`. The file will contain a `signature:` definition in the exact same format as which MLflow itself uses for describing [Model Signatures](https://mlflow.org/docs/latest/models.html#model-signature-and-input-example).

While it is possible to manually write these YAML-files, a MATLAB function {func}`compiler.build.mlflow.types.generateFunctionSignature` is provided which can generate the file based on example MATLAB in- and (optionally) output data (if output data is omitted, the output is determined by running the function with the example input data). For example:

```matlab
% Only specify inputs, the function will be run to determine the outputs
compiler.build.mlflow.types.generateFunctionSignature("myFunction",{in1,in2,in3});
% Alternatively provide an example output as well
compiler.build.mlflow.types.generateFunctionSignature("myFunction",{in1,in2,in3},OUT={out1,out2});
```

```{note}
By default only data type and number of dimensions are captured, the size of each dimension is set to `-1` by default, which indicates a "variable size". If you want the _exact_ dimension sizes of the in- and outputs to be set based on the example in- and outputs add `ExactDimensions=true`. This option can also be passed to {func}`mlflow.matlab.save_model` and {func}`mlflow.matlab.log_model`.
```

To generate wrappers and package the MATLAB function into a Python package which the MATLAB MLflow flavor can later run, a function {func}`compiler.build.mlflow.pythonPackage` with configuration options {class}`compiler.build.mlflow.PythonPackageOptions` is provided. This function is designed to work in a way very similar to MATLAB Compiler SDK's built-in {func}`compiler.build.pythonPackage`. The output of this function is a {class}`compiler.build.mlflow.PythonMlflowBuilder` object which offers `save_model` and `log_model` methods which allow saving or logging the model as a MATLAB flavor MLflow model. For example:

```matlab
% Set the options
opts = compiler.build.mlflow.PythonPackageOptions("myFunction");
% Build the package
result = compiler.build.mlflow.pythonPackage(opts);
% Save the model
result.save_model("/work/models/mymodel");
```

## Function in- and output handling

```{important}
Since the models are saved *with* a function signature, MLflow *will* [enforce the signature](https://mlflow.org/docs/latest/models.html#signature-enforcement). So, when later running inference using the model, it is important to call the `predict` method with the correct input types. If a type is incorrect, MLflow _will_ **throw an error** and it will *not* somehow automatically cast variables to the correct type.
```

### Limitations

When it comes to function in- and outputs there are some important limitations which stem from the MLflow end: in a `pyfunc` compatible MLflow model the function input (or output) is either:

* One or more `numpy` tensors (+ zero or more scalar or vector parameters), or
* Exactly one `pandas.DataFrame` + zero or more scalar or vector parameters

So if you for example want/need a `pandas.DataFrame` *and a* numeric scalar or vector, these additional scalars or vectors would have to be _parameters_, where parameters:

* Are limited to be either scalar or vectors, they cannot be matrices or higher dimensional, and
* These inputs must be explicitly marked as parameter and they should appear at the end of the list of inputs (e.g. _after_ the `pandas.DataFrame`). Use `NParams` to specify how many parameters there are.

It *is* possible to have different options for inputs versus outputs. For example, if your input is "one Table", then your outputs *can* be "one or more scalars/vectors/matrices", it does not have to be "one Table" as well.

### MATLAB scalars/vectors/matrices ↔ numpy tensors

When working with MATLAB scalars/vectors/matrices these become `numpy.array` on the Python end. As in MATLAB itself, where each variable always has at least 2 dimensions (even a scalar has two dimensions, the size of both is 1 though), the `numpy.array`s will have at least two dimensions. As for the `dtype` inside these `numpy.array`s refer to the following table to see which data type each MATLAB data type is mapped to:

| MATLAB Type         | numpy dtype name |
|---------------------|------------------|
| double              | float64          |
| single              | float32          |
| int8                | int8             |
| uint8               | uint8            |
| int16               | int16            |
| uint16              | uint16           |
| int32               | int32            |
| uint32              | uint32           |
| int64               | int64            |
| uint64              | uint64           |
| logical             | bool_            |
| string              | str_             |
| datetime            | timestamp64[ns]  |

```{note}
`char` and cell-array of `char` are not directly supported, implement functions to work with (arrays) of string directly or for example use `cellstr` to convert arrays of string to cell-arrays of `char`.
```

Further when calling the `predict` function in the `pyfunc` interface, it is called with a `dict` as input. The keys in the `dict` refer to the names of the input variables and the values are the values to be passed to that input.

#### Examples

Given a MATLAB function:

```matlab
function [x,y,z] = myFunction(a,b,c)
```

And the following MATLAB code to call the function:

```matlab
a = 1;
b = [1,2,3];
c = [1, 2; 3, 4];
[x,y,z] = myFunction(a,b,c);
```

The Python equivalent of calling this function through `predict` is:

```python
import mlflow
import numpy
# First load the model through the pyfunc interface
model = mlflow.pyfunc.load_model("/work/model/myModel")
# Call the predict function
model.predict({
    "a": numpy.float64([[1]]),
    "b": numpy.float64([[1,2,3]]),
    "c": numpy.float64([[1,2],[3,4]])
})
```

### MATLAB Table ↔ Pandas DataFrame

When working with a MATLAB Table these become a `pandas.DataFrame` on the Python end. For `pandas.DataFrame` the [data type definitions in MLflow](https://mlflow.org/docs/latest/python_api/mlflow.types.html#mlflow.types.DataType) are less specific, for example some integer types cannot be specified. The following table shows which MLflow types MATLAB data types are mapped to when providing these types as example input:

| MATLAB Type         | MLflow DataType  |
|---------------------|------------------|
| double              | double           |
| single              | float            |
| int8¹               | integer          |
| uint8¹              | integer          |
| int16¹              | integer          |
| uint16¹             | integer          |
| int32               | integer          |
| uint32¹             | long             |
| int64¹              | long             |
| uint64²             | long             |
| logical             | boolean          |
| string              | string           |
| datetime            | datetime         |

> ¹ These types are essentially upcasted to avoid overflows\
> ² Risk of overflow

As can be seen not all integer types can be represented uniquely here and some types are "upcasted" when provided as example input. Note that at runtime they then really become the specified type; also see the [](#unsupported-integer-type) example.

#### Examples

##### Simple DataFrame

Given a MATLAB function:

```matlab
function tOut = tableInAndOutput(tIn)
       tOut = table;
       tOut.x = tIn.a + tIn.b;
       tOut.y = tIn.a - tIn.b;
```

which is saved to an MLflow model using:

```matlabsession
>> mlflow.matlab.save_model(FunctionFile="tableInAndOutput.m",...
    ExampleInputs={table((1:10)',(1:10)','VariableNames',{'a','b'})},...
    Path="/work/models/myModel")
```

This MLflow model can then be called from Python through the `pyfunc` interface using:

```python
import mlflow
import pandas
import numpy
# First load the model through the pyfunc interface
model = mlflow.pyfunc.load_model("/work/models/myModel")
# Call the predict function
result = model.predict(pandas.DataFrame({
    "a": [1.0,2.0,3.0],
    "b": [1.0,2.0,3.0]
}))
print(result)
```

##### DataFrame with Two Parameters

If the previous example is extended with two parameters:

```matlab
function tOut = tableInAndOutputWithParams(tIn,d,e)
       tOut = table;
       tOut.x = d * (tIn.a + tIn.b);
       tOut.y = (tIn.a - tIn.b) / e;
```

it can then be saved to an MLflow model using:

```matlabsession
>> mlflow.matlab.save_model(FunctionFile="tableInAndOutputWithParams.m",...
    ExampleInputs={table((1:10)',(1:10)','VariableNames',{'a','b'}),3,4},... 
    NParams=2,... Specify that the last two inputs are parameters
    Path="/work/models/myModel")
```

And this MLflow model can then be called through the `pyfunc` interface in Python using:

```python
import mlflow
import pandas
import numpy
# First load the model through the pyfunc interface
model = mlflow.pyfunc.load_model("/work/models/myModel")
# Call the predict function
result = model.predict(pandas.DataFrame({
    "a": [1.0,2.0,3.0],
    "b": [4.0,5.0,6.0]
  }),
  params={"d":7.0,"e":8.0}
)
print(result)
```

##### Unsupported Integer Type

Given a MATLAB function:

```matlab
function t = myFun(t)
    t.y = 2 * t.x;
```

Which is saved to an MLflow model using:

```matlabsession
>> mlflow.matlab.save_model(FunctionFile="myFun.m",...
    ExampleInputs={table(int8([1;2;3]),'VariableNames',{'x'})},...
    Path="/work/models/myModel")
```

Where the provided example input table contained a column with `int8` data. The data type of the resulting MLflow model will have changed; it now expects an 32-bit signed integer as input. While it is still possible to call the predict function with `numpy.int8` as input then:

```python
import mlflow
import pandas
import numpy
# First load the model through the pyfunc interface
model = mlflow.pyfunc.load_model("/work/models/myModel")
# Call the predict function
result = model.predict(pandas.DataFrame({
    "x": [numpy.int8(1),numpy.int8(2),numpy.int8(3)]
}))
```

On the MATLAB end, the MATLAB function *will* receive a MATLAB `int32` as input and as a result the output table here will also contains `int32` instead of `int8`. It is of course also possible, recommended even, to call the function with an actual `numpy.int32` as input here:

```python
result = model.predict(pandas.DataFrame({
    "x": [numpy.int32(1),numpy.int32(2),numpy.int32(3)]
}))
```

## MATLAB Runtime Requirements

In order to be able to run `compilers_sdk_python` MATLAB MLflow models, a MATLAB Runtime is required.

When working with such models in Python, for example:

```python
import mlflow
import numpy
model = mlflow.pyfunc.load_model("/work/models/my_matlab_model")
prediction = model.predict({"x":numpy.float64([[42.0]])})
```

Simply make sure that the correct MATLAB Runtime version has been installed on the machine where this code is being run and [`PATH` or `LD_LIBRARY_PATH` have been configured](https://www.mathworks.com/help/compiler_sdk/cxx/mcr-path-settings-for-run-time-deployment.html) to include the MATLAB Runtime.

````{note}
Note that MATLAB Compiler SDK Python modules always depend on a specific MATLAB Runtime version which matches the MATLAB release used to build the module in the first place. The module cannot be run with a different MATLAB Runtime version. In that sense each `compiler_sdk_python` MLflow models will also depend on a specific MATLAB Runtime version. Make sure to work with the _correct_ MATLAB Runtime _version_. 

When in doubt, note that the MATLAB release used to build the model is included in the `MLmodel` file which is always part of an MLflow model. This file can be inspected in a text editor in which you should for example be able to see something like:

```yaml
flavors:
  matlab:
    #...
    matlab_release: r2025b
    #...
```

Or when working in Python, the metadata can for example be queried as follows:

```python
# Load the model, in this example a registered model
# from a tracking server, this could also refer to a
# model id of a non-registered model or a model on 
# local disk instead
model = mlflow.models.Model.load("models:/mymodel/1")
# Get the model info
info = model.get_model_info()
# From the MATLAB flavor, get the matlab_release
matlab_release = info.flavors["matlab"]["matlab_release"]
```
````

When working locally with MLflow command line tools, for example:

```console
$ mlflow models serve -m /work/models/my_matlab_model
```

Again, simply make sure that the MATLAB Runtime has been installed locally and `PATH`/`LD_LIBRARY_PATH` has been configured correctly in the environment where the CLI is being called.

When deploying models to platforms like Databricks or AzureML, ensure that the MATLAB Runtime is installed and `PATH`/`LD_LIBRARY_PATH` have been configured in the "cluster" or "environment" used to deploy the model.


## MATLAB Function and Class References

```{module} compiler.build.mlflow
```


```{function} pythonPackage(files,name=value,...)
Packages a MATLAB file into a Python package with a MLflow `pyfunc` compatible interface. The MATLAB-file must to be accompanied by a corresponding [YAML-file with function signatures](#workflow-overview). These YAML-file can be generated with the help of {func}`compiler.build.mlflow.types.generateFunctionSignature`.

This is convenience function which creates a {class}`PythonMlflowBuilder` instance with the specified property configuration and then calls its {meth}`build<PythonMlflowBuilder.build>` method.

:files: files to package as entrypoints to the package

:name=value: any of the properties of {class}`PythonPackageOptions` can be provided as Name-Value pairs.

```

````{class} PythonMlflowBuilder
Builder for packaging a MATLAB function into a Python package with MLflow `pyfunc` compatible interface. The MATLAB-file must to be accompanied by a corresponding [YAML-file with function signatures](#workflow-overview). These YAML-file can be generated with the help of {func}`compiler.build.mlflow.types.generateFunctionSignature`.

First create an instance of the class, then configure its properties and then call the {meth}`build` method to perform the build.

**Properties**

All properties are inherited from {class}`PythonPackageOptions`.

**Methods**

```{method} build
Build the package based on the configured properties.
```

````

````{class} PythonPackageOptions

Configuration options used {class}`PythonPackageOptions` and {func}`pythonPackage` when building the Python package. These options mostly simply derive from the built-in {func}`compiler.build.PythonPackageOptions` but add one additional option {attr}`Debug`.

**Properties**


```{attribute} AdditionalFiles
_(A row char vector, a string vector, or a cellstr vector)_

A list of files and folders to be added to the package.

```
```{attribute} AutoDetectDataFiles
_('on'/'off', true/false, or 1/0)_

Binary value controlling whether data files that are provided as
inputs to certain functions (such as load) are automatically
included with the package. This is set to 'on' by default. If it
is set to false/'off'/0, all required data files must be added to
the package using the AdditionalFiles property.

```
```{attribute} ExternalEncryptionKey
_(A scalar struct)_

Paths to an external encryption key file and a key loader file.
Specified as a scalar struct with exactly two row char vector or
string scalar fields named "EncryptionKeyFile" and
"RuntimeKeyLoaderFile" respectively. Both struct fields are
required.

```
```{attribute} ObfuscateArchive
_('on'/'off', true/false, or 1/0)_

Binary value controlling whether to obfuscate the folder structures, 
file names and .m files in the deployable archive (.ctf file). 
This is set to 'off' by default.

```
```{attribute} OutputDir
_(A row char vector or a string scalar)_

Path to folder where the build files are saved.

```
```{attribute} PackageName
_(A row char vector or a string scalar)_

Name of the generated package.

```
```{attribute} SampleGenerationFiles
_(A row char vector, a string vector, or a cellstr vector)_

A list of MATLAB sample files used to generate sample Python files
for functions included within the Python package. All files should
have a .m extension.

```
```{attribute} SecretsManifest
_(A row char vector or a string scalar)_

Path to a JSON manifest file that specifies secret keys to be
embedded in the package.

```
```{attribute} SupportPackages
_(A row char vector, a string vector, or a cellstr vector)_

'autodetect' (default) - The required support packages are
detected and included automatically.

'none' - No support packages are included in the Python package.

Otherwise, a specific list of support packages may be specified
for inclusion.

```
```{attribute} Verbose
_('on'/'off', true/false or 1/0)_

Binary value controlling build verbosity. It is 'off' by default.
```

```{attribute} Debug
_(true/false)_

Print additional debug information when generating the package and preserve the intermediate generated files.
```

````

```{module} compiler.build.mlflow.types
```

```{function} generateFunctionSignature(funcName, IN, name=value,...)
Generates function signature YAML-file for specified function based on example in and outputs. If the outputs are omitted, the function is actually called with the provided example inputs to obtain example outputs.

**Required Inputs**

:param funcName: name of the MATLAB function
:param IN: Input example(s), provided as a cell-array of values

**Optional Name-Value pairs**

:param NParams: specifies how many [parameters](#limitations) the function has, the last `NParams` cells of `IN` are then considered as parameters. Defaults to `0`.

:param OUT: Output example(s), provided as a cell-array of value. If these are not provided, the function will actually be run with the provided input examples in order to be able to determine the output types. When they are provided the function will not be run, this can be beneficial if running the function takes a long time or if the function actually cannot run in the current environment.

:param SaveExample: include the provided input example as actual [MLflow model input example](https://mlflow.org/docs/latest/ml/model/signatures/) for the model. Set to `false` if your example inputs contain sensitive data which should not be stored with the model. Defaults to `true`.

:param ExactDimensions: include the _exact_ dimensions of the in- and output data in the signature YAML-file. When set to `false`, the number of dimensions is included in the signature file but their sizes are set to `-1` indicating a variable size. Set to `true` if the exact dimension sizes should be included. Defaults to `false`

```

[//]: #  (Copyright 2025-2026 The MathWorks, Inc.)