# Databricks Connect and Compiler SDK workflow example

This example describes a Databricks&reg; and MATLAB&reg; Compiler SDK&trade; workflow.

Writing code in MATLAB and then running it on Spark&trade; requires that both the MATLAB
and Spark code *view* the data in the same way. This can be tricky, and debugging
a MATLAB application on Spark is more complex than debugging in MATLAB alone.

A recommended workflow to approach the process is as follows:

1. Read data using Spark into MATLAB
2. Develop the MATLAB algorithm
3. Compile the algorithm
4. Copy the resulting library `.whl` and a notebook to Databricks
5. Run the library on Databricks

The examples uses the open New York City Taxi dataset, which is available as an
example dataset on Databricks by default.

Begin by copying the example to a temporary working directory:

```matlab
workDir = fullfile(tempdir, "NYC");
copyfile(databricksRoot("examples", "DatabricksConnect", "NYC"), workDir)
cd(workDir)
```

## Read data using Spark into MATLAB

The rationale is to read the same data into MATLAB that the algorithm will work
with later. While possible to simply look at the data in Databricks and create
something similar in MATLAB, this is error prone. It is better to start directly
with data from Spark, to reduce the chance of mistakes.

Step through this process using `runExample.m`.

First, get a Spark Session using Databricks Connect to read the data.

```matlab
% Create a Spark session, in this case using the configured default cluster
spark = getDatabricksSession()

% Default dataset path in Databricks
nycSrc = '/databricks-datasets/nyctaxi/tables/nyctaxi_yellow';

DS = spark.read.format("delta").load(nycSrc) %#ok<*NOPTS>
fprintf("The NYC dataset has %g rows\n", DS.count);
```

This will create a Spark Dataset in MATLAB, i.e. a handle to a Dataset in Databricks.
Operations can be performed on this using Spark commands, but it cannot be used
as is to develop MATLAB algorithms.

For the purpose of this example a few columns are selected, and the data further
reduced with some filtering.

```matlab
%% Choose specific columns from the dataset
nycDS = DS ...
    .select("passenger_count", "trip_distance", "fare_amount", "tip_amount") ...
    .filter("fare_amount > 80.0 AND fare_amount < 100.0")

%% Show the data using Sparks show command
nycDS.show(10, false);
```

This returns a specific dataset, to use for developing the algorithm.
There are practical limits to how much data can be brought into a MATLAB
session from the cluster. For this example only the structure of the data is needed,
not all of the data and so the dataset is limited to 100 rows before being
converted to a MATLAB table.

```matlabsession
%% Convert the data to MATLAB table
>> nycT = table(nycDS.limit(100))
nycT =
  100×4 table
    passenger_count    trip_distance    fare_amount    tip_amount
    _______________    _____________    ___________    __________
           1                3.55             85              0   
           1                   0             84              0   
           1                   0             93              0   
           1               16.66             85             11   
           1               28.45           81.1              0   
           5               33.37           90.7          22.92   
           1               28.13             96             24   
           :                 :               :             :     
           5               24.37           83.7             10   
           1                   0             90              0   
           1                   0             85              0   
           1                   0             95           5.55   
           1               25.13             88           17.6   
           2                   0             91              0   
           1                32.1           81.9              0   
	Display all 100 rows.
```

At this point, `nycT` is a conventional MATLAB table, and typical MATLAB algorithms
that accept tables can use it.

## Develop the MATLAB algorithm

To keep the example simple, the algorithm simply takes a table as input,
and returns a table as output.

```matlab
function out = nycAlgo(nycT)
```

When writing MATLAB code that consumes data from Spark there are limits to the
forms of data that can be passed to that MATLAB code, e.g. tabular or not and if
not scalar or vector. More details on this can be found in `Modules/matlab-spark-api/Documentation/SparkBuilderDataTypes.md`.

## Compile the algorithm

To compile the algorithm, 2 steps are required:

* Generate a schema file
* Compile to `.whl` library

### Generate a schema file

Often MATLAB functions can take varying inputs (ints, doubles, etc.), but a Dataset
in Spark is strongly typed, so the typing for the functions must be specified before
compiling the code because conversion code is generated that is data type specific.

The compilation command expects a schema file, typically in the same folder as the function.
It should have the same name as the function but with a `.schema` extension.
To generate this file call the `generateFunctionSchema` function:

```matlab
>> generateFunctionSchema("nycAlgo", {nycT})
ans = 
    "C:\matlab-databricks\Software\MATLAB\examples\CompilerWorkflow\nycAlgo.schema"
```

It takes two arguments, the name of the function, and a cell array of the correct type
of input arguments. For this example, this is simply the `nycT` table that was converted
from a Spark dataset in the prior. The JSON schema file will look similar to the following,
formatting may differ:

