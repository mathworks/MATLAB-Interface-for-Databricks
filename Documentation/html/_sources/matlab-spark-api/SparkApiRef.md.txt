# MATLAB Interface *for Apache Spark* (matlab.pyspark) - API Reference

This document includes API reference information for the following namespaces or functions:

* [matlab.pyspark.sql.column](#matlabpysparksqlcolumn)
* [matlab.pyspark.sql.dataframe](#matlabpysparksqldataframe)
* [matlab.pyspark.sql.functions](#matlabpysparksqlfunctions)
* [matlab.pyspark.sql.session](#matlabpysparksqlsession)
* [matlab.sparkutils.table2dataset](#matlabsparkutilstable2dataset)

Classes, methods and functions that include the terms `private` or `internal` in their namespace should not be used directly.
They are subject to change or removal without notice.

## Index

* MATLAB&reg; Interface *for Apache&reg; Spark&trade;* (matlab.pyspark)
  * [matlab.pyspark.sql.column](#matlabpysparksqlcolumn)
    * [matlab.pyspark.sql.column.Column](#matlabpysparksqlcolumncolumn)
      * [matlab.pyspark.sql.column.Column.Column](#matlabpysparksqlcolumncolumncolumn)
      * [matlab.pyspark.sql.column.Column.alias](#matlabpysparksqlcolumncolumnalias)
      * [matlab.pyspark.sql.column.Column.and](#matlabpysparksqlcolumncolumnand)
      * [matlab.pyspark.sql.column.Column.asc](#matlabpysparksqlcolumncolumnasc)
      * [matlab.pyspark.sql.column.Column.asc_nulls_first](#matlabpysparksqlcolumncolumnasc_nulls_first)
      * [matlab.pyspark.sql.column.Column.asc_nulls_last](#matlabpysparksqlcolumncolumnasc_nulls_last)
      * [matlab.pyspark.sql.column.Column.astype](#matlabpysparksqlcolumncolumnastype)
      * [matlab.pyspark.sql.column.Column.between](#matlabpysparksqlcolumncolumnbetween)
      * [matlab.pyspark.sql.column.Column.bitwiseAND](#matlabpysparksqlcolumncolumnbitwiseand)
      * [matlab.pyspark.sql.column.Column.bitwiseOR](#matlabpysparksqlcolumncolumnbitwiseor)
      * [matlab.pyspark.sql.column.Column.bitwiseXOR](#matlabpysparksqlcolumncolumnbitwisexor)
      * [matlab.pyspark.sql.column.Column.cast](#matlabpysparksqlcolumncolumncast)
      * [matlab.pyspark.sql.column.Column.contains](#matlabpysparksqlcolumncolumncontains)
      * [matlab.pyspark.sql.column.Column.desc](#matlabpysparksqlcolumncolumndesc)
      * [matlab.pyspark.sql.column.Column.desc_nulls_first](#matlabpysparksqlcolumncolumndesc_nulls_first)
      * [matlab.pyspark.sql.column.Column.desc_nulls_last](#matlabpysparksqlcolumncolumndesc_nulls_last)
      * [matlab.pyspark.sql.column.Column.divide](#matlabpysparksqlcolumncolumndivide)
      * [matlab.pyspark.sql.column.Column.endswith](#matlabpysparksqlcolumncolumnendswith)
      * [matlab.pyspark.sql.column.Column.eq](#matlabpysparksqlcolumncolumneq)
      * [matlab.pyspark.sql.column.Column.ge](#matlabpysparksqlcolumncolumnge)
      * [matlab.pyspark.sql.column.Column.gt](#matlabpysparksqlcolumncolumngt)
      * [matlab.pyspark.sql.column.Column.ilike](#matlabpysparksqlcolumncolumnilike)
      * [matlab.pyspark.sql.column.Column.isNaN](#matlabpysparksqlcolumncolumnisnan)
      * [matlab.pyspark.sql.column.Column.isNotNull](#matlabpysparksqlcolumncolumnisnotnull)
      * [matlab.pyspark.sql.column.Column.isNull](#matlabpysparksqlcolumncolumnisnull)
      * [matlab.pyspark.sql.column.Column.isin](#matlabpysparksqlcolumncolumnisin)
      * [matlab.pyspark.sql.column.Column.le](#matlabpysparksqlcolumncolumnle)
      * [matlab.pyspark.sql.column.Column.like](#matlabpysparksqlcolumncolumnlike)
      * [matlab.pyspark.sql.column.Column.lt](#matlabpysparksqlcolumncolumnlt)
      * [matlab.pyspark.sql.column.Column.minus](#matlabpysparksqlcolumncolumnminus)
      * [matlab.pyspark.sql.column.Column.mrdivide](#matlabpysparksqlcolumncolumnmrdivide)
      * [matlab.pyspark.sql.column.Column.mtimes](#matlabpysparksqlcolumncolumnmtimes)
      * [matlab.pyspark.sql.column.Column.multiply](#matlabpysparksqlcolumncolumnmultiply)
      * [matlab.pyspark.sql.column.Column.ne](#matlabpysparksqlcolumncolumnne)
      * [matlab.pyspark.sql.column.Column.not](#matlabpysparksqlcolumncolumnnot)
      * [matlab.pyspark.sql.column.Column.or](#matlabpysparksqlcolumncolumnor)
      * [matlab.pyspark.sql.column.Column.otherwise_](#matlabpysparksqlcolumncolumnotherwise_)
      * [matlab.pyspark.sql.column.Column.over](#matlabpysparksqlcolumncolumnover)
      * [matlab.pyspark.sql.column.Column.plus](#matlabpysparksqlcolumncolumnplus)
      * [matlab.pyspark.sql.column.Column.rdivide](#matlabpysparksqlcolumncolumnrdivide)
      * [matlab.pyspark.sql.column.Column.rem](#matlabpysparksqlcolumncolumnrem)
      * [matlab.pyspark.sql.column.Column.rlike](#matlabpysparksqlcolumncolumnrlike)
      * [matlab.pyspark.sql.column.Column.startswith](#matlabpysparksqlcolumncolumnstartswith)
      * [matlab.pyspark.sql.column.Column.string](#matlabpysparksqlcolumncolumnstring)
      * [matlab.pyspark.sql.column.Column.times](#matlabpysparksqlcolumncolumntimes)
      * [matlab.pyspark.sql.column.Column.toPy](#matlabpysparksqlcolumncolumntopy)
      * [matlab.pyspark.sql.column.Column.uminus](#matlabpysparksqlcolumncolumnuminus)
      * [matlab.pyspark.sql.column.Column.when](#matlabpysparksqlcolumncolumnwhen)
  * [matlab.pyspark.sql.dataframe](#matlabpysparksqldataframe)
    * [matlab.pyspark.sql.dataframe.internal](#matlabpysparksqldataframeinternal)
      * [matlab.pyspark.sql.dataframe.internal.pdf2table](#matlabpysparksqldataframeinternalpdf2table)
    * [matlab.pyspark.sql.dataframe.DataFrameNaFunctions](#matlabpysparksqldataframedataframenafunctions)
      * [matlab.pyspark.sql.dataframe.DataFrameNaFunctions.DataFrameNaFunctions](#matlabpysparksqldataframedataframenafunctionsdataframenafunctions)
      * [matlab.pyspark.sql.dataframe.DataFrameNaFunctions.drop](#matlabpysparksqldataframedataframenafunctionsdrop)
      * [matlab.pyspark.sql.dataframe.DataFrameNaFunctions.fill](#matlabpysparksqldataframedataframenafunctionsfill)
      * [matlab.pyspark.sql.dataframe.DataFrameNaFunctions.toPy](#matlabpysparksqldataframedataframenafunctionstopy)
    * [matlab.pyspark.sql.dataframe.Dataframe](#matlabpysparksqldataframedataframe)
      * [matlab.pyspark.sql.dataframe.Dataframe.Dataframe](#matlabpysparksqldataframedataframedataframe)
      * [matlab.pyspark.sql.dataframe.Dataframe.agg](#matlabpysparksqldataframedataframeagg)
      * [matlab.pyspark.sql.dataframe.Dataframe.alias](#matlabpysparksqldataframedataframealias)
      * [matlab.pyspark.sql.dataframe.Dataframe.bracket](#matlabpysparksqldataframedataframebracket)
      * [matlab.pyspark.sql.dataframe.Dataframe.cache](#matlabpysparksqldataframedataframecache)
      * [matlab.pyspark.sql.dataframe.Dataframe.col](#matlabpysparksqldataframedataframecol)
      * [matlab.pyspark.sql.dataframe.Dataframe.columns](#matlabpysparksqldataframedataframecolumns)
      * [matlab.pyspark.sql.dataframe.Dataframe.count](#matlabpysparksqldataframedataframecount)
      * [matlab.pyspark.sql.dataframe.Dataframe.createOrReplaceTempView](#matlabpysparksqldataframedataframecreateorreplacetempview)
      * [matlab.pyspark.sql.dataframe.Dataframe.describe](#matlabpysparksqldataframedataframedescribe)
      * [matlab.pyspark.sql.dataframe.Dataframe.distinct](#matlabpysparksqldataframedataframedistinct)
      * [matlab.pyspark.sql.dataframe.Dataframe.dotAssign](#matlabpysparksqldataframedataframedotassign)
      * [matlab.pyspark.sql.dataframe.Dataframe.dotListLength](#matlabpysparksqldataframedataframedotlistlength)
      * [matlab.pyspark.sql.dataframe.Dataframe.dotReference](#matlabpysparksqldataframedataframedotreference)
      * [matlab.pyspark.sql.dataframe.Dataframe.drop](#matlabpysparksqldataframedataframedrop)
      * [matlab.pyspark.sql.dataframe.Dataframe.dropDuplicates](#matlabpysparksqldataframedataframedropduplicates)
      * [matlab.pyspark.sql.dataframe.Dataframe.dropna](#matlabpysparksqldataframedataframedropna)
      * [matlab.pyspark.sql.dataframe.Dataframe.filter](#matlabpysparksqldataframedataframefilter)
      * [matlab.pyspark.sql.dataframe.Dataframe.getSetUseToArrow](#matlabpysparksqldataframedataframegetsetusetoarrow)
      * [matlab.pyspark.sql.dataframe.Dataframe.groupBy](#matlabpysparksqldataframedataframegroupby)
      * [matlab.pyspark.sql.dataframe.Dataframe.isEmpty](#matlabpysparksqldataframedataframeisempty)
      * [matlab.pyspark.sql.dataframe.Dataframe.join](#matlabpysparksqldataframedataframejoin)
      * [matlab.pyspark.sql.dataframe.Dataframe.limit](#matlabpysparksqldataframedataframelimit)
      * [matlab.pyspark.sql.dataframe.Dataframe.mapInPandas](#matlabpysparksqldataframedataframemapinpandas)
      * [matlab.pyspark.sql.dataframe.Dataframe.na](#matlabpysparksqldataframedataframena)
      * [matlab.pyspark.sql.dataframe.Dataframe.orderBy](#matlabpysparksqldataframedataframeorderby)
      * [matlab.pyspark.sql.dataframe.Dataframe.printSchema](#matlabpysparksqldataframedataframeprintschema)
      * [matlab.pyspark.sql.dataframe.Dataframe.repartition](#matlabpysparksqldataframedataframerepartition)
      * [matlab.pyspark.sql.dataframe.Dataframe.repartitionByRange](#matlabpysparksqldataframedataframerepartitionbyrange)
      * [matlab.pyspark.sql.dataframe.Dataframe.sample](#matlabpysparksqldataframedataframesample)
      * [matlab.pyspark.sql.dataframe.Dataframe.schema](#matlabpysparksqldataframedataframeschema)
      * [matlab.pyspark.sql.dataframe.Dataframe.select](#matlabpysparksqldataframedataframeselect)
      * [matlab.pyspark.sql.dataframe.Dataframe.show](#matlabpysparksqldataframedataframeshow)
      * [matlab.pyspark.sql.dataframe.Dataframe.sort](#matlabpysparksqldataframedataframesort)
      * [matlab.pyspark.sql.dataframe.Dataframe.summary](#matlabpysparksqldataframedataframesummary)
      * [matlab.pyspark.sql.dataframe.Dataframe.table](#matlabpysparksqldataframedataframetable)
      * [matlab.pyspark.sql.dataframe.Dataframe.table_R2023b](#matlabpysparksqldataframedataframetable_r2023b)
      * [matlab.pyspark.sql.dataframe.Dataframe.toDF](#matlabpysparksqldataframedataframetodf)
      * [matlab.pyspark.sql.dataframe.Dataframe.toPandas](#matlabpysparksqldataframedataframetopandas)
      * [matlab.pyspark.sql.dataframe.Dataframe.toPy](#matlabpysparksqldataframedataframetopy)
      * [matlab.pyspark.sql.dataframe.Dataframe.transform](#matlabpysparksqldataframedataframetransform)
      * [matlab.pyspark.sql.dataframe.Dataframe.where](#matlabpysparksqldataframedataframewhere)
      * [matlab.pyspark.sql.dataframe.Dataframe.withColumn](#matlabpysparksqldataframedataframewithcolumn)
      * [matlab.pyspark.sql.dataframe.Dataframe.withColumnRenamed](#matlabpysparksqldataframedataframewithcolumnrenamed)
      * [matlab.pyspark.sql.dataframe.Dataframe.write](#matlabpysparksqldataframedataframewrite)
  * [matlab.pyspark.sql.functions](#matlabpysparksqlfunctions)
    * [matlab.pyspark.sql.functions.abs](#matlabpysparksqlfunctionsabs)
    * [matlab.pyspark.sql.functions.acos](#matlabpysparksqlfunctionsacos)
    * [matlab.pyspark.sql.functions.acosh](#matlabpysparksqlfunctionsacosh)
    * [matlab.pyspark.sql.functions.add_months](#matlabpysparksqlfunctionsadd_months)
    * [matlab.pyspark.sql.functions.array](#matlabpysparksqlfunctionsarray)
    * [matlab.pyspark.sql.functions.asc](#matlabpysparksqlfunctionsasc)
    * [matlab.pyspark.sql.functions.asin](#matlabpysparksqlfunctionsasin)
    * [matlab.pyspark.sql.functions.asinh](#matlabpysparksqlfunctionsasinh)
    * [matlab.pyspark.sql.functions.atan](#matlabpysparksqlfunctionsatan)
    * [matlab.pyspark.sql.functions.atan2](#matlabpysparksqlfunctionsatan2)
    * [matlab.pyspark.sql.functions.atanh](#matlabpysparksqlfunctionsatanh)
    * [matlab.pyspark.sql.functions.ceil](#matlabpysparksqlfunctionsceil)
    * [matlab.pyspark.sql.functions.col](#matlabpysparksqlfunctionscol)
    * [matlab.pyspark.sql.functions.column](#matlabpysparksqlfunctionscolumn)
    * [matlab.pyspark.sql.functions.concat](#matlabpysparksqlfunctionsconcat)
    * [matlab.pyspark.sql.functions.cos](#matlabpysparksqlfunctionscos)
    * [matlab.pyspark.sql.functions.cosh](#matlabpysparksqlfunctionscosh)
    * [matlab.pyspark.sql.functions.cot](#matlabpysparksqlfunctionscot)
    * [matlab.pyspark.sql.functions.count](#matlabpysparksqlfunctionscount)
    * [matlab.pyspark.sql.functions.count_distinct](#matlabpysparksqlfunctionscount_distinct)
    * [matlab.pyspark.sql.functions.curdate](#matlabpysparksqlfunctionscurdate)
    * [matlab.pyspark.sql.functions.current_date](#matlabpysparksqlfunctionscurrent_date)
    * [matlab.pyspark.sql.functions.current_timestamp](#matlabpysparksqlfunctionscurrent_timestamp)
    * [matlab.pyspark.sql.functions.current_timezone](#matlabpysparksqlfunctionscurrent_timezone)
    * [matlab.pyspark.sql.functions.current_user](#matlabpysparksqlfunctionscurrent_user)
    * [matlab.pyspark.sql.functions.date_add](#matlabpysparksqlfunctionsdate_add)
    * [matlab.pyspark.sql.functions.date_format](#matlabpysparksqlfunctionsdate_format)
    * [matlab.pyspark.sql.functions.date_sub](#matlabpysparksqlfunctionsdate_sub)
    * [matlab.pyspark.sql.functions.dayofmonth](#matlabpysparksqlfunctionsdayofmonth)
    * [matlab.pyspark.sql.functions.dayofweek](#matlabpysparksqlfunctionsdayofweek)
    * [matlab.pyspark.sql.functions.dayofyear](#matlabpysparksqlfunctionsdayofyear)
    * [matlab.pyspark.sql.functions.desc](#matlabpysparksqlfunctionsdesc)
    * [matlab.pyspark.sql.functions.e](#matlabpysparksqlfunctionse)
    * [matlab.pyspark.sql.functions.exp](#matlabpysparksqlfunctionsexp)
    * [matlab.pyspark.sql.functions.expr](#matlabpysparksqlfunctionsexpr)
    * [matlab.pyspark.sql.functions.first](#matlabpysparksqlfunctionsfirst)
    * [matlab.pyspark.sql.functions.floor](#matlabpysparksqlfunctionsfloor)
    * [matlab.pyspark.sql.functions.from_unixtime](#matlabpysparksqlfunctionsfrom_unixtime)
    * [matlab.pyspark.sql.functions.from_utc_timestamp](#matlabpysparksqlfunctionsfrom_utc_timestamp)
    * [matlab.pyspark.sql.functions.hour](#matlabpysparksqlfunctionshour)
    * [matlab.pyspark.sql.functions.isnan](#matlabpysparksqlfunctionsisnan)
    * [matlab.pyspark.sql.functions.isnotnull](#matlabpysparksqlfunctionsisnotnull)
    * [matlab.pyspark.sql.functions.isnull](#matlabpysparksqlfunctionsisnull)
    * [matlab.pyspark.sql.functions.length](#matlabpysparksqlfunctionslength)
    * [matlab.pyspark.sql.functions.lit](#matlabpysparksqlfunctionslit)
    * [matlab.pyspark.sql.functions.ln](#matlabpysparksqlfunctionsln)
    * [matlab.pyspark.sql.functions.log](#matlabpysparksqlfunctionslog)
    * [matlab.pyspark.sql.functions.log10](#matlabpysparksqlfunctionslog10)
    * [matlab.pyspark.sql.functions.log1p](#matlabpysparksqlfunctionslog1p)
    * [matlab.pyspark.sql.functions.log2](#matlabpysparksqlfunctionslog2)
    * [matlab.pyspark.sql.functions.make_date](#matlabpysparksqlfunctionsmake_date)
    * [matlab.pyspark.sql.functions.make_timestamp](#matlabpysparksqlfunctionsmake_timestamp)
    * [matlab.pyspark.sql.functions.make_timestamp_ltz](#matlabpysparksqlfunctionsmake_timestamp_ltz)
    * [matlab.pyspark.sql.functions.make_timestamp_ntz](#matlabpysparksqlfunctionsmake_timestamp_ntz)
    * [matlab.pyspark.sql.functions.max](#matlabpysparksqlfunctionsmax)
    * [matlab.pyspark.sql.functions.mean](#matlabpysparksqlfunctionsmean)
    * [matlab.pyspark.sql.functions.min](#matlabpysparksqlfunctionsmin)
    * [matlab.pyspark.sql.functions.minute](#matlabpysparksqlfunctionsminute)
    * [matlab.pyspark.sql.functions.monotonically_increasing_id](#matlabpysparksqlfunctionsmonotonically_increasing_id)
    * [matlab.pyspark.sql.functions.month](#matlabpysparksqlfunctionsmonth)
    * [matlab.pyspark.sql.functions.percent_rank](#matlabpysparksqlfunctionspercent_rank)
    * [matlab.pyspark.sql.functions.pi](#matlabpysparksqlfunctionspi)
    * [matlab.pyspark.sql.functions.pow](#matlabpysparksqlfunctionspow)
    * [matlab.pyspark.sql.functions.power](#matlabpysparksqlfunctionspower)
    * [matlab.pyspark.sql.functions.product](#matlabpysparksqlfunctionsproduct)
    * [matlab.pyspark.sql.functions.rand](#matlabpysparksqlfunctionsrand)
    * [matlab.pyspark.sql.functions.randn](#matlabpysparksqlfunctionsrandn)
    * [matlab.pyspark.sql.functions.randstr](#matlabpysparksqlfunctionsrandstr)
    * [matlab.pyspark.sql.functions.rank](#matlabpysparksqlfunctionsrank)
    * [matlab.pyspark.sql.functions.round](#matlabpysparksqlfunctionsround)
    * [matlab.pyspark.sql.functions.row_number](#matlabpysparksqlfunctionsrow_number)
    * [matlab.pyspark.sql.functions.second](#matlabpysparksqlfunctionssecond)
    * [matlab.pyspark.sql.functions.sin](#matlabpysparksqlfunctionssin)
    * [matlab.pyspark.sql.functions.sinh](#matlabpysparksqlfunctionssinh)
    * [matlab.pyspark.sql.functions.spark_partition_id](#matlabpysparksqlfunctionsspark_partition_id)
    * [matlab.pyspark.sql.functions.sqrt](#matlabpysparksqlfunctionssqrt)
    * [matlab.pyspark.sql.functions.sum](#matlabpysparksqlfunctionssum)
    * [matlab.pyspark.sql.functions.tan](#matlabpysparksqlfunctionstan)
    * [matlab.pyspark.sql.functions.tanh](#matlabpysparksqlfunctionstanh)
    * [matlab.pyspark.sql.functions.to_date](#matlabpysparksqlfunctionsto_date)
    * [matlab.pyspark.sql.functions.to_timestamp](#matlabpysparksqlfunctionsto_timestamp)
    * [matlab.pyspark.sql.functions.transform](#matlabpysparksqlfunctionstransform)
    * [matlab.pyspark.sql.functions.unix_timestamp](#matlabpysparksqlfunctionsunix_timestamp)
    * [matlab.pyspark.sql.functions.weekofyear](#matlabpysparksqlfunctionsweekofyear)
    * [matlab.pyspark.sql.functions.when](#matlabpysparksqlfunctionswhen)
    * [matlab.pyspark.sql.functions.window](#matlabpysparksqlfunctionswindow)
    * [matlab.pyspark.sql.functions.year](#matlabpysparksqlfunctionsyear)
  * [matlab.pyspark.sql.session](#matlabpysparksqlsession)
    * [matlab.pyspark.sql.session.SparkSession](#matlabpysparksqlsessionsparksession)
      * [matlab.pyspark.sql.session.SparkSession.SparkSession](#matlabpysparksqlsessionsparksessionsparksession)
      * [matlab.pyspark.sql.session.SparkSession.addArtifact](#matlabpysparksqlsessionsparksessionaddartifact)
      * [matlab.pyspark.sql.session.SparkSession.catalog](#matlabpysparksqlsessionsparksessioncatalog)
      * [matlab.pyspark.sql.session.SparkSession.createDataFrame](#matlabpysparksqlsessionsparksessioncreatedataframe)
      * [matlab.pyspark.sql.session.SparkSession.delete](#matlabpysparksqlsessionsparksessiondelete)
      * [matlab.pyspark.sql.session.SparkSession.range](#matlabpysparksqlsessionsparksessionrange)
      * [matlab.pyspark.sql.session.SparkSession.read](#matlabpysparksqlsessionsparksessionread)
      * [matlab.pyspark.sql.session.SparkSession.session_id](#matlabpysparksqlsessionsparksessionsession_id)
      * [matlab.pyspark.sql.session.SparkSession.sql](#matlabpysparksqlsessionsparksessionsql)
      * [matlab.pyspark.sql.session.SparkSession.stop](#matlabpysparksqlsessionsparksessionstop)
      * [matlab.pyspark.sql.session.SparkSession.table](#matlabpysparksqlsessionsparksessiontable)
      * [matlab.pyspark.sql.session.SparkSession.toPy](#matlabpysparksqlsessionsparksessiontopy)
      * [matlab.pyspark.sql.session.SparkSession.version](#matlabpysparksqlsessionsparksessionversion)
  * [matlab.sparkutils](#matlabsparkutils)
    * [matlab.sparkutils.table2dataset](#matlabsparkutilstable2dataset)

## Help

### matlab.pyspark.sql.column

### matlab.pyspark.sql.column.Column

Superclass: matlab.pyspark.internal.PyWrapper

```text
Column - A pyspark column
```

#### matlab.pyspark.sql.column.Column.Column

```text
Column - A pyspark column

    Documentation for matlab.pyspark.sql.column.Column
```

#### matlab.pyspark.sql.column.Column.alias

```text
alias Returns the column aliased with a new name or names
 
  Example:
    R = spark.range(10);
    R.select(R.('id').alias('new_Id')).show(3)
```

#### matlab.pyspark.sql.column.Column.and

```text
and - Find logical AND

    Syntax
      A & B
      and(A,B)

    Input Arguments
      A - Operands
        scalars | vectors | matrices | multidimensional arrays | tables |
        timetables
      B - Operands
        scalars | vectors | matrices | multidimensional arrays | tables |
        timetables

    Examples
      openExample('matlab/LocateNonzeroValuesExample')
      openExample('matlab/TruthTableForLogicalANDExample')
      openExample('matlab/LogicalANDOfTablesExample')

    See also any, all, bitand, xor, or, not

    Introduced in MATLAB before R2006a
    Documentation for and
       doc and
```

#### matlab.pyspark.sql.column.Column.asc

```text
asc - Ascending sort of column
```

#### matlab.pyspark.sql.column.Column.asc_nulls_first

```text
asc_nulls_first - Ascending sort of column
```

#### matlab.pyspark.sql.column.Column.asc_nulls_last

```text
asc_nulls_last - Ascending sort of column
```

#### matlab.pyspark.sql.column.Column.astype

```text
astype - Sames as cast
```

#### matlab.pyspark.sql.column.Column.between

```text
between
```

#### matlab.pyspark.sql.column.Column.bitwiseAND

```text
bitwiseAND
```

#### matlab.pyspark.sql.column.Column.bitwiseOR

```text
bitwiseOR
```

#### matlab.pyspark.sql.column.Column.bitwiseXOR

```text
bitwiseXOR
```

#### matlab.pyspark.sql.column.Column.cast

```text
COL Cast the type of a column
 
  Example:
 
      % C1 is a column with a number but in string form
 
      % Cast it to an integer
      newCol = C1.cast('int');
```

#### matlab.pyspark.sql.column.Column.contains

```text
contains
```

#### matlab.pyspark.sql.column.Column.desc

```text
desc - Descending sort of column
```

#### matlab.pyspark.sql.column.Column.desc_nulls_first

```text
desc_nulls_first - Descending sort of column
```

#### matlab.pyspark.sql.column.Column.desc_nulls_last

```text
desc_nulls_last - Descending sort of column
```

#### matlab.pyspark.sql.column.Column.divide

```text
matlab.pyspark.sql.column.Column/divide is a function.
    col = divide(obj, other)
```

#### matlab.pyspark.sql.column.Column.endswith

```text
endswith
```

#### matlab.pyspark.sql.column.Column.eq

```text
eq - Determine equality

    Syntax
      A == B
      eq(A,B)

    Input Arguments
      A - Operands
        scalars | vectors | matrices | multidimensional arrays | tables |
        timetables
      B - Operands
        scalars | vectors | matrices | multidimensional arrays | tables |
        timetables

    Examples
      openExample('matlab/EqualityOfTwoVectorsExample')
      openExample('matlab/FindCharactersInStringExample')
      openExample('matlab/FindValuesInCategoricalArrayExample')
      openExample('matlab/CompareFloatingPointNumbersExample')
      openExample('matlab/CompareDatetimeValuesExample')
      openExample('matlab/CompareTablesExample')

    See also isapprox, ge, gt, le, lt, ne

    Introduced in MATLAB before R2006a
    Documentation for eq
       doc eq
```

#### matlab.pyspark.sql.column.Column.ge

```text
ge - Determine greater than or equal to

    Syntax
      A >= B
      ge(A,B)

    Input Arguments
      A - Operands
        scalars | vectors | matrices | multidimensional arrays | tables |
        timetables
      B - Operands
        scalars | vectors | matrices | multidimensional arrays | tables |
        timetables

    Examples
      openExample('matlab/TestVectorElementsExample')
      openExample('matlab/ReplaceElementsofMatrixExample')
      openExample('matlab/CompareValuesinCategoricalArrayExample')
      openExample('matlab/TestComplexNumbersExample')
      openExample('matlab/TestDurationValuesGeExample')
      openExample('matlab/CompareTablesGEExample')

    See also eq, lt, gt, le, ne

    Introduced in MATLAB before R2006a
    Documentation for ge
       doc ge
```

#### matlab.pyspark.sql.column.Column.gt

```text
gt - Determine greater than

    Syntax
      A > B
      gt(A,B)

    Input Arguments
      A - Operands
        scalars | vectors | matrices | multidimensional arrays | tables |
        timetables
      B - Operands
        scalars | vectors | matrices | multidimensional arrays | tables |
        timetables

    Examples
      openExample('matlab/TestVectorElementsGreaterThanExample')
      openExample('matlab/ReplaceElementsofMatrixGreaterExample')
      openExample('matlab/CompareValuesinCategoricalArrayGreaterExample')
      openExample('matlab/TestComplexNumbersGreaterExample')
      openExample('matlab/CompareDatesExample')
      openExample('matlab/CompareTablesGTExample')

    See also eq, ge, lt, le, ne

    Introduced in MATLAB before R2006a
    Documentation for gt
       doc gt
```

#### matlab.pyspark.sql.column.Column.ilike

```text
ilike SQL ilike command
```

#### matlab.pyspark.sql.column.Column.isNaN

```text
isNaN
```

#### matlab.pyspark.sql.column.Column.isNotNull

```text
isNotNull
```

#### matlab.pyspark.sql.column.Column.isNull

```text
isNull
```

#### matlab.pyspark.sql.column.Column.isin

```text
isin - Column of booleans showing whether each element in the Column is contained in cols
```

#### matlab.pyspark.sql.column.Column.le

```text
le - Determine less than or equal to

    Syntax
      A <= B
      le(A,B)

    Input Arguments
      A - Operands
        scalars | vectors | matrices | multidimensional arrays | tables |
        timetables
      B - Operands
        scalars | vectors | matrices | multidimensional arrays | tables |
        timetables

    Examples
      openExample('matlab/TestVectorElementsLessThanOrEqualExample')
      openExample('matlab/ReplaceElementsOfMatrixLessThanOrEqualExample')
      openExample('matlab/CompareValuesInCategoricalArrayLessThanOrEqualExample')
      openExample('matlab/TestComplexNumbersLessThanEqualExample')
      openExample('matlab/TestDurationValuesExample')
      openExample('matlab/CompareTablesLEExample')

    See also eq, ge, gt, lt, ne

    Introduced in MATLAB before R2006a
    Documentation for le
       doc le
```

#### matlab.pyspark.sql.column.Column.like

```text
like SQL like command
```

#### matlab.pyspark.sql.column.Column.lt

```text
lt - Determine less than

    Syntax
      A < B
      lt(A,B)

    Input Arguments
      A - Operands
        scalars | vectors | matrices | multidimensional arrays | tables |
        timetables
      B - Operands
        scalars | vectors | matrices | multidimensional arrays | tables |
        timetables

    Examples
      openExample('matlab/TestVectorElementsLessThanExample')
      openExample('matlab/ReplaceElementsofMatrixLessThanExample')
      openExample('matlab/CompareValuesinCategoricalArrayLessThanExample')
      openExample('matlab/TestComplexNumbersLessThanExample')
      openExample('matlab/CompareDatesLessThanExample')
      openExample('matlab/CompareTablesLTExample')

    See also eq, ge, gt, le, ne

    Introduced in MATLAB before R2006a
    Documentation for lt
       doc lt
```

#### matlab.pyspark.sql.column.Column.minus

```text
minus - Subtraction

    Syntax
      C = A - B
      C = minus(A,B)

    Input Arguments
      A - Operands
        scalars | vectors | matrices | multidimensional arrays | tables |
        timetables
      B - Operands
        scalars | vectors | matrices | multidimensional arrays | tables |
        timetables

    Examples
      openExample('matlab/SubtractScalarfromArrayExample')
      openExample('matlab/SubtractTwoArraysExample')
      openExample('matlab/SubtractRowAndColumnVectorsExample')
      openExample('matlab/SubtractMeanFromMatrixExample')
      openExample('matlab/SubtractTablesExample')

    See also plus, diff, uminus

    Introduced in MATLAB before R2006a
    Documentation for minus
       doc minus
```

#### matlab.pyspark.sql.column.Column.mrdivide

```text
mrdivide - Solve systems of linear equations xA = B for x

    Syntax
      x = B/A
      x = mrdivide(B,A)

    Input Arguments
      A - Operands
        vectors | full matrices | sparse matrices
      B - Operands
        vectors | full matrices | sparse matrices

    Output Arguments
      x - Solution
        vector | full matrix | sparse matrix

    Examples
      openExample('matlab/SystemofEquationsMrDivideExample')
      openExample('matlab/LeastSquaresonanUnderdeterminedSystemExample')

    See also mldivide, ldivide, rdivide, inv, transpose, decomposition

    Introduced in MATLAB before R2006a
    Documentation for mrdivide
       doc mrdivide
```

#### matlab.pyspark.sql.column.Column.mtimes

```text
mtimes - Matrix multiplication

    Syntax
      C = A*B
      C = mtimes(A,B)

    Input Arguments
      A - Operands
        scalars | vectors | matrices
      B - Operands
        scalars | vectors | matrices

    Output Arguments
      C - Product
        scalar | vector | matrix

    Examples
      openExample('matlab/MultiplyTwoVectorsExample')
      openExample('matlab/MultiplyTwoArraysExample')

    See also colon, times, dot, cross, pagemtimes, tensorprod

    Introduced in MATLAB before R2006a
    Documentation for mtimes
       doc mtimes
```

#### matlab.pyspark.sql.column.Column.multiply

```text
matlab.pyspark.sql.column.Column/multiply is a function.
    col = multiply(obj, other)
```

#### matlab.pyspark.sql.column.Column.ne

```text
ne - Determine inequality

    Syntax
      A ~= B
      ne(A,B)

    Input Arguments
      A - Operands
        scalars | vectors | matrices | multidimensional arrays | tables |
        timetables
      B - Operands
        scalars | vectors | matrices | multidimensional arrays | tables |
        timetables

    Examples
      openExample('matlab/InequalityOfTwoVectorsExample')
      openExample('matlab/FindCharactersInStringNotEqualExample')
      openExample('matlab/FindValuesInCategoricalArrayNotEqualExample')
      openExample('matlab/CompareFloatingPointNumbersNotEqualExample')
      openExample('matlab/InequalityOfTwoDatetimeArraysExample')
      openExample('matlab/CompareTablesNEExample')

    See also ge, gt, le, lt, eq

    Introduced in MATLAB before R2006a
    Documentation for ne
       doc ne
```

#### matlab.pyspark.sql.column.Column.not

```text
not - Find logical NOT

    Syntax
      ~A
      not(A)

    Input Arguments
      A - Input array
        scalar | vector | matrix | multidimensional array | table |
        timetable

    Examples
      openExample('matlab/LogicalNegationOfMatrixExample')
      openExample('matlab/ConditionalCodeExecutionExample')
      openExample('matlab/LogicalNOTOfTableExample')

    See also any, all, bitcmp, xor, and, or

    Introduced in MATLAB before R2006a
    Documentation for not
       doc not
```

#### matlab.pyspark.sql.column.Column.or

```text
or - Find logical OR

    Syntax
      A | B
      or(A,B)

    Input Arguments
      A - Operands
        scalars | vectors | matrices | multidimensional arrays | tables |
        timetables
      B - Operands
        scalars | vectors | matrices | multidimensional arrays | tables |
        timetables

    Examples
      openExample('matlab/LocateZerosInMatricesExample')
      openExample('matlab/TruthTableForLogicalORExample')
      openExample('matlab/LogicalOROfTablesExample')

    See also any, all, bitor, xor, and, not

    Introduced in MATLAB before R2006a
    Documentation for or
       doc or
```

#### matlab.pyspark.sql.column.Column.otherwise_

```text
otherwise_ Used with when condition
 
  With added underscore, as otherwise is a reserved word in MATLAB
 
  df = spark.createDataFrame(py.str('[(2, "Alice"), (5, "Bob")]'), schema=["age", "name"]);
  df.select(df.name, ...
      matlab.pyspark.sql.functions.when(df.age > 3, int32(1)).otherwise_(int32(0))).show()
  +-----+---------------------------------------+
  | name|CASE WHEN (age > 3.0) THEN 1 ELSE 0 END|
  +-----+---------------------------------------+
  |Alice|                                      0|
  |  Bob|                                      1|
  +-----+---------------------------------------+
```

#### matlab.pyspark.sql.column.Column.over

```text
matlab.pyspark.sql.column.Column/over is a function.
    col = over(obj, window)
```

#### matlab.pyspark.sql.column.Column.plus

```text
plus - Add numbers, append strings

    Syntax
      C = A + B
      C = plus(A,B)

    Input Arguments
      A - Operands
        scalars | vectors | matrices | multidimensional arrays | tables |
        timetables
      B - Operands
        scalars | vectors | matrices | multidimensional arrays | tables |
        timetables

    Examples
      openExample('matlab/AddScalartoArrayExample')
      openExample('matlab/ConcatenateStringsExample')
      openExample('matlab/AddTwoArraysExample')
      openExample('matlab/AddRowAndColumnVectorsExample')
      openExample('matlab/AddVectorToMatrixExample')
      openExample('matlab/AddTablesExample')

    See also minus, sum, cumsum, uplus, append

    Introduced in MATLAB before R2006a
    Documentation for plus
       doc plus
```

#### matlab.pyspark.sql.column.Column.rdivide

```text
rdivide - Right array division

    Syntax
      x = A./B
      x = rdivide(A,B)

    Input Arguments
      A - Operands
        scalars | vectors | matrices | multidimensional arrays | tables |
        timetables
      B - Operands
        scalars | vectors | matrices | multidimensional arrays | tables |
        timetables

    Examples
      openExample('matlab/DivideTwoNumericArraysRDivideExample')
      openExample('matlab/IntegerDivisionExample')
      openExample('matlab/DivideScalarbyArrayExample')
      openExample('matlab/RdivideRowAndColumnVectorsExample')
      openExample('matlab/RightDivideTablesExample')

    See also ldivide, mldivide, mrdivide, idivide

    Introduced in MATLAB before R2006a
    Documentation for rdivide
       doc rdivide
```

#### matlab.pyspark.sql.column.Column.rem

```text
rem Reminder of obj to other, i.e. obj % other
 
   obj should be a column, and other can be a column, a number
   or a string
```

#### matlab.pyspark.sql.column.Column.rlike

```text
rlike SQL rlike command
```

#### matlab.pyspark.sql.column.Column.startswith

```text
startswith
```

#### matlab.pyspark.sql.column.Column.string

```text
string - array
    You can represent text in MATLAB using string arrays where each element
    of a string array stores a sequence of characters.

    <strong>Creation</strong>
      <strong>Syntax</strong>
        Create Strings
          str = "text"
          str = ["text1" "text2" ...]
          str = "text1" + "text2"

        Convert Arrays
          str = string(A)

        Convert Dates and Times
          str = string(D,datefmt)
          str = string(D,datefmt,locale)

      <strong>Input Arguments</strong>
        <a href="matlab:web /usr/local/MATLAB/R2026a/help/matlab/ref/string.html#d127e1795519">A</a> - Input array
          array
        <a href="matlab:web /usr/local/MATLAB/R2026a/help/matlab/ref/string.html#mw_b6e2b88b-6616-47e8-a1c7-9b52e731dd7e">D</a> - Date or duration array
          datetime array | duration array | calendarDuration array
        <a href="matlab:web /usr/local/MATLAB/R2026a/help/matlab/ref/string.html#mw_6fa739af-87ce-4cd3-b00a-a4fdf5091950">datefmt</a> - Date Format and Locale
          character vectors | string scalars
        <a href="matlab:web /usr/local/MATLAB/R2026a/help/matlab/ref/string.html#mw_1ee124e1-8789-4aab-82f1-5ccba4bb9045">locale</a> - Locale
          character vector | string scalar

      <strong>Output Arguments</strong>
        <a href="matlab:web /usr/local/MATLAB/R2026a/help/matlab/ref/string.html#d127e1796057">str</a> - Output array
          string array

    <strong>Object Functions</strong>
      <a href="matlab:help string/contains -displayBanner">contains</a>       - Determine if pattern is in strings
      <a href="matlab:help string/count -displayBanner">count</a>          - Count occurrences of pattern in strings
      <a href="matlab:help string/endsWith -displayBanner">endsWith</a>       - Determine if strings end with pattern
      <a href="matlab:help string/matches -displayBanner">matches</a>        - Determine if pattern matches strings
      <a href="matlab:help string/startsWith -displayBanner">startsWith</a>     - Determine if strings start with pattern
      <a href="matlab:help string/compose -displayBanner">compose</a>        - Format data into multiple strings
      <a href="matlab:help string/erase -displayBanner">erase</a>          - Delete substrings within strings
      <a href="matlab:help string/eraseBetween -displayBanner">eraseBetween</a>   - Delete substrings between start and end points
      <a href="matlab:help string/extract -displayBanner">extract</a>        - Extract substrings from strings
      <a href="matlab:help string/extractAfter -displayBanner">extractAfter</a>   - Extract substrings after specified positions
      <a href="matlab:help string/extractBefore -displayBanner">extractBefore</a>  - Extract substrings before specified positions
      <a href="matlab:help string/extractBetween -displayBanner">extractBetween</a> - Extract substrings between start and end points
      <a href="matlab:help string/insertAfter -displayBanner">insertAfter</a>    - Insert strings after specified substrings
      <a href="matlab:help string/insertBefore -displayBanner">insertBefore</a>   - Insert strings before specified substrings
      <a href="matlab:help string/lower -displayBanner">lower</a>          - Convert strings to lowercase
      <a href="matlab:help string/pad -displayBanner">pad</a>            - Add leading or trailing characters to strings
      <a href="matlab:help string/replace -displayBanner">replace</a>        - Find and replace one or more substrings
      <a href="matlab:help string/replaceBetween -displayBanner">replaceBetween</a> - Replace substrings between start and end points
      <a href="matlab:help string/reverse -displayBanner">reverse</a>        - Reverse order of characters in strings
      <a href="matlab:help string/splitlines -displayBanner">splitlines</a>     - Split strings at newline characters
      <a href="matlab:help string/strip -displayBanner">strip</a>          - Remove leading and trailing characters from strings
      <a href="matlab:help string/upper -displayBanner">upper</a>          - Convert strings to uppercase
      <a href="matlab:help string/eq -displayBanner">eq</a>             - Determine equality
      <a href="matlab:help string/ge -displayBanner">ge</a>             - Determine greater than or equal to
      <a href="matlab:help string/gt -displayBanner">gt</a>             - Determine greater than
      <a href="matlab:help string/le -displayBanner">le</a>             - Determine less than or equal to
      <a href="matlab:help string/lt -displayBanner">lt</a>             - Determine less than
      <a href="matlab:help string/ne -displayBanner">ne</a>             - Determine inequality

    <strong>Examples</strong>
      <a href="matlab:openExample('matlab/CreateStringExample')">Create String</a>
      <a href="matlab:openExample('matlab/CreateStringArrayExample')">Create String Array</a>
      <a href="matlab:openExample('matlab/SplitStringAndFindUniqueWordsExample')">Split String and Find Unique Words</a>
      <a href="matlab:openExample('matlab/CreateStringFromCharacterVectorExample')">Convert Character Vector</a>
      <a href="matlab:openExample('matlab/CreateStringArrayFromCellArrayExample')">Convert Cell Array</a>
      <a href="matlab:openExample('matlab/ConvertNumbersToStringArraysExample')">Convert Numeric Array</a>
      <a href="matlab:openExample('matlab/ConvertStringsThatRepresentNumbersExample')">Convert Strings That Represent Numbers</a>
      <a href="matlab:openExample('matlab/ConvertDurationArrayToStringArrayExample')">Convert Duration Array</a>
      <a href="matlab:openExample('matlab/ConvertLocalizedDatetimeToStringExample')">Convert Localized Datetime to String</a>

    <strong>See also</strong> <a href="matlab:help append -displayBanner">append</a>, <a href="matlab:help string.contains -displayBanner">contains</a>, <a href="matlab:help string.matches -displayBanner">matches</a>, <a href="matlab:help string.startsWith -displayBanner">startsWith</a>, <a href="matlab:help string.replace -displayBanner">replace</a>, <a href="matlab:help string.replaceBetween -displayBanner">replaceBetween</a>,
      <a href="matlab:help split -displayBanner">split</a>, <a href="matlab:help string.extract -displayBanner">extract</a>, <a href="matlab:help extractBetween -displayBanner">extractBetween</a>, <a href="matlab:help char -displayBanner">char</a>, <a href="matlab:help cellstr -displayBanner">cellstr</a>, <a href="matlab:help strlength -displayBanner">strlength</a>, <a href="matlab:help isstring -displayBanner">isstring</a>,
      <a href="matlab:help strings -displayBanner">strings</a>, <a href="matlab:help compose -displayBanner">compose</a>, <a href="matlab:help sprintf -displayBanner">sprintf</a>

    Introduced in MATLAB in R2016b
    <a href="matlab:doc string">Documentation for string</a>
```

#### matlab.pyspark.sql.column.Column.times

```text
times - Multiplication

    Syntax
      C = A.*B
      C = times(A,B)

    Input Arguments
      A - Operands
        scalars | vectors | matrices | multidimensional arrays | tables |
        timetables
      B - Operands
        scalars | vectors | matrices | multidimensional arrays | tables |
        timetables

    Examples
      openExample('matlab/MultiplyTwoVectorsTimesExample')
      openExample('matlab/MultiplyTwoArraysTimesExample')
      openExample('matlab/MultiplyRowAndColumnVectorsExample')
      openExample('matlab/MultiplyTablesExample')

    See also mtimes

    Introduced in MATLAB before R2006a
    Documentation for times
       doc times
```

#### matlab.pyspark.sql.column.Column.toPy

```text
matlab.pyspark.sql.column.Column/toPy is a function.
    pyObj = toPy(obj)
```

#### matlab.pyspark.sql.column.Column.uminus

```text
uminus - Unary minus

    Syntax
      C = -A
      C = uminus(A)

    Input Arguments
      A - Input array
        scalar | vector | matrix | multidimensional array | table |
        timetable

    Examples
      openExample('matlab/NegateElementsofMatrixExample')

    See also minus, uplus

    Introduced in MATLAB before R2006a
    Documentation for uminus
       doc uminus
```

#### matlab.pyspark.sql.column.Column.when

```text
when condition/value choice
```

### matlab.pyspark.sql.dataframe

### matlab.pyspark.sql.dataframe.internal

### matlab.pyspark.sql.dataframe.internal.pdf2table

```text
PDF2TABLE Converts a Pandas DataFrame to a MATLAB table.
```

### matlab.pyspark.sql.dataframe.DataFrameNaFunctions

Superclass: matlab.pyspark.internal.PyWrapper

```text
DataFrameNaFunctions Pyspark DataFrameNaFunctions wrapper
```

#### matlab.pyspark.sql.dataframe.DataFrameNaFunctions.DataFrameNaFunctions

```text
DataFrameNaFunctions Pyspark DataFrameNaFunctions wrapper

    Documentation for matlab.pyspark.sql.dataframe.DataFrameNaFunctions
```

#### matlab.pyspark.sql.dataframe.DataFrameNaFunctions.drop

```text
drop Drop rows
```

#### matlab.pyspark.sql.dataframe.DataFrameNaFunctions.fill

```text
fill Fill columns with default value
 
   df is some table with missing double values in Customers
   column. Fill them with 0.0 like this:
     df2 = df.na.fill(0.0, subset="Customers")
```

#### matlab.pyspark.sql.dataframe.DataFrameNaFunctions.toPy

```text
matlab.pyspark.sql.dataframe.DataFrameNaFunctions/toPy is a function.
    pyObj = toPy(obj)
```

### matlab.pyspark.sql.dataframe.Dataframe

Superclasses: matlab.pyspark.internal.PyWrapper, matlab.mixin.indexing.RedefinesDot

```text
Dataframe Pyspark DataFrame wrapper
  
  This class is a wrapper for the pyspark Dataframe class,
  matlab.pyspark.sql.dataframe.Dataframe, and implements a large part
  of its methods.
```

#### matlab.pyspark.sql.dataframe.Dataframe.Dataframe

```text
Dataframe Pyspark DataFrame wrapper
  
  This class is a wrapper for the pyspark Dataframe class,
  matlab.pyspark.sql.dataframe.Dataframe, and implements a large part
  of its methods.

    Documentation for matlab.pyspark.sql.dataframe.Dataframe
```

#### matlab.pyspark.sql.dataframe.Dataframe.agg

```text
agg Aggregation method
 
  TODO: Currently only support columns, not dictionary
```

#### matlab.pyspark.sql.dataframe.Dataframe.alias

```text
alias Returns a new DataFrame with an alias set.
 
  Example:
  import matlab.pyspark.sql.functions.col
  import matlab.pyspark.sql.functions.desc
 
  spark = getDatabricksSession;
  df = spark.createDataFrame(py.str('[(14, "Tom"), (23, "Alice"), (16, "Bob")]'), schema={'age', 'name'});
  df_as1 = df.alias("df_as1");
  df_as2 = df.alias("df_as2");
  joined_df = df_as1.join(df_as2, on=col("df_as1.name") == col("df_as2.name"), how='inner');
  df2 = joined_df.select("df_as1.name", "df_as2.name", "df_as2.age").sort(desc("df_as1.name"));
  df2.show();
    +-----+-----+---+
    | name| name|age|
    +-----+-----+---+
    |  Tom|  Tom| 14|
    |  Bob|  Bob| 16|
    |Alice|Alice| 23|
    +-----+-----+---+
  
  t2 = table(df2)
  t2 =
   3x3 table
    name      name_1     age
   _______    _______    ___
   "Tom"      "Tom"      14 
   "Bob"      "Bob"      16 
   "Alice"    "Alice"    23
```

#### matlab.pyspark.sql.dataframe.Dataframe.bracket

```text
bracket Implement the df[arg] method
 
  This function is not targeted at general usage. It's supposed
  to handle bracket ([]) operations in Python in MATLAB.
  As an example:
    Python - df['a']
    MATLAB - df.bracket('a')
 
  Examples:
    % column foo
    DF.bracket('foo')  
    % column foo
    DF.bracket("foo")
    % fourth column (zero-based index)
    DF.bracket(3)      
 
    % DataFrame with foo and bar columns
    DF.bracket({"foo", "bar"})  
    % DataFrame with foo and bar columns
    DF.bracket(["foo", "bar"])
 
    % DataFrame filtered through column
    DF.bracket(aColumn)
    % DataFrame filtered through column
    DF.bracket(DF.bracket("foo").isin("3", "4"))
```

#### matlab.pyspark.sql.dataframe.Dataframe.cache

```text
cache - Cache Dataframe
```

#### matlab.pyspark.sql.dataframe.Dataframe.col

```text
col Retrieving a column from a Dataframe
 
  Whereas this can retrieve a column, the dot-notation can also be
  used for many, use cases.
 
     c1 = DF.col('age')
     c2 = DF.age
 
   c1 and c2 will refer to the same column here.
 
  Please refer to the document DataframeColumns.md in the
  matlab-spark-api/Documentation directory for more information.
```

#### matlab.pyspark.sql.dataframe.Dataframe.columns

```text
columns - Return column names
```

#### matlab.pyspark.sql.dataframe.Dataframe.count

```text
count Counts the number of rows
```

#### matlab.pyspark.sql.dataframe.Dataframe.createOrReplaceTempView

```text
createOrReplaceTempView Create a temporary view
```

#### matlab.pyspark.sql.dataframe.Dataframe.describe

```text
describe Describe columns (statistics)
```

#### matlab.pyspark.sql.dataframe.Dataframe.distinct

```text
distinct - Returns a new DataFrame containing the distinct rows in this DataFrame.
```

#### matlab.pyspark.sql.dataframe.Dataframe.dotAssign

```text
dotAssign  Overload dot indexed assignment
     obj = dotAssign(obj, indexOp, varargin) is called by MATLAB
     for indexed assignment statements that begin with dot. Classes
     that inherit from RedefinesDot must implement this protected
     method. The dotAssign method must interpret the
     IndexingOperation argument indexOp, modify the obj argument
     based on the right-hand side values in varargin, and return
     the modified object.
 
     In a simple assignment such as
         obj.label = val;
     MATLAB calls dotAssign with the object obj and an
     IndexingOperation with a single element whose Type property is
     Dot and Name property is the string "label". The third input
     argument to dotAssign is the right-hand side value val.
 
     In a compound comma-separated list assignment such as
         [obj.(var){:}] = rhs{:};
     MATLAB first calls dotListLength on obj to determine how many
     inputs the object expects to receive in dotAssign. Assuming
     that the right-hand side provides enough values, dotAssign
     will be called with an IndexingOperation with two elements
     describing the Dot and Brace indexing in the statement. The
     values from the right-hand side are passed to dotAssign as
     varargin.
 
     The dotAssign method is not called for properties and
     methods that are accessible in the present context.
 
     Class authors can often handle compound indexing expressions
     by forwarding some or all of the later indexing operations to
     another object. For more information, look for 'forwarding
     indexing' in the documentation.
 
     See also dotListLength, dotReference,
              matlab.indexing.IndexingOperation

Help for matlab.pyspark.sql.dataframe.Dataframe/dotAssign is inherited from superclass matlab.mixin.indexing.RedefinesDot
```

#### matlab.pyspark.sql.dataframe.Dataframe.dotListLength

```text
Assuming our methods will always return a value
```

#### matlab.pyspark.sql.dataframe.Dataframe.dotReference

```text
dotReference  Overload dot indexed reference
     varargout = dotReference(obj, indexOp) is called by MATLAB for
     indexed reference expressions that begin with dot. Classes
     that inherit from RedefinesDot must implement this protected
     method. The dotReference method must interpret the
     IndexingOperation argument indexOp and return the correct
     number of requested outputs as varargout.
 
     In a simple statement such as 
         y = obj.label; 
     MATLAB calls dotReference with the object obj and an
     IndexingOperation with a single element whose Type property is
     Dot and whose Name property is the string "label".
 
     In a compound reference statement such as 
         [y1, y2, y3] = obj.(var).subprop
     MATLAB calls dotReference with an IndexingOperation array with
     two elements whose Type properties are each Dot, and requests
     three outputs. The Name property of the first element is the
     value of the variable "var" and the Name property of the
     second element is the string "subprop".
 
     The dotReference method is not called for properties and
     methods that are accessible in the present context.
 
     Class authors can often handle compound indexing expressions
     by forwarding some or all of the later indexing operations to
     another object. For more information, look for 'forwarding
     indexing' in the documentation.
 
     See also dotAssign, dotListLength, 
              matlab.indexing.IndexingOperation

Help for matlab.pyspark.sql.dataframe.Dataframe/dotReference is inherited from superclass matlab.mixin.indexing.RedefinesDot
```

#### matlab.pyspark.sql.dataframe.Dataframe.drop

```text
drop Drop certain columns from Dataframe
```

#### matlab.pyspark.sql.dataframe.Dataframe.dropDuplicates

```text
dropDuplicates Drop duplicates
```

#### matlab.pyspark.sql.dataframe.Dataframe.dropna

```text
dropna Drop rows with NULL or NaN values
```

#### matlab.pyspark.sql.dataframe.Dataframe.filter

```text
filter Filter rows in a dataframe
```

#### matlab.pyspark.sql.dataframe.Dataframe.getSetUseToArrow

```text
Call getSetUseToArrow with a scalar logical value as the input
  argument to control whether DataFrame/table() uses
  arrow-based or pandas-based approach to import the Spark 
  DataFrame as a MATLAB table.
 
  Call getSetUseToArrow without an input argument to query the
  whether DataFrame/table() will use the arrow-based approach.
 
  NOTE: DataFrame/getSetUseToArrow(useToArrowValue) sets a 
  persistent variable that all DataFrame instances share.
```

#### matlab.pyspark.sql.dataframe.Dataframe.groupBy

```text
GROUPBY Group dataset by certain columns
 
  This will return a new RelationalGroupDataset
```

#### matlab.pyspark.sql.dataframe.Dataframe.isEmpty

```text
isEmpty Returns true for empty dataframe
```

#### matlab.pyspark.sql.dataframe.Dataframe.join

```text
join Database join
 
  Some syntax examples:
 
  R = spark.range(4)
  DF1 = R.withColumn("A", R.col('id').cast('string'))
  DF2 = R.withColumn("B", R.col('id').cast('double'))
  DF1.join(DF2).show()
  DF1.join(DF2, how="outer").show()
  DF1.join(DF2, how="left").show()
  DF1.join(DF2, on=DF1.col('id')==DF2.col('id'),how="left").show()
```

#### matlab.pyspark.sql.dataframe.Dataframe.limit

```text
limit - Limit size of dataframe
```

#### matlab.pyspark.sql.dataframe.Dataframe.mapInPandas

```text
mapInPandas - Run mapInPandas on a function and a schema
 
  This method applies mapInPandas on a specific function and
  schema. In the general case it's called like this:
 
    DF_OUT = DF.mapInPandas("someFunc", schema="someSchema);
 
  someFunc and someSchema must be available in the python environment.
 
  An alternative way of calling it, in the case a function was
  generated from MATLAB code (see PythonSparkBuilder).
 
    DF_OUT = DF.mapInPandas("myFunc");
 
  This calling will assume that the values available in the python
  environment are myFunc_mapInPandas and myFunc_output_schema.
```

#### matlab.pyspark.sql.dataframe.Dataframe.na

```text
na Get na object
```

#### matlab.pyspark.sql.dataframe.Dataframe.orderBy

```text
orderBy Sort a dataframe by columns
 
  This is an alias for sort
```

#### matlab.pyspark.sql.dataframe.Dataframe.printSchema

```text
printSchema Display the Dataset's underlying schema in the console
 
  Example:
 
      DS.printSchema()
```

#### matlab.pyspark.sql.dataframe.Dataframe.repartition

```text
matlab.pyspark.sql.dataframe.Dataframe/repartition is a function.
    df = repartition(obj, numPartitions, arg)
```

#### matlab.pyspark.sql.dataframe.Dataframe.repartitionByRange

```text
repartitionByRange 
 
  df = spark.createDataFrame(py.str('[(2, "Alice"), (5, "Bob")]'), ...
       schema=["age", "name"])
  df.repartitionByRange(2, "age") ...
      .select("age", "name", matlab.pyspark.sql.functions.spark_partition_id()).show()
    +---+-----+--------------------+
    |age| name|SPARK_PARTITION_ID()|
    +---+-----+--------------------+
    |  2|Alice|                   0|
    |  5|  Bob|                   1|
    +---+-----+--------------------+
```

#### matlab.pyspark.sql.dataframe.Dataframe.sample

```text
sample Create a temporary view
```

#### matlab.pyspark.sql.dataframe.Dataframe.schema

```text
schema Return MATLAB representation of Dataframe schema
```

#### matlab.pyspark.sql.dataframe.Dataframe.select

```text
SELECT Method to select columns by name
 
  SELECT(obj,columns) will return a new dataset that contains only the
  Example:
 
      % Create a dataset
      myLocation = '/test/*.parquet');
      myDataSet = spark...
          .read.format('parquet')...
          .option('header','true')...
          .option('inferSchema','true')...
          .load(myLocation);
 
      % Select a subset of the Dataset with just a few columns
      newDataSet = myDataSet.select("UniqueCarrier", "Day", "Month");
```

#### matlab.pyspark.sql.dataframe.Dataframe.show

```text
show - Show a Dataframe
```

#### matlab.pyspark.sql.dataframe.Dataframe.sort

```text
sort Sort a dataframe by columns
```

#### matlab.pyspark.sql.dataframe.Dataframe.summary

```text
summary Show summary of all/chosen columns
```

#### matlab.pyspark.sql.dataframe.Dataframe.table

```text
table - Convert Spark DataFrame to MATLAB table
```

#### matlab.pyspark.sql.dataframe.Dataframe.table_R2023b

```text
table - Convert Spark dataframe to MATLAB table
 
  This methods is necessary to handle release R2023b and earlier,
  as these releases have no conversion from Pandas Dataframe to MATLAB
  table.
```

#### matlab.pyspark.sql.dataframe.Dataframe.toDF

```text
toDF - Rename columns of a Dataframe
```

#### matlab.pyspark.sql.dataframe.Dataframe.toPandas

```text
toPandas Return Python Pandas Dataframe
```

#### matlab.pyspark.sql.dataframe.Dataframe.toPy

```text
matlab.pyspark.sql.dataframe.Dataframe/toPy is a function.
    pyObj = toPy(obj)
```

#### matlab.pyspark.sql.dataframe.Dataframe.transform

```text
transform Returns a new DataFrame. Concise syntax for chaining custom transformations.
 
  Here's a simple example on how the transform function can be used on
  Dataframes, either with MATLAB functions, or with Python functions.
 
      function DF_new = tf1(DF)
          import matlab.pyspark.sql.functions.lit
          DF_new = DF.withColumn("hello", lit("Hello"));
      end
     
      function pyTransform = tf2()
          funcDef = ...
              "def myfunc(DF):" + ...
              "    return DF.withColumn('doubled', DF['id'] * 2)";
          funcReturn = "a = myfunc";
          pyTransform = pyrun([funcDef, funcReturn], "a");
      end
 
      R = spark.range(5);
      DF = R.transform(@tf1).transform(tf2());
      DF.show()
      +---+-----+-------+
      | id|hello|doubled|
      +---+-----+-------+
      |  0|Hello|      0|
      |  1|Hello|      2|
      |  2|Hello|      4|
      |  3|Hello|      6|
      |  4|Hello|      8|
      +---+-----+-------+
```

#### matlab.pyspark.sql.dataframe.Dataframe.where

```text
where Filter rows in a dataframe (alias for filter)
```

#### matlab.pyspark.sql.dataframe.Dataframe.withColumn

```text
withColumn - Add a new column
```

#### matlab.pyspark.sql.dataframe.Dataframe.withColumnRenamed

```text
WITHCOLUMNRENAMED Rename one column in dataframe
```

#### matlab.pyspark.sql.dataframe.Dataframe.write

```text
matlab.pyspark.sql.dataframe.Dataframe/write is a function.
    writer = write(obj)
```

### matlab.pyspark.sql.functions

### matlab.pyspark.sql.functions.abs

```text
abs Absolute value
```

### matlab.pyspark.sql.functions.acos

```text
acos Arc cosine value
```

### matlab.pyspark.sql.functions.acosh

```text
ACOSH Computes the inverse hyperbolic cosine of the given column or expression
 
  Examples:
    % Create a sample DataFrame
    value = [1.0; 2.0; 5.0];
    T = table(value);
    df = matlab.sparkutils.table2dataset(T, spark);
 
    % Apply acosh function
    df.select(matlab.pyspark.sql.functions.acosh(df.col("value")).alias("acosh_value")).show()
    +------------------+
    |       acosh_value|
    +------------------+
    |               0.0|
    |1.3169578969248166|
    |2.2924316695611777|
    +------------------+
 
    %  Compute the inverse hyperbolic cosine
    df = spark.createDataFrame([1; 2], schema="value")
    df.select("*", matlab.pyspark.sql.functions.acosh(df.value)).show()
    +-----+------------------+
    |value|      ACOSH(value)|
    +-----+------------------+
    |  1.0|               0.0|
    |  2.0|1.3169578969248166|
    +-----+------------------+
 
    %  Compute the inverse hyperbolic cosine of invalid values
    spark.sql("SELECT * FROM VALUES (-0.5), (0.5), (NULL) AS TAB(value)").select("*", matlab.pyspark.sql.functions.acosh("value")).show()
    +-----+------------+
    |value|ACOSH(value)|
    +-----+------------+
    | -0.5|         NaN|
    |  0.5|         NaN|
    | NULL|        NULL|
    +-----+------------+
```

### matlab.pyspark.sql.functions.add_months

```text
add_months Add months to a column
```

### matlab.pyspark.sql.functions.array

```text
array Concatenate columns to an array
```

### matlab.pyspark.sql.functions.asc

```text
asc Returns sorted column, ascending
```

### matlab.pyspark.sql.functions.asin

```text
asin Arcsine value
```

### matlab.pyspark.sql.functions.asinh

```text
ASINH Computes the inverse hyperbolic sine of the given column or expression
 
  Examples:
    % Compute the inverse hyperbolic sine
    df = spark.createDataFrame(py.str('[(-0.5,), (0.0,), (0.5,)]'), schema="value");
    df.select("*", matlab.pyspark.sql.functions.asinh(df.value)).show()
    +-----+--------------------+
    |value|        ASINH(value)|
    +-----+--------------------+
    | -0.5|-0.48121182505960336|
    |  0.0|                 0.0|
    |  0.5| 0.48121182505960347|
    +-----+--------------------+
 
    % Compute the inverse hyperbolic sine of invalid values
    spark.sql("SELECT * FROM VALUES (FLOAT('NAN')), (NULL) AS TAB(value)").select("*", matlab.pyspark.sql.functions.asinh("value")).show()
    +-----+------------+
    |value|ASINH(value)|
    +-----+------------+
    |  NaN|         NaN|
    | NULL|        NULL|
    +-----+------------+
```

### matlab.pyspark.sql.functions.atan

```text
ATAN inverse tangent of the input column
 
  Examples:
    % Compute the inverse tangent
    df = spark.createDataFrame([-0.5; 0.0; 0.5], schema="value")
    df.select("*", matlab.pyspark.sql.functions.atan(df.value)).show()
    +-----+-------------------+
    |value|        ATAN(value)|
    +-----+-------------------+
    | -0.5|-0.4636476090008061|
    |  0.0|                0.0|
    |  0.5| 0.4636476090008061|
    +-----+-------------------+
 
    % Compute the inverse tangent of invalid values
    spark.sql("SELECT * FROM VALUES (FLOAT('NAN')), (NULL) AS TAB(value)").select(...
        "*", matlab.pyspark.sql.functions.atan("value")).show()
    +-----+-----------+
    |value|ATAN(value)|
    +-----+-----------+
    |  NaN|        NaN|
    | NULL|       NULL|
    +-----+-----------+
```

### matlab.pyspark.sql.functions.atan2

```text
ATAN2 Compute the angle in radians between the positive x-axis of a plane and the point given by the coordinates
 
  Example:
    spark.range(1).select(py.pyspark.sql.functions.atan2(...
        py.pyspark.sql.functions.lit(1),...
        py.pyspark.sql.functions.lit(2))).show()
 
    +------------------+
    |   ATAN2(1.0, 2.0)|
    +------------------+
    |0.4636476090008061|
    +------------------+
```

### matlab.pyspark.sql.functions.atanh

```text
ATANH Computes inverse hyperbolic tangent of the input column.
 
  Examples:
    % Create a sample DataFrame
    value = [1.0; 2.0; 5.0];
    T = table(value);
    df = matlab.sparkutils.table2dataset(T, spark);
 
    % Apply atanh function
    df.select(matlab.pyspark.sql.functions.atanh(df.col("value")).alias("atanh_value")).show()
    +-----------+
    |atanh_value|
    +-----------+
    |   Infinity|
    |        NaN|
    |        NaN|
    +-----------+
 
 
    % Compute the inverse hyperbolic sine
    df = spark.createDataFrame([-0.5; 0.0; 0.5], schema="value")
    df.select("*", matlab.pyspark.sql.functions.atanh(df.value)).show()
    +-----+-------------------+
    |value|       ATANH(value)|
    +-----+-------------------+
    | -0.5|-0.5493061443340548|
    |  0.0|                0.0|
    |  0.5| 0.5493061443340548|
    +-----+-------------------+
 
 
    % Compute the inverse hyperbolic sine of invalid values
    spark.sql("SELECT * FROM VALUES (-2), (2), (FLOAT('NAN')), (NULL) AS TAB(value)").select("*", matlab.pyspark.sql.functions.atanh("value")).show()
    +-----+------------+
    |value|ATANH(value)|
    +-----+------------+
    | -2.0|         NaN|
    |  2.0|         NaN|
    |  NaN|         NaN|
    | NULL|        NULL|
    +-----+------------+
```

### matlab.pyspark.sql.functions.ceil

```text
ceil Take ceil (rounding) of column
```

### matlab.pyspark.sql.functions.col

```text
col - Get column by name
```

### matlab.pyspark.sql.functions.column

```text
column Return a column from a name
```

### matlab.pyspark.sql.functions.concat

```text
concat Concatenates several columns
```

### matlab.pyspark.sql.functions.cos

```text
COS Computes cosine of the input column
 
  Examples:
    % Compute the cosine
    spark.sql("SELECT * FROM VALUES (PI()), (PI() / 4), (PI() / 16) AS TAB(value)").select(...
        "*", matlab.pyspark.sql.functions.cos("value")).show()
 
    +-------------------+------------------+
    |              value|        COS(value)|
    +-------------------+------------------+
    |  3.141592653589793|              -1.0|
    | 0.7853981633974483|0.7071067811865476|
    |0.19634954084936207|0.9807852804032304|
    +-------------------+------------------+
 
    % Compute the cosine of invalid values
    spark.sql("SELECT * FROM VALUES (FLOAT('NAN')), (NULL) AS TAB(value)").select(...
        "*", matlab.pyspark.sql.functions.cos("value")).show()
    +-----+----------+
    |value|COS(value)|
    +-----+----------+
    |  NaN|       NaN|
    | NULL|      NULL|
    +-----+----------+
```

### matlab.pyspark.sql.functions.cosh

```text
COSH Computes hyperbolic cosine of the input column
 
  Examples:
    df = spark.createDataFrame([-1; 0; 1], schema="value")
    df.select("*", matlab.pyspark.sql.functions.cosh(df.value)).show()
    +-----+------------------+
    |value|        COS(value)|
    +-----+------------------+
    | -1.0|0.5403023058681398|
    |  0.0|               1.0|
    |  1.0|0.5403023058681398|
    +-----+------------------+
 
    % Compute the invalid values
    spark.sql("SELECT * FROM VALUES (FLOAT('NAN')), (NULL) AS TAB(value)").select(...
        "*", matlab.pyspark.sql.functions.cosh("value")).show()
 
    +-----+-----------+
    |value|COSH(value)|
    +-----+-----------+
    |  NaN|        NaN|
    | NULL|       NULL|
    +-----+-----------+
```

### matlab.pyspark.sql.functions.cot

```text
COT Computes cotangent of the input column
 
  Examples:
    % Compute the cotangent
    spark.sql("SELECT * FROM VALUES (PI() / 4), (PI() / 16) AS TAB(value)").select(...
        "*", matlab.pyspark.sql.functions.cot("value")).show()
    +-------------------+------------------+
    |              value|        COT(value)|
    +-------------------+------------------+
    | 0.7853981633974483|1.3246090892520057|
    |0.19634954084936207|1.0193385817707588|
    +-------------------+------------------+
 
    % Compute the cotangent of invalid values
    spark.sql("SELECT * FROM VALUES (0.0), (FLOAT('NAN')), (NULL) AS TAB(value)").select("*", matlab.pyspark.sql.functions.cot("value")).show()
    +-----+----------+
    |value|COT(value)|
    +-----+----------+
    |  0.0|  Infinity|
    |  NaN|       NaN|
    | NULL|      NULL|
    +-----+----------+
```

### matlab.pyspark.sql.functions.count

```text
COUNT Aggregate function: returns the number of items in a group
 
  Examples:
    df = spark.createDataFrame([missing; "a"; "b"; "c"], schema="alphabets")
    df.select(matlab.pyspark.sql.functions.count(matlab.pyspark.sql.functions.expr("*"))).show()
    +--------+
    |count(1)|
    +--------+
    |       4|
    +--------+
 
    df.select(matlab.pyspark.sql.functions.count(df.alphabets)).show()
    +----------------+
    |count(alphabets)|
    +----------------+
    |               3|
    +----------------+
 
    % Python syntax
    df = spark.createDataFrame(py.str('([(1, "apple"), (2, "banana"), (3, None)])'), schema=["id", "fruit"])
    % Convert list of tuples
    df = spark.createDataFrame(py.list({py.tuple({1, "apple"}), py.tuple({2, "banana"}), py.tuple({3, py.None})}), schema=["id", "fruit"])
    df.select(matlab.pyspark.sql.functions.count(matlab.pyspark.sql.functions.expr("*"))).show()
    +--------+
    |count(1)|
    +--------+
    |       3|
    +--------+
 
    % Count non-null values in multiple columns
    df.select(matlab.pyspark.sql.functions.count(df.id), matlab.pyspark.sql.functions.count(df.fruit)).show()
    +---------+------------+
    |count(id)|count(fruit)|
    +---------+------------+
    |        3|           2|
    +---------+------------+
```

### matlab.pyspark.sql.functions.count_distinct

```text
COUNT_DISTINCT Returns a new Column for distinct count of col or cols
 
  Examples:
    % Counting distinct values of a single column
    df = spark.createDataFrame(py.str('[(1,), (1,), (3,)]'), schema=["value"])
    df.select(matlab.pyspark.sql.functions.count_distinct(df.value)).show()
    +---------------------+
    |count(DISTINCT value)|
    +---------------------+
    |                    2|
    +---------------------+
 
    % Counting distinct values of multiple columns
    df = spark.createDataFrame(py.str('[(1, 1), (1, 2)]'), schema=["value1", "value2"])
    df.select(matlab.pyspark.sql.functions.count_distinct(df.value1, df.value2)).show()
    +------------------------------+
    |count(DISTINCT value1, value2)|
    +------------------------------+
    |                             2|
    +------------------------------+
 
    % Counting distinct values with column names as strings
    df = spark.createDataFrame(py.str('[(1, 1), (1, 2)]'), schema=["value1", "value2"])
    df.select(matlab.pyspark.sql.functions.count_distinct("value1", "value2")).show()
    +------------------------------+
    |count(DISTINCT value1, value2)|
    +------------------------------+
    |                             2|
    +------------------------------+
```

### matlab.pyspark.sql.functions.curdate

```text
CURDATE Returns the current date at the start of query evaluation as a DateType column
  All calls of current_date within the same query return the same value.
 
  Example:
    spark.range(1).select(matlab.pyspark.sql.functions.curdate()).show() 
    +--------------+
    |current_date()|
    +--------------+
    |    2026-04-29|
    +--------------+
```

### matlab.pyspark.sql.functions.current_date

```text
current_date Current date
```

### matlab.pyspark.sql.functions.current_timestamp

```text
CURRENT_TIMESTAMP Returns the current timestamp at the start of query evaluation as a TimestampType column
  All calls of current_timestamp within the same query return the same value.
 
  Example:
    spark.range(1).select(matlab.pyspark.sql.functions.current_timestamp()).show()
    +-------------------+
    |current_timestamp()|
    +-------------------+
    |2026-04-29 10:56:08|
    +-------------------+
```

### matlab.pyspark.sql.functions.current_timezone

```text
CURRENT_TIMEZONE Returns the current session local timezone
 
  Example:
    spark.range(1).select(matlab.pyspark.sql.functions.current_timezone()).show()
    +------------------+
    |current_timezone()|
    +------------------+
    |           Etc/UTC|
    +------------------+
```

### matlab.pyspark.sql.functions.current_user

```text
CURRENT_TIMEZONE Returns the current user
 
  Example:
    spark.range(1).select(matlab.pyspark.sql.functions.current_user()).show()
    +--------------------+
    |      current_user()|
    +--------------------+
    |     joe@example.com|
    +--------------------+
```

### matlab.pyspark.sql.functions.date_add

```text
date_add Add days to a column
```

### matlab.pyspark.sql.functions.date_format

```text
date_format Convert time/date column to string column
```

### matlab.pyspark.sql.functions.date_sub

```text
date_sub Sbutract days from a column
```

### matlab.pyspark.sql.functions.dayofmonth

```text
dayofmonth Extract dayofmonth from a column
```

### matlab.pyspark.sql.functions.dayofweek

```text
dayofweek Extract dayofweek from a column
```

### matlab.pyspark.sql.functions.dayofyear

```text
dayofyear Extract dayofyear from a column
```

### matlab.pyspark.sql.functions.desc

```text
desc Returns sorted column, descending
```

### matlab.pyspark.sql.functions.e

```text
E Returns Euler’s number
 
  Example:
    spark.range(1).select(matlab.pyspark.sql.functions.e()).show()
    +-----------------+
    |              E()|
    +-----------------+
    |2.718281828459045|
    +-----------------+
```

### matlab.pyspark.sql.functions.exp

```text
EXP Computes the exponential of the given value
 
  Examples:
    df = spark.sql("SELECT id AS value FROM RANGE(5)")
    df.select("*", matlab.pyspark.sql.functions.exp(df.value)).show()
    +-----+------------------+
    |value|        EXP(value)|
    +-----+------------------+
    |    0|               1.0|
    |    1| 2.718281828459045|
    |    2|  7.38905609893065|
    |    3|20.085536923187668|
    |    4|54.598150033144236|
    +-----+------------------+
```

### matlab.pyspark.sql.functions.expr

```text
EXPR Parses the expression string into the column that it represents
 
  Examples:
    df = spark.createDataFrame(["Alice"; "Bob"], schema="name")
    df.select("*", matlab.pyspark.sql.functions.expr("length(name)")).show()
    +-----+------------+
    | name|length(name)|
    +-----+------------+
    |Alice|           5|
    |  Bob|           3|
    +-----+------------+
```

### matlab.pyspark.sql.functions.first

```text
FIRST Aggregate function: returns the first value in a group
 
  The function by default returns the first values it sees.
  It will return the first non-null value it sees when ignoreNulls
  is set to true. If all values are null, then null is returned.
 
  The function is non-deterministic because its results depends on the order
  of the rows which may be non-deterministic after a shuffle.
 
  Examples:
    df = spark.createDataFrame(py.str('[("Alice", 2), ("Bob", 5), ("Alice", None)]'), schema=["name", "age"])
    df = df.orderBy(df.age)
    df.groupBy("name").agg(matlab.pyspark.sql.functions.first("age")).orderBy("name").show()
    +-----+----------+
    | name|first(age)|
    +-----+----------+
    |Alice|      NULL|
    |  Bob|         5|
    +-----+----------+
 
    df.groupBy("name").agg(matlab.pyspark.sql.functions.first("age", true)).orderBy("name").show()
    +-----+----------+
    | name|first(age)|
    +-----+----------+
    |Alice|         2|
    |  Bob|         5|
    +-----+----------+
```

### matlab.pyspark.sql.functions.floor

```text
floor Take floor (rounding) of column
```

### matlab.pyspark.sql.functions.from_unixtime

```text
from_unixtime Convert column from unix time
```

### matlab.pyspark.sql.functions.from_utc_timestamp

```text
from_utc_timestamp Convert time/date from UTC to TZ
```

### matlab.pyspark.sql.functions.hour

```text
hour Extract hour from a column
```

### matlab.pyspark.sql.functions.isnan

```text
ISNAN An expression that returns true if the column is NaN
 
  Example:
    df = spark.createDataFrame(py.list({py.tuple({1.0, nan}), py.tuple({nan, 2.0})}), schema=["a", "b"])
    df.select("*", matlab.pyspark.sql.functions.isnan("a"), matlab.pyspark.sql.functions.isnan(df.b)).show()
    +---+---+--------+--------+
    |  a|  b|isnan(a)|isnan(b)|
    +---+---+--------+--------+
    |1.0|NaN|   false|    true|
    |NaN|2.0|    true|   false|
    +---+---+--------+--------+
```

### matlab.pyspark.sql.functions.isnotnull

```text
ISNOTNULL Returns true if col is not null, or false otherwise
 
  Examples:
    df = spark.createDataFrame({py.None; 1}, schema="e")
    df.select('*', matlab.pyspark.sql.functions.isnotnull(df.e)).show()
    +----+---------------+
    |   e|(e IS NOT NULL)|
    +----+---------------+
    |NULL|          false|
    | 1.0|           true|
    +----+---------------+
 
    df.select('*', matlab.pyspark.sql.functions.isnotnull('e')).show()
    +----+---------------+
    |   e|(e IS NOT NULL)|
    +----+---------------+
    |NULL|          false|
    | 1.0|           true|
    +----+---------------+
```

### matlab.pyspark.sql.functions.isnull

```text
ISNULL An expression that returns true if the column is null
 
  Example:
    df = spark.createDataFrame(py.list({py.tuple({1, py.None}), py.tuple({py.None, 2})}), schema = ["a", "b"])
    df.select("*", matlab.pyspark.sql.functions.isnull("a"), matlab.pyspark.sql.functions.isnull(df.b)).show()
    +----+----+-----------+-----------+
    |   a|   b|(a IS NULL)|(b IS NULL)|
    +----+----+-----------+-----------+
    | 1.0|NULL|      false|       true|
    |NULL| 2.0|       true|      false|
    +----+----+-----------+-----------+
```

### matlab.pyspark.sql.functions.length

```text
LENGTH Computes the character length of string data or number of bytes of binary data.
  The length of character data includes the trailing spaces.
  The length of binary data includes binary zeros.
 
  Example:
    spark.createDataFrame("ABC ", schema="a").select('*', matlab.pyspark.sql.functions.length('a')).show()
    +----+---------+
    |   a|length(a)|
    +----+---------+
    |ABC |        4|
    +----+---------+
```

### matlab.pyspark.sql.functions.lit

```text
LIT Creates a column containing a constant value
 
  This function will return a new column with a literal value.
```

### matlab.pyspark.sql.functions.ln

```text
LN Returns the natural logarithm of the argument
 
  Example:
    spark.range(10).select("*", matlab.pyspark.sql.functions.ln('id')).show()
```

### matlab.pyspark.sql.functions.log

```text
LOG Returns the first argument-based logarithm of the second argument
  If there is only one argument, then this takes the natural logarithm of
  the argument.
 
  Arguments:
    arg1: Column, text or numeric
    base number or actual number (in this case base is e)
 
    arg2: Column, text or numeric, optional
    number to calculate logarithm for
 
  Examples:
    df = spark.sql("SELECT * FROM VALUES (1), (2), (4) AS t(value)")
    df.select("*", matlab.pyspark.sql.functions.log(2.0, df.value)).show()
    +-----+---------------+
    |value|LOG(2.0, value)|
    +-----+---------------+
    |    1|            0.0|
    |    2|            1.0|
    |    4|            2.0|
    +-----+---------------+
 
    df = spark.sql("SELECT * FROM VALUES (1), (2), (0), (-1), (NULL) AS t(value)")
    df.select("*", matlab.pyspark.sql.functions.log(3.0, df.value)).show()
    +-----+------------------+
    +-----+------------------+
    |value|   LOG(3.0, value)|
    +-----+------------------+
    |    1|               0.0|
    |    2|0.6309297535714575|
    |    0|              NULL|
    |   -1|              NULL|
    | NULL|              NULL|
    +-----+------------------+
 
    df = spark.sql("SELECT * FROM VALUES (1), (2), (4) AS t(value)")
    df.select("*", matlab.pyspark.sql.functions.log(df.value)).show()
    +-----+------------------+
    |value|         ln(value)|
    +-----+------------------+
    |    1|               0.0|
    |    2|0.6931471805599453|
    |    4|1.3862943611198906|
    +-----+------------------+
```

### matlab.pyspark.sql.functions.log10

```text
LOG10 Returns Base-10 logarithm of col
 
  Examples:
    % Compute the logarithm in Base 10
    df = spark.createDataFrame(py.str("[(1,), (10,), (100,)]"), schema = ["value"])
    df.select("*", matlab.pyspark.sql.functions.log10(df.value)).show()
    +-----+------------+
    |value|LOG10(value)|
    +-----+------------+
    |    1|         0.0|
    |   10|         1.0|
    |  100|         2.0|
    +-----+------------+
 
    % Compute the logarithm in Base 10 of invalid values
    spark.sql("SELECT * FROM VALUES (-1), (0), (FLOAT('NAN')), (NULL) AS TAB(value)").select("*",  matlab.pyspark.sql.functions.log10("value")).show()
    +-----+------------+
    |value|LOG10(value)|
    +-----+------------+
    | -1.0|        NULL|
    |  0.0|        NULL|
    |  NaN|         NaN|
    | NULL|        NULL|
    +-----+------------+
```

### matlab.pyspark.sql.functions.log1p

```text
LOG1P Natural logarithm of col plus 1
 
  Examples:
    spark.range(1).select(matlab.pyspark.sql.functions.log1p(matlab.pyspark.sql.functions.e())).show()
 
    % Same as:
    spark.range(1).select(matlab.pyspark.sql.functions.log(matlab.pyspark.sql.functions.e() + 1)).show()
```

### matlab.pyspark.sql.functions.log2

```text
LOG2 Returns Base-2 logarithm of col
 
  Example:
    spark.range(10).select("*", matlab.pyspark.sql.functions.log2('id')).show()
    +---+------------------+
    | id|          LOG2(id)|
    +---+------------------+
    |  0|              NULL|
    |  1|               0.0|
    |  2|               1.0|
    |  3| 1.584962500721...|
    |  4|               2.0|
    |  5| 2.321928094887...|
    |  6| 2.584962500721...|
    |  7| 2.807354922057...|
    |  8|               3.0|
    |  9|3.1699250014423...|
    +---+------------------+
```

### matlab.pyspark.sql.functions.make_date

```text
make_date Create date column
```

### matlab.pyspark.sql.functions.make_timestamp

```text
make_timestamp Create a timestamp column
  
  This function exclusively uses named arguments. Any errors due to
  using invalid combinations, e.g. 'date' and 'year', will be handled
  by the underlying Spark libraries
 
  Example:
  spark = getDatabricksSession();
  data = {...
      {2023, 1, 2, 14, 20, 12.345, 'UTC'};...
      {2023, 1, 2, 14, 20, 12.345, 'America/New_York'};...
      {2023, 1, 2, 14, 20, 12.345, 'Europe/Berlin'};...
      {2023, 1, 2, 14, 20, 12.345, 'Asia/Calcutta'}...
      };
  columns = {'year', 'month', 'day', 'hour', 'min', 'sec', 'tz'};
  df = spark.createDataFrame(data, schema=columns);
  df = df.withColumn("ts_no_tz", matlab.pyspark.sql.functions.make_timestamp(years="year", month="month", days="day", hours="hour", mins="min", secs="sec"));
  df = df.withColumn("ts_with_tz", matlab.pyspark.sql.functions.make_timestamp(years="year", month="month", days="day", hours="hour", mins="min", secs="sec", timezone="tz"));
  df.show(10, false)
 
  See also https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/api/pyspark.sql.functions.make_timestamp.html
```

### matlab.pyspark.sql.functions.make_timestamp_ltz

```text
make_timestamp_ltz Create a timestamp column
  
  This function exclusively uses named arguments. Any errors due to
  using invalid combinations, e.g. 'date' and 'year', will be handled
  by the underlying Spark libraries
 
  Example:
  data = {...
      {2023, 1, 2, 14, 20, 12.345, 'UTC'};...
      {2023, 1, 2, 14, 20, 12.345, 'America/New_York'};...
      {2023, 1, 2, 14, 20, 12.345, 'Europe/Berlin'};...
      {2023, 1, 2, 14, 20, 12.345, 'Asia/Calcutta'}...
      };
  columns = {'year', 'month', 'day', 'hour', 'min', 'sec', 'tz'};
  df = spark.createDataFrame(data, schema=columns);
  df = df.withColumn("ts_no_tz", matlab.pyspark.sql.functions.make_timestamp_ntz(years="year", month="month", days="day", hours="hour", mins="min", secs="sec"));
  df = df.withColumn("ts_with_tz", matlab.pyspark.sql.functions.make_timestamp_ltz(years="year", month="month", days="day", hours="hour", mins="min", secs="sec", timezone="tz"));
  df.show(10, false)
 
  See also https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/api/pyspark.sql.functions.make_timestamp_ltz.html
```

### matlab.pyspark.sql.functions.make_timestamp_ntz

```text
make_timestamp_ntz Create a timestamp column
  
  This function exclusively uses named arguments. Any errors due to
  using invalid combinations, e.g. 'date' and 'year', will be handled
  by the underlying Spark libraries
 
  Example:
  data = {...
      {2023, 1, 2, 14, 20, 12.345, 'UTC'};...
      {2023, 1, 2, 14, 20, 12.345, 'America/New_York'};...
      {2023, 1, 2, 14, 20, 12.345, 'Europe/Berlin'};...
      {2023, 1, 2, 14, 20, 12.345, 'Asia/Calcutta'}...
      };
  columns = {'year', 'month', 'day', 'hour', 'min', 'sec', 'tz'};
  df = spark.createDataFrame(data, schema=columns);
  % Note the timezone is not used in withColumn method (not supported with this method)
  df = df.withColumn("ts_no_tz", matlab.pyspark.sql.functions.make_timestamp_ntz(years="year", month="month", days="day", hours="hour", mins="min", secs="sec"));
  df.show(10, false)
 
  See also https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/api/pyspark.sql.functions.make_timestamp_ntz.html
```

### matlab.pyspark.sql.functions.max

```text
max Max value
```

### matlab.pyspark.sql.functions.mean

```text
mean Mean value
```

### matlab.pyspark.sql.functions.min

```text
min Minimum value
```

### matlab.pyspark.sql.functions.minute

```text
minute Extract minute from a column
```

### matlab.pyspark.sql.functions.monotonically_increasing_id

```text
monotonically_increasing_id Monotonically increasing ID
 
  Add something to this if necessary
```

### matlab.pyspark.sql.functions.month

```text
month Extract month from a column
```

### matlab.pyspark.sql.functions.percent_rank

```text
percent_rank Creates a percent_rank column
 
  import matlab.pyspark.sql.Window
  df = spark.createDataFrame('[1, 1, 2, 3, 3, 4]', schema='value');
  w = Window.orderBy("value");
  df.withColumn("pr", matlab.pyspark.sql.functions.percent_rank().over(w)).show()
```

### matlab.pyspark.sql.functions.pi

```text
PI Returns Pi
 
  Example:
    spark.range(1).select(matlab.pyspark.sql.functions.pi()).show()
    +-----------------+
    |             PI()|
    +-----------------+
    |3.141592653589793|
    +-----------------+
```

### matlab.pyspark.sql.functions.pow

```text
pow Power function
```

### matlab.pyspark.sql.functions.power

```text
POWER Returns the value of the first argument raised to the power of the second argument
    col1: the base number
    col2: the exponent number
 
  Example:
    spark.range(5).select("*", matlab.pyspark.sql.functions.power("id", 2)).show()
    +---+--------------+
    | id|POWER(id, 2.0)|
    +---+--------------+
    |  0|           0.0|
    |  1|           1.0|
    |  2|           4.0|
    |  3|           9.0|
    |  4|          16.0|
    +---+--------------+
```

### matlab.pyspark.sql.functions.product

```text
product Aggregate function: returns the product of the values in a group.
 
  df = spark.sql("SELECT id % 3 AS mod3, id AS value FROM RANGE(10)");
  df.groupBy('mod3').agg(matlab.pyspark.sql.functions.product('value')).orderBy('mod3').show();
```

### matlab.pyspark.sql.functions.rand

```text
RAND Generates a random column with independent and identically distributed (i.i.d.) samples uniformly distributed in [0.0, 1.0)
 
  seed: Seed value for the random generator. Type int (default: py.None)
 
  Examples:
 
    % Generate a random column without a seed
    spark.range(0, 2, 1, 1).select("*", matlab.pyspark.sql.functions.rand()).show()
    +---+-------------------------+
    | id|rand(2945648544237839087)|
    +---+-------------------------+
    |  0|     0.010911550817409243|
    |  1|      0.08416790182034217|
    +---+-------------------------+
 
    % Generate a random column with a specific seed
    spark.range(0, 2, 1, 1).select("*", matlab.pyspark.sql.functions.rand(int64(42))).show()
    +---+-------------------+
    | id|           rand(42)|
    +---+-------------------+
    |  0|0.08575559529546095|
    |  1|0.31041139572710486|
    +---+-------------------+
```

### matlab.pyspark.sql.functions.randn

```text
RANDN Generates a random column with independent and identically distributed (i.i.d.) samples from the standard normal distribution
 
  seed: Seed value for the random generator.
  The seed must be >=0 and convertible to an int64 or a py.None value.
 
  Examples:
 
    % Generate a random column without a seed
    spark.range(0, 2, 1, 1).select("*", matlab.pyspark.sql.functions.randn()).show()
    +---+-------------------------+
    | id|randn(853313695792000437)|
    +---+-------------------------+
    |  0|      -1.1194552753031792|
    |  1|      -1.0256188858247723|
    +---+-------------------------+
 
    % Generate a random column with a specific seed
    spark.range(0, 2, 1, 1).select("*", matlab.pyspark.sql.functions.randn(42)).show()
    +---+------------------+
    | id|         randn(42)|
    +---+------------------+
    |  0| 2.384479054241...|
    |  1|0.1920934041293...|
    +---+------------------+
```

### matlab.pyspark.sql.functions.randstr

```text
RANDSTR Returns a string of the specified length
  Characters are chosen uniformly at random from the following pool of
  characters: 0-9, a-z, A-Z. The random seed is optional. The string length
  must be a constant two-byte or four-byte integer (SMALLINT or INT, respectively).
  seed: Seed value for the randstrom generator.
  Requires Spark v4.0.0 or greater, Databricks runtime 17 or greater.
 
  The seed must be >=0 and convertible to an int64 or a py.None value.
 
  Example:
    spark.range(0, 10, 1, 1).select(matlab.pyspark.sql.functions.randstr(16, 3)).show()
    +----------------+
    |  randstr(16, 3)|
    +----------------+
    |gIcaEIuILGwIrJmM|
    |Sxj3fhV9FZVeR0xw|
    |WBo50u89BpiQd3Lj|
    |ZnyhvrOFmZlj5X3v|
    |t9d0aJIROeG45HqP|
    |qPkK8U962WxJkZWN|
    |VzRToVzZoi3mzjWf|
    |C23JzJwpnjIxUzAR|
    |NjJsoRnwxM20GqM9|
    |XKnYaJOjVXuf5iIo|
    +----------------+
```

### matlab.pyspark.sql.functions.rank

```text
rank Creates a rank column
 
  import matlab.pyspark.sql.Window    
  df = spark.createDataFrame('[1, 1, 2, 3, 3, 4]', schema='value');
  w = Window.orderBy("value")
  df.withColumn("drank", matlab.pyspark.sql.functions.rank().over(w)).show();
```

### matlab.pyspark.sql.functions.round

```text
round Round a column
```

### matlab.pyspark.sql.functions.row_number

```text
row_number Creates a row_number column
 
  import matlab.pyspark.sql.Window    
  df = spark.range(3)
  w = Window.orderBy(df.id.desc())
  df.withColumn("desc_order", matlab.pyspark.sql.functions.row_number().over(w)).show()
```

### matlab.pyspark.sql.functions.second

```text
second Extract second from a column
```

### matlab.pyspark.sql.functions.sin

```text
SIN Computes sin of the input column
 
  Examples:
    % Compute the sine
    spark.sql("SELECT * FROM VALUES (0.0), (PI() / 2), (PI() / 4) AS TAB(value)").select(...
        "*", matlab.pyspark.sql.functions.sin("value")).show()
    +------------------+------------------+
    |             value|        SIN(value)|
    +------------------+------------------+
    |               0.0|               0.0|
    |1.5707963267948966|               1.0|
    |0.7853981633974483|0.7071067811865475|
    +------------------+------------------+ 
 
    % Compute the sine of invalid values
    spark.sql("SELECT * FROM VALUES (FLOAT('NAN')), (NULL) AS TAB(value)").select(...
        "*", matlab.pyspark.sql.functions.sin("value")).show()
    +-----+----------+
    |value|SIN(value)|
    +-----+----------+
    |  NaN|       NaN|
    | NULL|      NULL|
    +-----+----------+
```

### matlab.pyspark.sql.functions.sinh

```text
SINH Computes hyperbolic sine of the input column
 
  Examples:
    % Compute the hyperbolic sine
    df = spark.createDataFrame([-1; 0; 1], schema="value")
    df.select(matlab.pyspark.sql.functions.sinh("value")).show()
    +-------------------+
    |        SINH(value)|
    +-------------------+
    |-1.1752011936438014|
    |                0.0|
    | 1.1752011936438014|
    +-------------------+
 
    % Compute the hyperbolic sine of invalid values
    spark.sql("SELECT * FROM VALUES (FLOAT('NAN')), (NULL) AS TAB(value)").select(...
        "*", matlab.pyspark.sql.functions.sinh("value")).show()
    +-----+-----------+
    |value|SINH(value)|
    +-----+-----------+
    |  NaN|        NaN|
    | NULL|       NULL|
    +-----+-----------+
```

### matlab.pyspark.sql.functions.spark_partition_id

```text
spark_partition_id Creates a spark_partition_id column
 
  spark.range(0,10,1,5).select("*", matlab.pyspark.sql.functions.spark_partition_id()).show()
```

### matlab.pyspark.sql.functions.sqrt

```text
SQRT Computes the square root of the specified float value
 
  Examples:
    spark.sql("SELECT * FROM VALUES (-1), (0), (1), (4), (NULL) AS TAB(value)").select(...
        "*", matlab.pyspark.sql.functions.sqrt("value")).show()
    +-----+-----------+
    |value|SQRT(value)|
    +-----+-----------+
    |   -1|        NaN|
    |    0|        0.0|
    |    1|        1.0|
    |    4|        2.0|
    | NULL|       NULL|
    +-----+-----------+
```

### matlab.pyspark.sql.functions.sum

```text
sum Creates a sum of a column
```

### matlab.pyspark.sql.functions.tan

```text
TAN Computes tangent of the input column
 
  Examples:
    % Compute the tangent
    spark.sql("SELECT * FROM VALUES (0.0), (PI() / 4), (PI() / 6) AS TAB(value)").select(...
        "*", matlab.pyspark.sql.functions.tan("value")).show()
    +------------------+------------------+
    |             value|        TAN(value)|
    +------------------+------------------+
    |               0.0|               0.0|
    |0.7853981633974483|0.9999999999999999|
    |0.5235987755982988|0.5773502691896257|
    +------------------+------------------+
 
    % Compute the tangent of invalid values
    spark.sql("SELECT * FROM VALUES (FLOAT('NAN')), (NULL) AS TAB(value)").select(...
        "*", matlab.pyspark.sql.functions.tan("value")).show()
    +-----+----------+
    |value|TAN(value)|
    +-----+----------+
    |  NaN|       NaN|
    | NULL|      NULL|
    +-----+----------+
```

### matlab.pyspark.sql.functions.tanh

```text
TANH Computes hyperbolic tangent of the input column
 
  Examples:
    % Compute the hyperbolic tangent
    df = spark.createDataFrame([-1; 0; 1], schema="value")
    df.select("*", matlab.pyspark.sql.functions.tanh(df.value)).show()
    +-----+-------------------+
    |value|        TANH(value)|
    +-----+-------------------+
    | -1.0|-0.7615941559557649|
    |  0.0|                0.0|
    |  1.0| 0.7615941559557649|
    +-----+-------------------+
 
    % Compute the hyperbolic tangent of invalid values
    spark.sql("SELECT * FROM VALUES (FLOAT('NAN')), (NULL) AS TAB(value)").select(...
        "*", matlab.pyspark.sql.functions.tanh("value")).show()
    +-----+-----------+
    |value|TANH(value)|
    +-----+-----------+
    |  NaN|        NaN|
    | NULL|       NULL|
    +-----+-----------+
```

### matlab.pyspark.sql.functions.to_date

```text
to_date Convert column to date
```

### matlab.pyspark.sql.functions.to_timestamp

```text
to_timestamp Convert column to timestamp
```

### matlab.pyspark.sql.functions.transform

```text
transform Transforms column into new column
 
  The transformation that is applied is done by an operation that can
  already be applied to a column, e.g. col * 2
 
  Example for using transforms. 
 
  function DF = test2_transform(spark)
 
      import matlab.pyspark.sql.functions.transform
      DF = spark.range(10);
      DF = DF ...
          .withColumn('doubled', transform(DF.('id'), @tf1)) ...
          .withColumn('stringed', transform(DF.('id'), @(x) x.cast('string')));
      % DF = DF ...
      %     .withColumn("add_3", transform(DF.('id'), tf2(3)));
  end
 
  function new_col = tf1(col)
      % tf1 - Double a column in MATLAB code
      new_col = col * 2;
  end
 
  function pyTransform = tf2(num)
      % tf2 Add num to a column in Python code
 
      funcDef = ...
          "def adder(col):" + ...
          "    return (col + " + string(num) + ")";
          % "    return (col + 2.5)";
      funcReturn = "a = adder";
 
      pyTransform = pyrun([funcDef, funcReturn], "a");
 
  end
```

### matlab.pyspark.sql.functions.unix_timestamp

```text
unix_timestamp Convert column to timestamp
```

### matlab.pyspark.sql.functions.weekofyear

```text
weekofyear Extract weekofyear from a column
```

### matlab.pyspark.sql.functions.when

```text
when condition/value choice
```

### matlab.pyspark.sql.functions.window

```text
window Bucketize into windows
```

### matlab.pyspark.sql.functions.year

```text
year Extract year from a column
```

### matlab.pyspark.sql.session

### matlab.pyspark.sql.session.SparkSession

Superclass: matlab.pyspark.internal.PyWrapper

```text
SparkSession - Base class for a Python SparkSession
```

#### matlab.pyspark.sql.session.SparkSession.SparkSession

```text
SparkSession - Base class for a Python SparkSession

    Documentation for matlab.pyspark.sql.session.SparkSession
```

#### matlab.pyspark.sql.session.SparkSession.addArtifact

```text
addArtifact  Add an artifact to a Spark session
 
  Only works with Spark Connect
 
  Please refer to corresponding pyspark documentation
```

#### matlab.pyspark.sql.session.SparkSession.catalog

```text
matlab.pyspark.sql.session.SparkSession/catalog is a function.
    sparkCatalog = catalog(obj)
```

#### matlab.pyspark.sql.session.SparkSession.createDataFrame

```text
createDataFrame Creates a Spark Dataframe from a MATLAB table
  Returns a matlab.pyspark.sql.dataframe.Dataframe
  Input data snd schema typically undergo format conversion steps which they
  must support.
 
  Input data can be of types:
    char or string
        Before being converted to a DataFrame scalar data is first converted
        to a cell and then a py.list. Vector data is converted to a table with
        array2table and then a pandas DataFrame.
 
    cell
        Before being converted to a DataFrame a cell array is first converted
        to a table with cell2table, then to a pandas DataFrame.
 
    table
        Before being converted to a DataFrame a table is converted to a pandas
        DataFrame.
 
    py.str (Python string)
        Before being conversion a Python string is evaluated using pyrun.
        The resulting Python values should be convertible to a DataFrame.
 
    py.list (Python list)
        A Python list is passed directly to createDataFrame.
 
    py.pandas.DataFrame, py.pandas.core.frame.DataFrame
        A pandas DataFrame is passed directly to createDataFrame.
 
    Numeric scalars or arrays: 'single', 'double', 'int8', 'int16', 'int32',
        'int64', 'uint8', 'uint16', 'uint32', 'uint64', 'logical', 'struct
        Before being converted to a DataFrame numeric arrays are first
        converted to a table with array2table, then to a pandas DataFrame.
 
    Data examples:
        'abc'
        "abc"
        ["abc", "def"]
        ["abc"; "def"]
        {'abc'}
        {'abc'; 'def'}
        [1; 2]
        py.str("[(1,), (10,), (100,)]")
        [missing; "a"; "b"; "c"]
        py.str('[(1, "apple"), (2, "banana"), (3, None)]')
        py.list({py.tuple({1, "apple"}), py.tuple({2, "banana"}), py.tuple({3, py.None})})
        py.list({py.tuple({1.0, nan}), py.tuple({nan, 2.0})})
        magic(3)
        {py.None; 1}
 
 
  Schema:
    An optional schema can be specified as a named argument. It can be specified
    in a number of ways.
 
    char
        A char are first converted to a string and handled as a string.
 
    string
        A string must be a scalar or vector and is converted to a Python list
        before being passed as the schema.
 
    cell
        A cell must be a cellstr is converted to a py.list before being passed
        as the schema.
 
    py.list (Python list)
        Used directly.
 
    py.str (Python string) are used directly.
        Used directly and should be a  DDL formatted string.
 
    Schema examples:
        schema="myvalue"
        schema={'myvalue1'}  % Cell must be of chars such that iscellstr is satisfied
        schema={'myvalue1', 'myvalue2'});
        schema=["myvalue1", "myvalue2"]
        schema=py.str('col1: string, col2: string')
 
 
  Other unsupported arguments:
    samplingRatio is not supported as it only applies to RDD-based DataFrames.
 
    verifySchema is not supported when using Spark/Databricks Connect and
    so is not supported by this function.
 
 
  Examples:
    % Create a DataFrame based on a MATLAB table
    LastName = {'Sanchez';'Johnson';'Li';'Diaz';'Brown'};
    Age = [38;43;38;40;49];
    Smoker = logical([1;0;1;0;1]);
    Height = [71;69;64;67;64];
    Weight = [176;163;131;133;119];
    BloodPressure = [124 93; 109 77; 125 83; 117 75; 122 80];
    T = table(LastName,Age,Smoker,Height,Weight,BloodPressure)
 
    spark = getDatabricksSession;
    df = spark.createDataFrame(T);
    df.show
    +--------+----+------+------+------+---------------+---------------+
    |LastName| Age|Smoker|Height|Weight|BloodPressure_1|BloodPressure_2|
    +--------+----+------+------+------+---------------+---------------+
    | Sanchez|38.0|  true|  71.0| 176.0|          124.0|           93.0|
    | Johnson|43.0| false|  69.0| 163.0|          109.0|           77.0|
    |      Li|38.0|  true|  64.0| 131.0|          125.0|           83.0|
    |    Diaz|40.0| false|  67.0| 133.0|          117.0|           75.0|
    |   Brown|49.0|  true|  64.0| 119.0|          122.0|           80.0|
    +--------+----+------+------+------+---------------+---------------+
 
 
    % Source from an array of doubles with non default column names
    df = spark.createDataFrame(magic(3), schema=["x1","x2", "x3"]);
    df.show
    +---+---+---+
    | x1| x2| x3|
    +---+---+---+
    |8.0|1.0|6.0|
    |3.0|5.0|7.0|
    |4.0|9.0|2.0|
    +---+---+---+
 
  See also: https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/api/pyspark.sql.SparkSession.createDataFrame.html
```

#### matlab.pyspark.sql.session.SparkSession.delete

```text
delete - files or objects

    <strong>Syntax</strong>
      delete filename
      delete filename1 ... filenameN
      delete(___,ResolveSymbolicLinks=tf)
      delete(obj)

    <strong>Input Arguments</strong>
      <a href="matlab:web /usr/local/MATLAB/R2026a/help/matlab/ref/delete.html#f71-847380-filename">filename</a> - Name of file to delete
        string array | character vector | cell array of character vectors
      <a href="matlab:web /usr/local/MATLAB/R2026a/help/matlab/ref/delete.html#f71-847380-h">obj</a> - Object
        single object | array of objects
      <a href="matlab:web /usr/local/MATLAB/R2026a/help/matlab/ref/delete.html#mw_5b772dbd-a426-4b57-8167-1077a1b02460">tf</a> - Remove target of symbolic link
        false or 0 (default) | true or 1

    <strong>Examples</strong>
      <a href="matlab:openExample('matlab/DeleteFilesInFolderExample')">Delete Files in Folder</a>
      <a href="matlab:openExample('matlab/DeleteGraphicsObjectsExample')">Delete Graphics Objects</a>

    <strong>See also</strong> <a href="matlab:help clear -displayBanner">clear</a>, <a href="matlab:help dir -displayBanner">dir</a>, <a href="matlab:help recycle -displayBanner">recycle</a>, <a href="matlab:help rmdir -displayBanner">rmdir</a>, <a href="matlab:help handle.delete -displayBanner">delete</a>

    Introduced in MATLAB before R2006a
    <a href="matlab:doc delete">Documentation for delete</a>
```

#### matlab.pyspark.sql.session.SparkSession.range

```text
range - Return a dataframe range
 
  obj, start, end_, step, numPartitions
```

#### matlab.pyspark.sql.session.SparkSession.read

```text
read  Get a DataFrameReader
 
  Please refer to corresponding pyspark documentation
```

#### matlab.pyspark.sql.session.SparkSession.session_id

```text
V Return spark session_id
```

#### matlab.pyspark.sql.session.SparkSession.sql

```text
sql - Execute a SQL statement
 
  This version doesn't support additional arguments for binding special
  variables. When applicable, this can be achieved by formatting the
  string correspondingly instead, e.g. using sprintf statements.
```

#### matlab.pyspark.sql.session.SparkSession.stop

```text
matlab.pyspark.sql.session.SparkSession/stop is a function.
    stop(obj)
```

#### matlab.pyspark.sql.session.SparkSession.table

```text
table Read table from Spark context
```

#### matlab.pyspark.sql.session.SparkSession.toPy

```text
matlab.pyspark.sql.session.SparkSession/toPy is a function.
    pyObj = toPy(obj)
```

#### matlab.pyspark.sql.session.SparkSession.version

```text
V Return spark version
```

### matlab.sparkutils

### matlab.sparkutils.table2dataset

```text
TABLE2DATASET Function to create Spark dataset from MATLAB table
 
  It takes as arguments a MATLAB table, the spark session reference, and
  an optional schema object, and converts the table into a Dataset object.
 
  This function should be used for tests, not for large tables.
 
  To use it, at least a table and a spark session are needed:
 
    dataset = matlab.sparkutils.table2dataset(matlabTable, sparkSession);
 
  When the optional third input argument (schema) is not provided, the
  Column data types are automatically mapped as follows (also see the 
  createSparkSchemaFromMatlabType in the functions folder):
 
    MATLAB            Spark     Notes
    ======            ======    =====
    char              String    converting back to MATLAB results in string, not char
    string            String    <missing> value interpreted as the String \0
    double            Double
    single            Float
    int8              Byte
    int16             Short
    int32             Integer
    int64             Long
    logical           Boolean
    struct            Struct
    table             Struct    converting back to MATLAB results in struct, not table
    containers.Map    Map
    cell              WrappedArray
    datetime          Timestamp
    duration          CalendarInterval
    (any other type)  *** NOT SUPPORTED ***
 
  An optional third argument (schema) can also be specified. This is useful
  when a schema object is already available, for example the schema of a
  pre-existing Spark dataset.
 
    dataset = spark.read.format("parquet").load("/my/files")
    T = table(dataset);
    T = runAlgorithm(T);
    schema = dataset.schema;
    dataset = matlab.sparkutils.table2dataset(matlabTable, sparkSession, schema);
 
  The optional schema argument can also be specified as a cell-array of
  chars or a string array, representing case-insensitive column data types.
  Only the following basic data types are supported:
 
    string or char, double, single or float, int8 or byte, int16 or short,
    int32 or int or integer, int64 or long, logical or boolean, duration,
    datetime or timestamp.
 
  This list does not include complex data types such as struct, map,
  or table. If your data contains such data types, either use the 2-inputs
  variant of this function in order to auto-generate the schema, or use a
  schema-object from a pre-existing dataset object.
```

------

**Copyright 2020-2026 The MathWorks Inc.**

[//]: # (Documentation generation settings: )
[//]: # (* Including class level help text )
[//]: # (* Including constructor help text )
[//]: # (* Excluding inherited methods )
[//]: # (* Excluding default MATLAB classes )
[//]: # (* Generated: 07-May-2026 09:57:24 )
