# Function Schemas

This section describes how schemas are used for describing a MATLAB&reg; function's
signature to [`PythonSparkBuilder`](./PythonSparkBuilder.md). This is a necessary step, to ensure that the
data marshalling between Spark, Python&reg; and the MATLAB&reg; Runtime will work correctly.

## Introduction

MATLAB&reg; is an interpreted language, where values have a type, but variables don't.
An operation `a + b`, could equally well work on numbers (`2 + 2 --> 4`), as on
strings (`"abc" + "def" --> "abcdef"`).

A DataFrame in Apache&reg; Spark&trade;, however, has a well defined type. The following is
an example of the type (the schema) of a DataFrame.

```matlabsession
>>> DF.printSchema()
root
 |-- id: long (nullable = true)
 |-- name: string (nullable = true)
 |-- info: struct (nullable = true)
 |    |-- age: double (nullable = true)
 |    |-- country: string (nullable = true)
 |    |-- arrI32: array (nullable = true)
 |    |    |-- element: integer (containsNull = true)
 |    |-- deep: struct (nullable = true)
 |    |    |-- flip: timestamp (nullable = true)
 |    |    |-- flop: boolean (nullable = true)
 ```

By specifying the types (schema) of the MATLAB&reg; function to be built, the
marshalling of data can be faster than if it dynamically needs to
query the type of different parameters.
It also allows better error checking, to ensure that a MATLAB&reg; function supports the types present in a given DataFrame.

The schema can also be expressed as its constructor:

```python
StructType([StructField('id', LongType(), True), StructField('name', StringType(), True), StructField('info', StructType([StructField('age', DoubleType(), True), StructField('country', StringType(), True), StructField('arrI32', ArrayType(IntegerType(), True), True), StructField('deep', StructType([StructField('flip', TimestampType(), True), StructField('flop', BooleanType(), True)]), True)]), True)])
```

In a serialized form, it's often described using JSON.

```json
{
  "fields": [
    {
      "metadata": {},
      "name": "id",
      "nullable": true,
      "type": "long"
    },
    {
      "metadata": {},
      "name": "name",
      "nullable": true,
      "type": "string"
    },
    {
      "metadata": {},
      "name": "info",
      "nullable": true,
      "type": {
        "fields": [
          {
            "metadata": {},
            "name": "age",
            "nullable": true,
            "type": "double"
          },
          {
            "metadata": {},
            "name": "country",
            "nullable": true,
            "type": "string"
          },
          {
            "metadata": {},
            "name": "arrI32",
            "nullable": true,
            "type": {
              "containsNull": true,
              "elementType": "integer",
              "type": "array"
            }
          },
          {
            "metadata": {},
            "name": "deep",
            "nullable": true,
            "type": {
              "fields": [
                {
                  "metadata": {},
                  "name": "flip",
                  "nullable": true,
                  "type": "timestamp"
                },
                {
                  "metadata": {},
                  "name": "flop",
                  "nullable": true,
                  "type": "boolean"
                }
              ],
              "type": "struct"
            }
          }
        ],
        "type": "struct"
      }
    }
  ],
  "type": "struct"
}
```

> **Note:** A reference for Apache Spark datatypes can be found here: 
>[Spark Data Types](https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/data_types.html)

To keep a strong correspondence between the data types in MATLAB&reg;, in the context of
`PythonSparkBuilder`, and the data types in Spark, an extension of this schema
is used.

To describe the schema of a MATLAB&reg; function, the schemas of
input arguments, as well as the schema of the return values must be used.
An extremely simple example, `plusPi`, show this.

```matlab
function pp = plusPi(x)
    pp = x + pi;
end
```

This results in the following schema code:

```json
{
  "type": "compiler",
  "funcname": "plusPi",
  "inputs": [
    {
      "type": "io",
      "Name": "x",
      "Direction": "in",
      "Table": false,
      "SparkType": "double"
    }
  ],
  "outputs": [
    {
      "type": "io",
      "Name": "pp",
      "Direction": "out",
      "Table": false,
      "SparkType": "double"
    }
  ]
}
```

Most importantly, we see the arrays of `inputs` and `outputs` here. The entries
will be of type `io`, and furthermore have some information regarding
direction (input or output), name, table (`true`/`false`) and the actual Spark type.
In this example, the Spark type is simply `double`, but it may just as well be the
complex JSON structure seen in the previous example.

The `SparkType` for an IO element corresponds to the Spark Schema.