```json
{
  "type": "compiler",
  "funcname": "nycAlgo",
  "fullFilename": "C:\\Users\\myusername\\AppData\\Local\\Temp\\NYC\\nycAlgo.m",
  "inputs": [
    {
      "type": "io",
      "Name": "NYC",
      "Direction": "in",
      "Table": true,
      "SparkType": {
        "fields": [
          {
            "metadata": {},
            "name": "passenger_count",
            "nullable": true,
            "type": "integer"
          },
          {
            "metadata": {},
            "name": "trip_distance",
            "nullable": true,
            "type": "double"
          },
          {
            "metadata": {},
            "name": "fare_amount",
            "nullable": true,
            "type": "double"
          },
          {
            "metadata": {},
            "name": "tip_amount",
            "nullable": true,
            "type": "double"
          }
        ],
        "type": "struct"
      }
    }
  ],
  "outputs": [
    {
      "type": "io",
      "Name": "OUT",
      "Direction": "out",
      "Table": true,
      "SparkType": {
        "fields": [
          {
            "metadata": {},
            "name": "passenger_count",
            "nullable": true,
            "type": "integer"
          },
          {
            "metadata": {},
            "name": "trip_distance",
            "nullable": true,
            "type": "double"
          },
          {
            "metadata": {},
            "name": "fare_amount",
            "nullable": true,
            "type": "double"
          },
          {
            "metadata": {},
            "name": "tip_amount",
            "nullable": true,
            "type": "double"
          },
          {
            "metadata": {},
            "name": "entries",
            "nullable": true,
            "type": "double"
          }
        ],
        "type": "struct"
      }
    }
  ]
}
```

### Compile to `.whl` library

Compile the function having first created an options object:

```matlab
opts = compiler.build.PythonPackageOptions(...
    "nycAlgo.m", ...
    "OutputDir", "_build", ...
    "PackageName", "demo.nyc");

PSB = compiler.build.spark.pythonPackage(opts)
```

The first argument is the file (or the files) to be compiled. A path to the output
directory and a package name are also provided. The compiler can then be called,
providing it the options object.

## Copy the resulting `.whl` and a notebook to Databricks

After compilation, the resulting `.whl` file and other material is located in the
output directory specified in the options object. The `getWheelFile` method can
be used to provide the specific path.

```matlabsession
PSB.getWheelFile
ans =
    'C:\Users\mbrowne\AppData\Local\Temp\NYC\_build\dist\demo_nyc-25.2.0-py3-none-any.whl'
```

This file must be copied to a Databricks Volumes or Workspace location.
If running MATLAB on Databricks this can be done using `copyfile`, otherwise the
Databricks browser interface or `databricks.Files` or `databricks.Workspace` call
can be used. Similarly an example notebook must be copied to Databricks to call
the compiled code. Importing via the Databricks UI is also an easy option for one-off
uploads. 

```matlab
f = databricks.Files();
[~, name, ext] = fileparts(string(PSB.getWheelFile));
whlPath = "/Volumes/main/default/myvolume/Scratch/" + name + ext;
f.upload(PSB.getWheelFile, whlPath);

% Upload a provided notebook
ws = databricks.Workspace();
notebookPath = "/Workspace/Users/" + string(ws.username) + "/" + "nyc_example_notebook.py";
ws.import('path', notebookPath, 'format', 'SOURCE', 'language', 'PYTHON', ...
        'file', fullfile(workDir, "nyc_example_notebook.py"), 'overwrite', true);
```

The Databricks Library/Install UI or the `PSB.installWheelOnDatabricksCluster()`
method can be used to install the `.whl` file on the cluster as opposed to to copying
it and using `%pip install`, however the `%pip` approach is generally more flexible.

## Run the library on Databricks

The library can be run in different ways, most simply a Python&reg; Notebook.
An example notebook is included, `nyc_example_notebook.py`, which can be imported
into the workspace. The notebook should be opened in the Databricks UI.
It should be modified slightly to update the `%pip install` command to use
the path for the `.whl` file (`whlPath`). For example:
`/Volumes/main/default/myvolume/Scratch/demo_nyc-25.2.0-py3-none-any.whl`
Select a MATLAB runtime enabled cluster and run the notebook.

The notebook result will contain more entries than that of the uncompiled MATLAB
test because it operates over the complete data set rather than simply 100 rows.

Notebook execution can also be triggered from MATLAB if desired for more
automated workflows.

## Cleanup

Clean up by removing the temporary working directory and the `.whl` file copied to
Databricks.

```matlab
[status,msg,msgID] = rmdir(workDir)
```

[//]: #  (Copyright 2023-2026 The MathWorks, Inc.)
