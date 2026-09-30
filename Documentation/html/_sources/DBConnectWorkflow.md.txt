# Using Databricks-Connect from MATLAB

## Setup

For instructions on setting up Databricks&reg; Connect see [Setup](Setup.md) and
[Databricks Connect Setup](DBConnect.md). If using MATLAB&reg; on Databricks specific
Databricks Connect setup sets are generally not required.

## Getting started

The following is a simple test to determine if Databricks Connect is connecting
from MATLAB to a cluster using simple Spark&trade; `range`, `withColumn` & `randn` commands.

A Spark session is instantiated in MATLAB with the `getDatabricksSession` function.

```matlab
spark = getDatabricksSession()
R = spark.range(1e5);
DF = R.withColumn("newCol", matlab.pyspark.sql.functions.randn());
DF.show(3)
```

### State of a session

When a Databricks Connect session is created with `getDatabricksSession()`, it uses
the underlying Databricks Connect Python&reg; based library to create the session.
In many cases, calling this a second time (with the same arguments), will simply
reuse an existing session.

Sometimes, a session may become `stale`, and unusable. In this case, it helps to
clear any existing objects containing a session, e.g. `clear spark`, and then
create a new session. Server side content in the previous session e.g. Dataframes,
will be lost.

The `forceNewSession` named argument to `getDatabricksSession` can be set to `true`
to create a new Session rather than reuse an existing Spark Session, if available.
This is especially useful in development workflows, where a new version of an
artifact is uploaded with the `addArtifact` method. If an old session is reused,
the artifact cannot be replaced.

## Serverless

A _serverless_ compute based Spark Session is supported with more recent Databricks
Connect versions, 17.3 or later is recommended. A serverless session can be created
very quickly, typically a few seconds. Such sessions have some contraints:

* They do no currently support compiled MATLAB as `.zip` or `.whl` files.
* They time out after 10 minutes of inactivity.
* Connection creation failures can time out after 5 minutes.

Serverless compute will be used if:

* The `serverless` argument is set to `true`.
* The environment variable `DATABRICKS_SERVERLESS_COMPUTE_ID` is set to `auto`.
* The configuration profile has `serverless_compute_id` set to `auto`.
* The configuration profile should not contain a `cluster_id` field.

## Data transfer

When using Databricks Connect keep in mind that the Spark dataset object returned to
MATLAB by many Spark calls is effectively a "handle" to the data and the data still
resides on the Spark cluster.
Only when converted to a MATLAB datatype does it become a value in the MATLAB
workspace and uses a meaningful amount of memory with MATLAB.
Thus to minimize memory usage by MATLAB and data transfer bandwidth from the
cluster to MATLAB, perform any possible Spark filtering or data reduction
operations using the Spark APIs on the dataset object before converting to a
native MATLAB datatype e.g. a Table.

## Limitations

Databricks documents a number of limitations of Databricks Connect here: [https://docs.databricks.com/aws/en/dev-tools/databricks-connect/python/limitations](https://docs.databricks.com/aws/en/dev-tools/databricks-connect/python/limitations)

This package does not support Databricks Connect versions below 13.3.
For relevant details of Python and MATLAB version compatibility see: [Support Matrix](SupportMatrix.md).

When using Databricks Connect the use of the latest Databricks LTS runtime is
strongly encouraged.

## Compilation of Artifacts

See the examples in the directory: `examples/DatabricksConnect/Artifacts`
and the included `README.md`.

```matlab
cd(databricksRoot('examples', 'DatabricksConnect', 'Artifacts'))
```

This folder contains some trivial example functions, `plusPi`, `doMath`,
`addStringCol`, etc..

Run the build:

> **Note:** Use Databricks Runtime version >= v17.3, which is the first general
> availability (GA) version that officially supports this functionality.

```matlab
PSB = buildLibrary();
```

This builds a wheel file, but additionally
a file `<package_name>_ZipArtifact.zip` (in this example `my.example_Artifact.zip`).

The function `addStringCol` expects a table with two columns, `integer` and `double`:

```matlab
function T_OUT = addStringCol(T_IN)
    % addStringCol

    T_OUT = T_IN;
    T_OUT.hello = string(T_IN.id) + "_hello_" + string(T_IN.did);
end
```

Use the following steps to build and run:

```matlabsession
>> spark = getDatabricksSession
spark = 
  PySparkSession with properties:

      ClusterId: "0812-091301-zntwkr4b"
    BaseVersion: "14.3"
    SparkServer: []
>> R = spark.range(1e3)
R = 
  Dataframe with no properties.
>> DF = R.withColumn('did', matlab.pyspark.sql.functions.randn())
DF = 
  Dataframe with no properties.
>> DF.printSchema
root
 |-- id: long (nullable = false)
 |-- did: double (nullable = false)
 ```

To run this from within MATLAB two things must be done:

1. The artifact must be added to the current Spark session, and
2. The functions from the python library must be imported into the current
   MATLAB session.

This can be done using a helper method of the `PythonSparkBuilder` object.

```matlabsession
PSB.addArtifact(spark);
```

This artifact is now _available_ in the current Spark session.
Furthermore, the helper methods imports the generated Python functions
into the MATLAB environment.

_Thus one can call a MATLAB function, compiled into a Python library, directly on Databricks
without leaving MATLAB._

```matlabsession
>> OUT = DF.mapInPandas("addStringCol")
OUT = 
  Dataframe with no properties.

>> OUT.show(10, false)
+---+-------------------+----------------+
|id |did                |hello           |
+---+-------------------+----------------+
|0  |-0.7208682031019744|0_hello_-0.72087|
|1  |1.1940700163708902 |1_hello_1.1941  |
|2  |-2.727349160372737 |2_hello_-2.7273 |
|3  |1.270339150176543  |3_hello_1.2703  |
|4  |0.6858066765685452 |4_hello_0.68581 |
|5  |-0.8616134822263833|5_hello_-0.86161|
|6  |1.3108976149587273 |6_hello_1.3109  |
|7  |1.9688320133711728 |7_hello_1.9688  |
|8  |-0.5911113396114568|8_hello_-0.59111|
|9  |0.10349332957650109|9_hello_0.10349 |
+---+-------------------+----------------+
only showing top 10 rows

>> T = table(OUT);
```

The data in the table `T` can now be used, extended, changed, etc.
If the table should be converted back to a Spark Dataframe, it is done as follows:

```matlab
% Make some change to table
T.str_id = string(T.id);

% Convert it to a Spark Dataframe
>> DF_NEW = matlab.sparkutils.table2dataset(T, spark)
DF_NEW = 
  Dataframe with no properties.
>> DF_NEW.printSchema
root
 |-- id: long (nullable = true)
 |-- did: double (nullable = true)
 |-- hello: string (nullable = true)
 |-- str_id: string (nullable = true)

% Write it in Spark
DF_NEW.write.format('parquet').save('/Volumes/main/default/myvolume/Scratch/new_data')
```

> **Note:** Some restrictions apply. E.g., In the current version it is not
> possible to do a `mapInPandas` with a table **and** additional arguments.
> See: [https://docs.databricks.com/en/dev-tools/databricks-connect/python/limitations.html](https://docs.databricks.com/en/dev-tools/databricks-connect/python/limitations.html)

[//]: #  (Copyright 2022-2026 The MathWorks, Inc.)
