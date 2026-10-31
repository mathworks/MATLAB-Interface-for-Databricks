# Examples with structures

This directory contains a few examples working with nested datatypes

Begin by copying the example to a temporary working directory:

```matlab
workDir = fullfile(tempdir, "NestedTypes");
copyfile(databricksRoot("examples", "NestedTypes"), workDir)
cd(workDir)
```

## Introduction

Structures enable the columns in the DataFrames to have compound datatypes,
as used by many applications.

The function in this example simply copies to the input to the output,
i.e. a _unity function_. The reason for doing so is to have a function that
can have complex input and output structure, but yet is easy to test.
The functionality is tested by ensuring that the output and the input are
exactly the same. This would be a trivial and unnecessary test in most
cases. However, in this case as this workflow deals with compiling a
MATLAB&reg; function to run in Spark&trade;, it involves several data marshalling steps.
Data is converted from Spark, through Python&reg; to MATLAB, and back, involving
6-8 steps.

```matlab
function OUT = deeply(IN)
    % deeply Using structures with depth

    OUT = IN;
end
```

## Example data and schema creation

A function has been provided that creates example data.

```matlabsession
>> [T, S] = makeDeeplyData(N=4)
T =
  4x5 table
    id        name            info                          arr                            as     
    __    _____________    __________    _________________________________________    ____________
    1     "Kajsa_6261"     1x1 struct    {[   585 949 62 585 286 828 191 443 394]}    {1x5 struct}
    2     "Gisela_5a1c"    1x1 struct    {[  677 208 319 134 672 571 170 148 477]}    {1x1 struct}
    3     "Gisela_018d"    1x1 struct    {[553 33 54 806 452 383 790 365 533 712]}    {1x1 struct}
    4     "Bob_ab08"       1x1 struct    {[   329 651 975 76 588 414 310 264 759]}    {1x1 struct}
S = 
  StructType with properties:

    fields: [1x5 compiler.build.spark.schema.StructField]
     names: ["id"    "name"    "info"    "arr"    "as"]
      type: "struct"
```

It returns the example data, and optionally the Spark Schema. This can be used to
look at the data structure in some detail, e.g. as JSON or Python code.

```matlabsession
>> S.pythonInitCode
ans = 
    "StructType([StructField('id', LongType(), True), StructField('name', StringType(), True), StructField('info', StructType([StructField('age', DoubleType(), True), StructField('country', StringType(), True), StructField('arrI32', IntegerType(), True), StructField('deep', StructType([StructField('flip', TimestampType(), True), StructField('flop', BooleanType(), True), StructField('flap', DayTimeIntervalType(0, 3), True)]), True)]), True), StructField('arr', ArrayType(IntegerType(), True), True), StructField('as', ArrayType(StructType([StructField('Id', LongType(), True), StructField('country', StringType(), True)]), True), True)])"
```

The example data is used to create a companion schema file for the function,
in this case `deeply.schema`. This file is necessary for compilation.

## Building the library

Building the library using the `buildLibrary.m` script:

```matlabsession
>> PSB = buildLibrary
### Using schema for datatype info for function deeply.
Removing C:\Users\myusername\AppData\Local\Temp\NestedTypes\_build to ensure clean build ...
### Testing deeply: inputNames, outputNames, colsIterator, mapPartitions, pandasToColumns, columnsToPandas, applyInPandas, mapInPandas
	### Found one, running mapPartitions_PythonMATLABHelper generation for deeply
	### Found one, running applyInPandas_PythonMATLABHelper generation for deeply
Created .whl file: C:\Users\myusername\AppData\Local\Temp\NestedTypes\_build\dist\mlstructs-25.2.
.
.
.
Generating examples for deeply ...
PSB = 
  PythonSparkBuilder with properties:

       BuildResults: [1x1 compiler.build.Results]
          BuildOpts: [1x1 compiler.build.PythonPackageOptions]
            PkgName: "mlstructs"
          PkgFolder: []
          OutputDir: 'C:\Users\myusername\AppData\Local\Temp\NestedTypes\_build'
             SrcDir: "C:\Users\myusername\AppData\Local\Temp\NestedTypes\_build\mlstructs"
              Files: [1x1 compiler.build.spark.PythonFileV2]
       GenMatlabDir: "C:\Users\myusername\AppData\Local\Temp\NestedTypes\_build\matlab_helpers"
        HelperFiles: [1x2 string]
       ExampleFiles: [1x2 table]
    ZipArtifactName: "C:\Users\myusername\AppData\Local\Temp\NestedTypes\_build\mlstructs_Artifact.zip"
```

## Running the functions in the library

The compiled functions can be executed in several ways. The simplest being to
run a notebook on a cluster as follows:

1. Add the directory with the newly generated examples in the working directory
to the MATLAB Path `addpath(fullfile(PSB.OutputDir, 'examples'))`

2. Run the notebook, on an existing cluster (with MATLAB Runtime), or on a
job cluster. Assuming the variable `c` points to a cluster that is up and running,
run the notebook like this: `[job, jobRun] = deeply_notebook_example(cluster=c);`

3. When running the example notebook it will return a hyperlink to a running Databricks&reg;
job. Click on the link to see how the run progresses.

The generated notebook will run 3 different operations on the DataFrame: `mapPartitions`,
`applyInPandas` and `mapInPandas`.

While the data used in this case is trivial by design, it may provide a starting
point for working with real-world data and algorithms.

[//]: #  (Copyright 2025-2026 The MathWorks, Inc.)