## Generating a schema

To generate a schema, use the function `generateFunctionSchema`. It takes 2 or 3
arguments. The first is always the name of the function, the second argument is
a cell array with _typical_ arguments to the function. The third and optional
argument is a cell array of typical return values. If the third argument is
omitted, `generateFunctionSchema` will call the function (named in the first argument)
with the arguments (the contents of the cell array in the second argument) to
determine the return values.

The schema of the function showed above can be created like this:

```matlab
>> generateFunctionSchema("plusPi", {3})
ans = 
    "/some/path/plusPi.schema"
```

If this function were to be called with a different argument type, the results
would differ:

```matlab
>> generateFunctionSchema("plusPi", {"hello"});
```

The JSON output would actually look exactly the same, except for the entries of
`SparkType`, which would change from `"double"` to `"string"`.

## Using Spark data

The schemas are generated in order to ensure that there is a correspondence
between the data in MATLAB&reg; and the data in Spark. If an interactive Spark session
is used, a good way to ensure this is by converting a part of a DataFrame to
a MATLAB&reg; table, and generate the signature using this table.

As an example with the DataFrame seen in the introduction, with the following
schema:

```text
root
 |-- id: long (nullable = true)
 |-- name: string (nullable = true)
 |-- info: struct (nullable = true)
 |    |-- age: double (nullable = true)
 |    |-- country: string (nullable = true)
 |    |-- arrI32: array (nullable = true)
 |    |    |-- element: integer (containsNull = true)
 |    |-- deep: struct (nullable = true)
 |    |    |-- flip: timestamp (nullable = true)
 |    |    |-- flop: boolean (nullable = true)
 ```

In order to ensure that MATLAB&reg; is working with the same kind of data, the data
can be imported to MATLAB&reg; using a Spark Session. This example is for Databricks&reg;,
it's similar for Apache Spark.

```matlabsession
>> spark = getDatabricksSession();
>> DF = spark.read.format("parquet").load("/tmp/test_deeply");
>> DF.show(3, false)
+---+----+------------------------------------------------------+
|id |name|info                                                  |
+---+----+------------------------------------------------------+
|1  |1   |{2.0, 3, [5, 6, 7, 8, 9], {2020-10-10 05:06:05, true}}|
|2  |2   |{3.0, 4, [6], {2020-10-10 05:06:15, true}}            |
|3  |3   |{4.0, 5, [7, 8], {2020-10-10 05:06:25, true}}         |
+---+----+------------------------------------------------------+
only showing top 3 rows

>> T = DF.table;
>> head(T,3)
    id    name       info   
    __    ____    __________
    1     "1"     1×1 struct
    2     "2"     1×1 struct
    3     "3"     1×1 struct
>> T.info(1)
ans = 
  struct with fields:

        age: 2
    country: "3"
     arrI32: [5 6 7 8 9]
       deep: [1×1 struct]
>> T.info(1).deep
ans = 
  struct with fields:

    flip: 2020-10-10 05:06:05
    flop: 1
```

## Using Spark schemas

In some circumstances, it may not be possible to extract data from a cluster
(some organizations have exfiltration policies forbidding this). If it's still
possible to export the schema, this can be used to create a schema in MATLAB&reg;.
If not possible, it can be written by hand.

For the purpose of this example, the schema presented in the introduction
will be used. This will be saved in a file, `/my/project/some_schema.json`.

```matlab
% Convert the schema to a structure
p="/my/project/some_schema.json"
val = jsondecode(fileread(p))

% Convert the structure to a MATLAB implementation of the Spark schema
some_schema = compiler.build.spark.schema.StructType();
some_schema.fromVal(val)

% Create the corresponding Spark data object from this schema
some_data = compiler.build.spark.data.fromSchema(some_schema)

% Create example data from this data object
some_example = some_data.instantiateMATLABExampleValue(1, doEval=true)

jsonencode(some_example, 'PrettyPrint', true)
```

The last line would output something like this:

```json
{
    "id": 1001,
    "name": "Giselle_2001",
    "info": {
        "age": 4001,
        "country": "David_5001",
        "arrI32": [6101, 6201, 6301, 6401, 6501],
        "deep": {
        "flip": "1970-01-19 13:06:26",
        "flop": true
        }
    }
}
```

The data should be correct with respect to data types, though, so it can then be
used for running the `generateFunctionSchema` function.

[//]: #  (Copyright 2025 The MathWorks, Inc.)
