# Dataframes and columns

Apache&reg; Spark&trade; provides different methods on `Dataframe` and `Column` classes for
retrieving columns, filtering, etc.

## General usage

### PySpark

When working in Python&reg; using PySpark, one might use the following syntax.

Load a Dataframe:

```python
df = spark.sql("SELECT * FROM main.default.outages")
df.printSchema()
# root
#  |-- Region: string (nullable = true)
#  |-- OutageTime: timestamp (nullable = true)
#  |-- Loss: double (nullable = true)
#  |-- Customers: double (nullable = true)
#  |-- RestorationTime: timestamp (nullable = true)
#  |-- Cause: string (nullable = true)

print(f'Rows: {df.count()}')
# Rows: 1468
```

Pick a column:

```python
c1 = df['Region']
# Column<'Region'>

# Alternatively
c1_ = df.Region
```

Pick a few columns of a Dataframe:

```python
df2 = df[['Region', 'Loss']]
df2.printSchema()
# root
#  |-- Region: string (nullable = true)
#  |-- Loss: double (nullable = true) 
```

Filter a dataframe according to columns:

```python
filter_column = df['Cause'].isin("winter storm", "attack")
# Column<'(Cause IN (winter storm, attack))'>

# Alternatively
filter_column_ = df.Cause.isin("winter storm", "attack")
# Column<'(Cause IN (winter storm, attack))'>

filtered_df = df[filter_column]
print(f'Rows: {filtered_df.count()}')
# Rows: 439

# Alternative, all in one:
filtered_df_ = df[df['Cause'].isin("winter storm", "attack")]
print(f'Rows: {filtered_df_.count()}')
# Rows: 439
```

### MATLAB

In MATLAB&reg;, it looks similar to the dot-notation variant. The actual usage of the
Python bracket (`[]`) syntax is supported by a hidden `bracket` function. This
is not intended to be called directly by the user, but may explain some of the
code better. It will also be shown in the examples.

Load a Dataframe (exactly the same):

```matlabsession
>> df = spark.sql("SELECT * FROM main.default.outages");
>> df.printSchema()

df = 
  Dataframe with no properties.
root
 |-- Region: string (nullable = true)
 |-- OutageTime: timestamp (nullable = true)
 |-- Loss: double (nullable = true)
 |-- Customers: double (nullable = true)
 |-- RestorationTime: timestamp (nullable = true)
 |-- Cause: string (nullable = true)


>> df.count()
ans =
  int64
   1468
```

Pick a column

```matlabsession
>> c1 = df.Region
c1 = 
  Column with properties:

    Label: "Column<'Region'>"
    
% Alternatively
>> c1_ = df.bracket("Region")
c1_ = 
  Column with properties:

    Label: "Column<'Region'>"
```

Pick a few columns of a Dataframe

```matlabsession
>> df2 = df.(["Region", "Loss"])
df2 = 
  Dataframe with no properties.
>> df2.printSchema()
root
 |-- Region: string (nullable = true)
 |-- Loss: double (nullable = true)

% Alternative 1
>> df2_1 = df.({'Region', 'Loss'})
df2_1 = 
  Dataframe with no properties.
>> df2_1.printSchema()
root
 |-- Region: string (nullable = true)
 |-- Loss: double (nullable = true)

% Alternative 2
>> df2_2 = df.bracket({'Region', 'Loss'})
df2_2 = 
  Dataframe with no properties.
>> df2_2.printSchema
root
 |-- Region: string (nullable = true)
 |-- Loss: double (nullable = true)
```

Filter a dataframe according to columns

```matlabsession
>> filter_column = df.Cause.isin("winter storm", "attack")
filter_column = 
  Column with properties:

    Label: "Column<'in(Cause, winter storm, attack)'>"
    
% Alternatively
>> filter_column = df.bracket('Cause').isin("winter storm", "attack")
filter_column = 
  Column with properties:

    Label: "Column<'in(Cause, winter storm, attack)'>"

>> filtered_df = df.(filter_column)
filtered_df = 
  Dataframe with no properties.
>> filtered_df.count()
ans =
  int64
   439

% Alternative, all in one
>> filtered_df = df.(df.Cause.isin("winter storm", "attack"))
filtered_df = 
  Dataframe with no properties.
>> filtered_df.count()
ans =
  int64
   439
```

## Considerations

The fact that the `.` can be overloaded relies on the mixin class
`matlab.mixin.indexing.RedefinesDot`. The `Dataframe` class inherits from this
class.

