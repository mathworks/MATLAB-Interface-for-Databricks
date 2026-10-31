# SparkBuilder data types

## Introduction

The following describes what datatypes can be used, and in what combinations,
with the package's MATLAB® Compiler SDK™ based workflow when building .whl libraries using `PythonSparkBuilder`.

## Function signatures

The functions generated with the MATLAB&reg; Compiler SDK&trade; workflows can be used in a Spark&trade; workflow, e.g.

```python
output = DataFrame.mapInPandas(myFunc, myFunc_schema)
```

The source for the data is in general a Spark `DataFrame`[^1], but it can also be used in
some other contexts, such as with *UDF*s.

The methods on a Dataset will in general be applied to either **one row**,
or **a set of rows**, and the methods will correspondingly return the same,
i.e. **one row**, or **a set of rows**.

A `DataFrame` is basically a table, and the distinction above means that the function
that the `DataFrame` method is applied to, will either get one row as input, or a table
(in general a chunk of the `DataFrame`). These method types are called *row* and *chunk*
in the following documentation.

There is a distinction between two forms of input types for these functions
-- **table** and **value**. On the MATLAB&reg; side, a **table** will correspond
to a **MATLAB&reg; table**, and a **value** will correspond to some **MATLAB&reg; value** (which
is not a table). The value can be a scalar or a vector (some restrictions apply).

Depending on the input/output of a function, different functions will be generated
for use with the `DataFrame` methods.

The following combinations of input/output variables are currently supported.
If values are used, there can be one or more entries. If tables are used, there can
only be one table. This is determined by the Spark methods, which always act on one
`Dataset`. If two or more `Dataset`s should be used, they must first be `join`ed
in some way:

| Name   | Input         | Output |
| ------ | ------------- | ------ |
| Value  | Value         | Value  |
| Table  | Table         | Table  |
| Table+ | Table + Value | Table  |

The names in this list are not formal names, merely placeholders to facilitate the description
below.

### Value function

A value function simply has *normal values* as inputs and outputs, e.g.:

```matlab
function [x,y] = myfunc(a,b,c)
    x = a*b*c;
    y = a+b+c;
end
```

When this is used, the `DataFrame` method will always act on one row at a time, e.g. with the
`map` method. The generated function can also be used with `mapPartitions`, i.e. a *chunk* method.
In this case, the MATLAB&reg; function will still be invoked on one row at a time, but Spark will give a set
of rows that will then be applied to the MATLAB&reg; function one by one.

> **Note:** There can be a performance advantage of using `mapPartitions` instead of `map`, as
> the MATLAB&reg; Runtime will only be invocated once instead of for every row. The results of these two
> variants is however the same.

### Table function

A table function has a MATLAB&reg; table input and a MATLAB&reg; table output, e.g.:

```matlab
function Tout = otherfunc(Tin)
    Tout = Tin;
    meanDist = mean(Tin.distance)
    Tout.distance = Tout.distance - meanDist;
end
```

A function like this can be called with `mapPartitions`, but not with `map`, as it can only act
on tables (*chunks*).

### Table+ function

A Table+ function is a variant of the table function. It returns a table, and takes a table as
an input argument, but also takes additional arguments that can be used to parametrize the function.

```matlab
function Tout = plusfunc(Tin, mass)
    Tout = Tin;
    Tout.momentum = Tin.velocity * mass;
end
```

A `DataFrame` method cannot take additional arguments, however, only a function that acts on a *chunk*,
so to use this with different parametrization, it's called like this:

```python
mass = 1750.0
OUT = myDataset.mapInPandas(plusFunc_mapInPandas(mass), plusFunc_output_schema)
```

In the previous function code snippet, the function is called with one argument, `mass`, instead of
with 2, `Tin` and `mass`. The reason is that the `mapPartitions` method expects a function handle
as argument, and the intention is to parameterize the function invocation with the additional
arguments (`mass` in this example). `plusFunc(mass)` will actually return a function handle
of a function that only takes one argument (the table `Tin`).

## Supported Data Types

Currently, not all datatypes are that exist in MATLAB&reg; and/or Spark are supported. The following table
describes what datatypes are supported, and if any restrictions apply.

> **Note:** Please note that the Datatypes listed below, refer to what is supported
> with the new _schema_ version of the library. Several of these types are not 
> supported in the earlier _JSON signature_ version of the library.
> It is recommended to switch to the new workflow.

| Spark Datatype        | MATLAB Datatype   | Remark |
| --------------------- | ----------------- | ------ |
| BinaryType            | uint8 array       |        |
| BooleanType           | logical           |        |
| ByteType              | int8              |        |
| ShortType             | int16             |        |
| IntegerType           | int32             |        |
| DoubleType            | double            |        |
| FloatType             | single            |        |
| LongType              | int64             |        |
| DateType              | datetime          |        |
| TimestampType         | datetime          |        |
| DayTimeIntervalType   | duration          |        |
| StringType            | string            | Currently only support `string`, not `char`       |
| StructType            | struct            |        |
| ArrayType             | an array          | N1     |
| MapType               | a map/dictionary  | N2     |
| DecimalType           | decimal           | Will be converted to a double in MATLAB&reg;. Precision loss possible. |

### Notes

#### N1

An array column must always be a cell array. The reason for this is that a
square column, i.e. an array column where each row has the same number of
elements could be just a matrix in MATLAB&reg;.

```matlabsession
>> id=[1;2];
>> arr = [1,2;3,4];
>> T = table(id, arr)
T =
  2x2 table
    id     arr  
    __    ______
    1     1    2
    2     3    4
```

The arrays in a Spark DataFrame column, however, can be of different length, and
this can only be done in MATLAB&reg; with a cell array.

```matlabsession
>> id=[1;2];
>> arr = {1;[2,3]};
>> T = table(id, arr)
T =
  2×2 table
    id      arr  
    __    _______
    1     {[  1]}
    2     {[2 3]}
```

An array, that is not a column, but a subtype in a column, should be a normal
array.

```matlabsession
>> id=[1;2];
>> s = [struct('Name', 'A', 'Val', [1,2,3]); struct('Name', 'B', 'Val', [1,2])];
>> T = table(id,s)
T =
  2×2 table
    id        s     
    __    __________
    1     1×1 struct
    2     1×1 struct
>> T.s(1)
ans = 
  struct with fields:

    Name: 'A'
     Val: [1 2 3]
>> T.s(2)
ans = 
  struct with fields:

    Name: 'B'
     Val: [1 2]
```

#### N2

The `MapType` has some restrictions, imposed either by Spark, Python&reg; or MATLAB&reg;.

The `keyType` cannot be a `StructType`, a `MapType` or an `ArrayType`. Basically
no compound types.

The `valueType` cannot be an `ArrayType` or a `MapType`.

### Footnotes

[^1]: The terms `DataFrame` and `Dataset` are used interchangeably in this text,
although the data is almost invariably a `DataFrame`.

[//]: #  (Copyright 2021-2025 The MathWorks, Inc.)