It will use the arguments after the dot, and try to apply them with the `bracket`
method, enabling a streamlined workflow. There are some things to consider, though.

### Column indexing

Column indexing in Apache Spark is zero-based, so this is used here too, although
not typical for MATLAB&reg;. The aim being to be more interoperable with Spark syntax
in other languages.

In Python:

```python
df = spark.sql("SELECT * FROM main.default.outages")
df.printSchema()
# root
#  |-- Region: string (nullable = true)
#  |-- OutageTime: timestamp (nullable = true)
#  |-- Loss: double (nullable = true)
#  |-- Customers: double (nullable = true)
#  |-- RestorationTime: timestamp (nullable = true)
#  |-- Cause: string (nullable = true)

df[0]
# Column<'Region'>

df[2]
# Column<'Loss'>
```

In MATLAB&reg;:

```matlabsession
>> df = spark.sql("SELECT * FROM main.default.outages");
>> df.printSchema()

df = 
  Dataframe with no properties.
root
 |-- Region: string (nullable = true)
 |-- OutageTime: timestamp (nullable = true)
 |-- Loss: double (nullable = true)
 |-- Customers: double (nullable = true)
 |-- RestorationTime: timestamp (nullable = true)
 |-- Cause: string (nullable = true)

>> df.(0)
ans = 
  Column with properties:

    Label: "Column<'Region'>"

>> df.(2)
ans = 
  Column with properties:

    Label: "Column<'Loss'>"
```

> **Note:** Please be aware that a numbered column cannot be used with plain
> dot-notation, i.e. df.0 will fail, whereas df.(0) will work.

### Chaining dots

In the example above, we chained several operations:

```matlab
filter_col = df.Cause.isin("winter storm", "attack")
```

The first part, `df.Cause`, will return a `Column` object. For this operation,
so the rest of second operation will be on a different class of objects.

We can view the operations like this:

```matlab
tmp_col = df.Cause
filter_col = tmp_col.isin("winter storm", "attack")
```

The second part, `isin`, is calling a method on the resulting `Column` object.
This works in this code, by relying on syntactic sugar to call a method or
retrieve a field, if possible.

Another example that demonstrates this is:

```matlabsession
>> df.Region.string
ans = 
    "Column<'Region'>"
```

There may, however, be other combinations that don't work. Be aware of this.
An alternative to the first example could be either the splitting up, as shown
above, or explicitly using the `bracket` method.

```matlab
filter_col = df.bracket('Cause').isin("winter storm", "attack")
```

In this example, the first part, `df.bracket('Cause')`, will simply return a column,
and the next operation is applied on that.

### Non-named columns

As seen in the example, something like `df.Region` will be similar to Python's
`df['region']`. When the column referred to is not simply a name, the dynamic
field name should be used. Similarly to how variable can be used with a field name
to retrieve a field from a struct:

```matlab
myField = 'Age';
age = myStruct.(myField);
```

In this case, as with the filtered `Dataframe`, a dynamic field name must be used.

```matlab
filtered_df = df.(filter_column)
```

### Unsupported column names

All column names can be retrieved, but not all column names can be retrieved with
the dot notation.

#### Other fields or methods of Dataframe

If there is a dataset with a name `col`, this cannot be retrieved with `df.col`,
as `col` is already a method, which takes precedence.

```matlabsession
>> df_ = spark.range(10);
>> df = df_.withColumn('col', df_.id).withColumn('columns', df_.id)
df = 
  Dataframe with no properties.
>> df.show(3)
+---+---+-------+
| id|col|columns|
+---+---+-------+
|  0|  0|      0|
|  1|  1|      1|
|  2|  2|      2|
+---+---+-------+
only showing top 3 rows
```

Different options can be evaluated:

```matlabsession
>> df.col
Error using matlab.pyspark.sql.dataframe.Dataframe/col (line 27)
Invalid argument list. Function requires 1 more input(s). 

>> df.('col')
Error using matlab.pyspark.sql.dataframe.Dataframe/col (line 27)
Invalid argument list. Function requires 1 more input(s). 

>> df.bracket('col')
ans = 
  Column with no properties.
```

Only the last function will work in this case.

For `columns`, it is a bit different. This will not error out, as it does not
need arguments. However, it will not return a column object as one might expect.

```matlabsession
>> df.columns
ans = 
  1×3 string array
    "id"    "col"    "columns"
>> df.('columns')
ans = 
  1×3 string array
    "id"    "col"    "columns"
>> df.bracket('columns')
ans = 
  Column with no properties.
```

[//]: #  (Copyright 2025 The MathWorks, Inc.)
