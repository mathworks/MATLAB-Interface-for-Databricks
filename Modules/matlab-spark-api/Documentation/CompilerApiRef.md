# MATLAB Interface *for Apache Spark* (compiler.build.spark) - API Reference

This document includes API reference information for the following namespaces or functions:

* [compiler.build.spark](#compilerbuildspark)

Classes, methods and functions that include the terms `private` or `internal` in their namespace should not be used directly.
They are subject to change or removal without notice.

## Index

* MATLAB&reg; Interface *for Apache&reg; Spark&trade;* (compiler.build.spark)
  * [compiler.build.spark](#compilerbuildspark)
    * [compiler.build.spark.converters](#compilerbuildsparkconverters)
      * [compiler.build.spark.converters.ArraySeriesConverter](#compilerbuildsparkconvertersarrayseriesconverter)
        * [compiler.build.spark.converters.ArraySeriesConverter.ArraySeriesConverter](#compilerbuildsparkconvertersarrayseriesconverterarrayseriesconverter)
        * [compiler.build.spark.converters.ArraySeriesConverter.convert](#compilerbuildsparkconvertersarrayseriesconverterconvert)
      * [compiler.build.spark.converters.BinarySeriesConverter](#compilerbuildsparkconvertersbinaryseriesconverter)
        * [compiler.build.spark.converters.BinarySeriesConverter.BinarySeriesConverter](#compilerbuildsparkconvertersbinaryseriesconverterbinaryseriesconverter)
        * [compiler.build.spark.converters.BinarySeriesConverter.convert](#compilerbuildsparkconvertersbinaryseriesconverterconvert)
      * [compiler.build.spark.converters.DateSeriesConverter](#compilerbuildsparkconvertersdateseriesconverter)
        * [compiler.build.spark.converters.DateSeriesConverter.DateSeriesConverter](#compilerbuildsparkconvertersdateseriesconverterdateseriesconverter)
        * [compiler.build.spark.converters.DateSeriesConverter.convert](#compilerbuildsparkconvertersdateseriesconverterconvert)
      * [compiler.build.spark.converters.MapSeriesConverter](#compilerbuildsparkconvertersmapseriesconverter)
        * [compiler.build.spark.converters.MapSeriesConverter.MapSeriesConverter](#compilerbuildsparkconvertersmapseriesconvertermapseriesconverter)
        * [compiler.build.spark.converters.MapSeriesConverter.convert](#compilerbuildsparkconvertersmapseriesconverterconvert)
      * [compiler.build.spark.converters.PrimitiveSeriesConverter](#compilerbuildsparkconvertersprimitiveseriesconverter)
        * [compiler.build.spark.converters.PrimitiveSeriesConverter.PrimitiveSeriesConverter](#compilerbuildsparkconvertersprimitiveseriesconverterprimitiveseriesconverter)
        * [compiler.build.spark.converters.PrimitiveSeriesConverter.convert](#compilerbuildsparkconvertersprimitiveseriesconverterconvert)
      * [compiler.build.spark.converters.SeriesConverter](#compilerbuildsparkconvertersseriesconverter)
        * [compiler.build.spark.converters.SeriesConverter.SeriesConverter](#compilerbuildsparkconvertersseriesconverterseriesconverter)
        * [compiler.build.spark.converters.SeriesConverter.convert](#compilerbuildsparkconvertersseriesconverterconvert)
      * [compiler.build.spark.converters.StringSeriesConverter](#compilerbuildsparkconvertersstringseriesconverter)
        * [compiler.build.spark.converters.StringSeriesConverter.StringSeriesConverter](#compilerbuildsparkconvertersstringseriesconverterstringseriesconverter)
        * [compiler.build.spark.converters.StringSeriesConverter.convert](#compilerbuildsparkconvertersstringseriesconverterconvert)
      * [compiler.build.spark.converters.StructField](#compilerbuildsparkconvertersstructfield)
        * [compiler.build.spark.converters.StructField.StructField](#compilerbuildsparkconvertersstructfieldstructfield)
      * [compiler.build.spark.converters.StructSeriesConverter](#compilerbuildsparkconvertersstructseriesconverter)
        * [compiler.build.spark.converters.StructSeriesConverter.StructSeriesConverter](#compilerbuildsparkconvertersstructseriesconverterstructseriesconverter)
        * [compiler.build.spark.converters.StructSeriesConverter.convert](#compilerbuildsparkconvertersstructseriesconverterconvert)
      * [compiler.build.spark.converters.TimeUnit](#compilerbuildsparkconverterstimeunit)
        * [compiler.build.spark.converters.TimeUnit.TimeUnit](#compilerbuildsparkconverterstimeunittimeunit)
        * [compiler.build.spark.converters.TimeUnit.ticksPerSecond](#compilerbuildsparkconverterstimeunittickspersecond)
      * [compiler.build.spark.converters.TimedeltaSeriesConverter](#compilerbuildsparkconverterstimedeltaseriesconverter)
        * [compiler.build.spark.converters.TimedeltaSeriesConverter.TimedeltaSeriesConverter](#compilerbuildsparkconverterstimedeltaseriesconvertertimedeltaseriesconverter)
        * [compiler.build.spark.converters.TimedeltaSeriesConverter.convert](#compilerbuildsparkconverterstimedeltaseriesconverterconvert)
      * [compiler.build.spark.converters.TimestampSeriesConverter](#compilerbuildsparkconverterstimestampseriesconverter)
        * [compiler.build.spark.converters.TimestampSeriesConverter.TimestampSeriesConverter](#compilerbuildsparkconverterstimestampseriesconvertertimestampseriesconverter)
        * [compiler.build.spark.converters.TimestampSeriesConverter.convert](#compilerbuildsparkconverterstimestampseriesconverterconvert)
    * [compiler.build.spark.data](#compilerbuildsparkdata)
      * [compiler.build.spark.data.AnsiIntervalType](#compilerbuildsparkdataansiintervaltype)
        * [compiler.build.spark.data.AnsiIntervalType.AnsiIntervalType](#compilerbuildsparkdataansiintervaltypeansiintervaltype)
        * [compiler.build.spark.data.AnsiIntervalType.array_IMML_to_IMPY](#compilerbuildsparkdataansiintervaltypearray_imml_to_impy)
      * [compiler.build.spark.data.ArrayType](#compilerbuildsparkdataarraytype)
        * [compiler.build.spark.data.ArrayType.ArrayType](#compilerbuildsparkdataarraytypearraytype)
        * [compiler.build.spark.data.ArrayType.PandasSeriesType](#compilerbuildsparkdataarraytypepandasseriestype)
        * [compiler.build.spark.data.ArrayType.UniqueTypeName](#compilerbuildsparkdataarraytypeuniquetypename)
        * [compiler.build.spark.data.ArrayType.addIteratorRow](#compilerbuildsparkdataarraytypeadditeratorrow)
        * [compiler.build.spark.data.ArrayType.colIntermediateMATLABToPython](#compilerbuildsparkdataarraytypecolintermediatematlabtopython)
        * [compiler.build.spark.data.ArrayType.col_IMML_to_IMPY](#compilerbuildsparkdataarraytypecol_imml_to_impy)
        * [compiler.build.spark.data.ArrayType.col_IMML_to_ML](#compilerbuildsparkdataarraytypecol_imml_to_ml)
        * [compiler.build.spark.data.ArrayType.col_IMPY_to_IMML](#compilerbuildsparkdataarraytypecol_impy_to_imml)
        * [compiler.build.spark.data.ArrayType.col_MATLABTable](#compilerbuildsparkdataarraytypecol_matlabtable)
        * [compiler.build.spark.data.ArrayType.col_ML_to_IMML](#compilerbuildsparkdataarraytypecol_ml_to_imml)
        * [compiler.build.spark.data.ArrayType.col_Spark_to_IMPY](#compilerbuildsparkdataarraytypecol_spark_to_impy)
        * [compiler.build.spark.data.ArrayType.convertIntermediateToMATLAB](#compilerbuildsparkdataarraytypeconvertintermediatetomatlab)
        * [compiler.build.spark.data.ArrayType.convertMATLABToIntermediate](#compilerbuildsparkdataarraytypeconvertmatlabtointermediate)
        * [compiler.build.spark.data.ArrayType.convertStructColumn](#compilerbuildsparkdataarraytypeconvertstructcolumn)
        * [compiler.build.spark.data.ArrayType.genMATLABArray](#compilerbuildsparkdataarraytypegenmatlabarray)
        * [compiler.build.spark.data.ArrayType.genPythonExampleFunction](#compilerbuildsparkdataarraytypegenpythonexamplefunction)
        * [compiler.build.spark.data.ArrayType.getIndexString_](#compilerbuildsparkdataarraytypegetindexstring_)
        * [compiler.build.spark.data.ArrayType.getMATLABColumnEntry](#compilerbuildsparkdataarraytypegetmatlabcolumnentry)
        * [compiler.build.spark.data.ArrayType.getMLPandasSeriesConverterCtor](#compilerbuildsparkdataarraytypegetmlpandasseriesconverterctor)
        * [compiler.build.spark.data.ArrayType.getPyPandasSeriesConverterCtor](#compilerbuildsparkdataarraytypegetpypandasseriesconverterctor)
        * [compiler.build.spark.data.ArrayType.instantiateColExampleData](#compilerbuildsparkdataarraytypeinstantiatecolexampledata)
        * [compiler.build.spark.data.ArrayType.instantiateMATLABExampleValue](#compilerbuildsparkdataarraytypeinstantiatematlabexamplevalue)
        * [compiler.build.spark.data.ArrayType.instantiatePythonExampleValue](#compilerbuildsparkdataarraytypeinstantiatepythonexamplevalue)
        * [compiler.build.spark.data.ArrayType.isLeaf](#compilerbuildsparkdataarraytypeisleaf)
        * [compiler.build.spark.data.ArrayType.preAllocateMATLABColumn](#compilerbuildsparkdataarraytypepreallocatematlabcolumn)
        * [compiler.build.spark.data.ArrayType.val_IMML_to_IMPY](#compilerbuildsparkdataarraytypeval_imml_to_impy)
        * [compiler.build.spark.data.ArrayType.val_IMML_to_ML](#compilerbuildsparkdataarraytypeval_imml_to_ml)
        * [compiler.build.spark.data.ArrayType.val_IMPY_to_IMML](#compilerbuildsparkdataarraytypeval_impy_to_imml)
        * [compiler.build.spark.data.ArrayType.val_IMPY_to_Spark](#compilerbuildsparkdataarraytypeval_impy_to_spark)
        * [compiler.build.spark.data.ArrayType.val_MATLABTable](#compilerbuildsparkdataarraytypeval_matlabtable)
        * [compiler.build.spark.data.ArrayType.val_ML_to_IMML](#compilerbuildsparkdataarraytypeval_ml_to_imml)
        * [compiler.build.spark.data.ArrayType.val_Spark_to_IMPY](#compilerbuildsparkdataarraytypeval_spark_to_impy)
      * [compiler.build.spark.data.AtomicType](#compilerbuildsparkdataatomictype)
        * [compiler.build.spark.data.AtomicType.AtomicType](#compilerbuildsparkdataatomictypeatomictype)
      * [compiler.build.spark.data.BaseType](#compilerbuildsparkdatabasetype)
        * [compiler.build.spark.data.BaseType.BaseType](#compilerbuildsparkdatabasetypebasetype)
        * [compiler.build.spark.data.BaseType.getFileParent](#compilerbuildsparkdatabasetypegetfileparent)
      * [compiler.build.spark.data.BinaryType](#compilerbuildsparkdatabinarytype)
        * [compiler.build.spark.data.BinaryType.BinaryType](#compilerbuildsparkdatabinarytypebinarytype)
        * [compiler.build.spark.data.BinaryType.PandasSeriesType](#compilerbuildsparkdatabinarytypepandasseriestype)
        * [compiler.build.spark.data.BinaryType.col_IMML_to_IMPY](#compilerbuildsparkdatabinarytypecol_imml_to_impy)
        * [compiler.build.spark.data.BinaryType.col_MATLABTable](#compilerbuildsparkdatabinarytypecol_matlabtable)
        * [compiler.build.spark.data.BinaryType.genPythonExampleFunction](#compilerbuildsparkdatabinarytypegenpythonexamplefunction)
        * [compiler.build.spark.data.BinaryType.getMLPandasSeriesConverterCtor](#compilerbuildsparkdatabinarytypegetmlpandasseriesconverterctor)
        * [compiler.build.spark.data.BinaryType.getPyPandasSeriesConverterCtor](#compilerbuildsparkdatabinarytypegetpypandasseriesconverterctor)
        * [compiler.build.spark.data.BinaryType.instantiatePythonExampleValue](#compilerbuildsparkdatabinarytypeinstantiatepythonexamplevalue)
        * [compiler.build.spark.data.BinaryType.val_IMML_to_IMPY](#compilerbuildsparkdatabinarytypeval_imml_to_impy)
      * [compiler.build.spark.data.BooleanType](#compilerbuildsparkdatabooleantype)
        * [compiler.build.spark.data.BooleanType.BooleanType](#compilerbuildsparkdatabooleantypebooleantype)
        * [compiler.build.spark.data.BooleanType.PandasSeriesType](#compilerbuildsparkdatabooleantypepandasseriestype)
        * [compiler.build.spark.data.BooleanType.array_IMML_to_IMPY](#compilerbuildsparkdatabooleantypearray_imml_to_impy)
        * [compiler.build.spark.data.BooleanType.col_IMML_to_IMPY](#compilerbuildsparkdatabooleantypecol_imml_to_impy)
        * [compiler.build.spark.data.BooleanType.col_IMPY_to_IMML](#compilerbuildsparkdatabooleantypecol_impy_to_imml)
        * [compiler.build.spark.data.BooleanType.genMATLABArray](#compilerbuildsparkdatabooleantypegenmatlabarray)
        * [compiler.build.spark.data.BooleanType.genPythonExampleFunction](#compilerbuildsparkdatabooleantypegenpythonexamplefunction)
        * [compiler.build.spark.data.BooleanType.getMLPandasSeriesConverterCtor](#compilerbuildsparkdatabooleantypegetmlpandasseriesconverterctor)
        * [compiler.build.spark.data.BooleanType.getPyPandasSeriesConverterCtor](#compilerbuildsparkdatabooleantypegetpypandasseriesconverterctor)
        * [compiler.build.spark.data.BooleanType.instantiatePythonExampleValue](#compilerbuildsparkdatabooleantypeinstantiatepythonexamplevalue)
        * [compiler.build.spark.data.BooleanType.val_IMPY_to_IMML](#compilerbuildsparkdatabooleantypeval_impy_to_imml)
        * [compiler.build.spark.data.BooleanType.val_MATLABTable](#compilerbuildsparkdatabooleantypeval_matlabtable)
      * [compiler.build.spark.data.ByteType](#compilerbuildsparkdatabytetype)
        * [compiler.build.spark.data.ByteType.ByteType](#compilerbuildsparkdatabytetypebytetype)
      * [compiler.build.spark.data.DataType](#compilerbuildsparkdatadatatype)
        * [compiler.build.spark.data.DataType.DataType](#compilerbuildsparkdatadatatypedatatype)
        * [compiler.build.spark.data.DataType.IntermediaryMATLABType](#compilerbuildsparkdatadatatypeintermediarymatlabtype)
        * [compiler.build.spark.data.DataType.IntermediaryPythonType](#compilerbuildsparkdatadatatypeintermediarypythontype)
        * [compiler.build.spark.data.DataType.PandasSeriesType](#compilerbuildsparkdatadatatypepandasseriestype)
        * [compiler.build.spark.data.DataType.UniqueTypeName](#compilerbuildsparkdatadatatypeuniquetypename)
        * [compiler.build.spark.data.DataType.addIteratorRow](#compilerbuildsparkdatadatatypeadditeratorrow)
        * [compiler.build.spark.data.DataType.arrayElemConverter](#compilerbuildsparkdatadatatypearrayelemconverter)
        * [compiler.build.spark.data.DataType.array_IMML_to_IMPY](#compilerbuildsparkdatadatatypearray_imml_to_impy)
        * [compiler.build.spark.data.DataType.array_IMML_to_ML](#compilerbuildsparkdatadatatypearray_imml_to_ml)
        * [compiler.build.spark.data.DataType.array_IMPY_to_IMML](#compilerbuildsparkdatadatatypearray_impy_to_imml)
        * [compiler.build.spark.data.DataType.array_ML_to_IMML](#compilerbuildsparkdatadatatypearray_ml_to_imml)
        * [compiler.build.spark.data.DataType.array_Spark_to_IMPY](#compilerbuildsparkdatadatatypearray_spark_to_impy)
        * [compiler.build.spark.data.DataType.colIntermediateMATLABToPython](#compilerbuildsparkdatadatatypecolintermediatematlabtopython)
        * [compiler.build.spark.data.DataType.colName](#compilerbuildsparkdatadatatypecolname)
        * [compiler.build.spark.data.DataType.colName_](#compilerbuildsparkdatadatatypecolname_)
        * [compiler.build.spark.data.DataType.col_IMML_to_IMPY](#compilerbuildsparkdatadatatypecol_imml_to_impy)
        * [compiler.build.spark.data.DataType.col_IMML_to_ML](#compilerbuildsparkdatadatatypecol_imml_to_ml)
        * [compiler.build.spark.data.DataType.col_IMML_to_PandasSeries](#compilerbuildsparkdatadatatypecol_imml_to_pandasseries)
        * [compiler.build.spark.data.DataType.col_IMPY_to_IMML](#compilerbuildsparkdatadatatypecol_impy_to_imml)
        * [compiler.build.spark.data.DataType.col_IMPY_to_Spark](#compilerbuildsparkdatadatatypecol_impy_to_spark)
        * [compiler.build.spark.data.DataType.col_MATLABTable](#compilerbuildsparkdatadatatypecol_matlabtable)
        * [compiler.build.spark.data.DataType.col_ML_to_IMML](#compilerbuildsparkdatadatatypecol_ml_to_imml)
        * [compiler.build.spark.data.DataType.col_Spark_to_IMPY](#compilerbuildsparkdatadatatypecol_spark_to_impy)
        * [compiler.build.spark.data.DataType.colsIteratorInit](#compilerbuildsparkdatadatatypecolsiteratorinit)
        * [compiler.build.spark.data.DataType.convertIntermediateToMATLAB](#compilerbuildsparkdatadatatypeconvertintermediatetomatlab)
        * [compiler.build.spark.data.DataType.convertMATLABToIntermediate](#compilerbuildsparkdatadatatypeconvertmatlabtointermediate)
        * [compiler.build.spark.data.DataType.convertPandaColumnFromIntermediate](#compilerbuildsparkdatadatatypeconvertpandacolumnfromintermediate)
        * [compiler.build.spark.data.DataType.convertStructColumn](#compilerbuildsparkdatadatatypeconvertstructcolumn)
        * [compiler.build.spark.data.DataType.genIntermediateArrayToPython](#compilerbuildsparkdatadatatypegenintermediatearraytopython)
        * [compiler.build.spark.data.DataType.genMATLABArray](#compilerbuildsparkdatadatatypegenmatlabarray)
        * [compiler.build.spark.data.DataType.genPythonExampleFunction](#compilerbuildsparkdatadatatypegenpythonexamplefunction)
        * [compiler.build.spark.data.DataType.getColumnIndex](#compilerbuildsparkdatadatatypegetcolumnindex)
        * [compiler.build.spark.data.DataType.getColumnObject](#compilerbuildsparkdatadatatypegetcolumnobject)
        * [compiler.build.spark.data.DataType.getIndexString](#compilerbuildsparkdatadatatypegetindexstring)
        * [compiler.build.spark.data.DataType.getIndexString_](#compilerbuildsparkdatadatatypegetindexstring_)
        * [compiler.build.spark.data.DataType.getMATLABColumnEntry](#compilerbuildsparkdatadatatypegetmatlabcolumnentry)
        * [compiler.build.spark.data.DataType.getMLPandasSeriesConverterCtor](#compilerbuildsparkdatadatatypegetmlpandasseriesconverterctor)
        * [compiler.build.spark.data.DataType.getParentColName](#compilerbuildsparkdatadatatypegetparentcolname)
        * [compiler.build.spark.data.DataType.getPyPandasSeriesConverterCtor](#compilerbuildsparkdatadatatypegetpypandasseriesconverterctor)
        * [compiler.build.spark.data.DataType.hasDataTypeParent](#compilerbuildsparkdatadatatypehasdatatypeparent)
        * [compiler.build.spark.data.DataType.instantiateColExampleData](#compilerbuildsparkdatadatatypeinstantiatecolexampledata)
        * [compiler.build.spark.data.DataType.instantiateMATLABExampleValue](#compilerbuildsparkdatadatatypeinstantiatematlabexamplevalue)
        * [compiler.build.spark.data.DataType.instantiatePythonExampleValue](#compilerbuildsparkdatadatatypeinstantiatepythonexamplevalue)
        * [compiler.build.spark.data.DataType.isColumn](#compilerbuildsparkdatadatatypeiscolumn)
        * [compiler.build.spark.data.DataType.isExtraArgument](#compilerbuildsparkdatadatatypeisextraargument)
        * [compiler.build.spark.data.DataType.isLeaf](#compilerbuildsparkdatadatatypeisleaf)
        * [compiler.build.spark.data.DataType.isScalarData](#compilerbuildsparkdatadatatypeisscalardata)
        * [compiler.build.spark.data.DataType.pandasSeriesToColumn](#compilerbuildsparkdatadatatypepandasseriestocolumn)
        * [compiler.build.spark.data.DataType.preAllocateMATLABColumn](#compilerbuildsparkdatadatatypepreallocatematlabcolumn)
        * [compiler.build.spark.data.DataType.table_IMML_to_ML](#compilerbuildsparkdatadatatypetable_imml_to_ml)
        * [compiler.build.spark.data.DataType.val_IMML_to_IMPY](#compilerbuildsparkdatadatatypeval_imml_to_impy)
        * [compiler.build.spark.data.DataType.val_IMML_to_ML](#compilerbuildsparkdatadatatypeval_imml_to_ml)
        * [compiler.build.spark.data.DataType.val_IMPY_to_IMML](#compilerbuildsparkdatadatatypeval_impy_to_imml)
        * [compiler.build.spark.data.DataType.val_IMPY_to_Spark](#compilerbuildsparkdatadatatypeval_impy_to_spark)
        * [compiler.build.spark.data.DataType.val_MATLABTable](#compilerbuildsparkdatadatatypeval_matlabtable)
        * [compiler.build.spark.data.DataType.val_ML_to_IMML](#compilerbuildsparkdatadatatypeval_ml_to_imml)
        * [compiler.build.spark.data.DataType.val_Spark_to_IMPY](#compilerbuildsparkdatadatatypeval_spark_to_impy)
      * [compiler.build.spark.data.DateTimeStampType](#compilerbuildsparkdatadatetimestamptype)
        * [compiler.build.spark.data.DateTimeStampType.DateTimeStampType](#compilerbuildsparkdatadatetimestamptypedatetimestamptype)
        * [compiler.build.spark.data.DateTimeStampType.arrayElemConverter](#compilerbuildsparkdatadatetimestamptypearrayelemconverter)
        * [compiler.build.spark.data.DateTimeStampType.array_IMML_to_IMPY](#compilerbuildsparkdatadatetimestamptypearray_imml_to_impy)
        * [compiler.build.spark.data.DateTimeStampType.array_IMPY_to_IMML](#compilerbuildsparkdatadatetimestamptypearray_impy_to_imml)
        * [compiler.build.spark.data.DateTimeStampType.col_IMML_to_IMPY](#compilerbuildsparkdatadatetimestamptypecol_imml_to_impy)
        * [compiler.build.spark.data.DateTimeStampType.col_IMPY_to_IMML](#compilerbuildsparkdatadatetimestamptypecol_impy_to_imml)
        * [compiler.build.spark.data.DateTimeStampType.val_IMPY_to_IMML](#compilerbuildsparkdatadatetimestamptypeval_impy_to_imml)
      * [compiler.build.spark.data.DateType](#compilerbuildsparkdatadatetype)
        * [compiler.build.spark.data.DateType.DateType](#compilerbuildsparkdatadatetypedatetype)
        * [compiler.build.spark.data.DateType.IntermediaryMATLABType](#compilerbuildsparkdatadatetypeintermediarymatlabtype)
        * [compiler.build.spark.data.DateType.PandasSeriesType](#compilerbuildsparkdatadatetypepandasseriestype)
        * [compiler.build.spark.data.DateType.UniqueTypeName](#compilerbuildsparkdatadatetypeuniquetypename)
        * [compiler.build.spark.data.DateType.col_MATLABTable](#compilerbuildsparkdatadatetypecol_matlabtable)
        * [compiler.build.spark.data.DateType.genPythonExampleFunction](#compilerbuildsparkdatadatetypegenpythonexamplefunction)
        * [compiler.build.spark.data.DateType.getMLPandasSeriesConverterCtor](#compilerbuildsparkdatadatetypegetmlpandasseriesconverterctor)
        * [compiler.build.spark.data.DateType.getPyPandasSeriesConverterCtor](#compilerbuildsparkdatadatetypegetpypandasseriesconverterctor)
        * [compiler.build.spark.data.DateType.instantiateColExampleData](#compilerbuildsparkdatadatetypeinstantiatecolexampledata)
        * [compiler.build.spark.data.DateType.val_IMML_to_ML](#compilerbuildsparkdatadatetypeval_imml_to_ml)
        * [compiler.build.spark.data.DateType.val_IMPY_to_Spark](#compilerbuildsparkdatadatetypeval_impy_to_spark)
        * [compiler.build.spark.data.DateType.val_ML_to_IMML](#compilerbuildsparkdatadatetypeval_ml_to_imml)
        * [compiler.build.spark.data.DateType.val_Spark_to_IMPY](#compilerbuildsparkdatadatetypeval_spark_to_impy)
      * [compiler.build.spark.data.DayTimeIntervalType](#compilerbuildsparkdatadaytimeintervaltype)
        * [compiler.build.spark.data.DayTimeIntervalType.DayTimeIntervalType](#compilerbuildsparkdatadaytimeintervaltypedaytimeintervaltype)
        * [compiler.build.spark.data.DayTimeIntervalType.IntermediaryMATLABType](#compilerbuildsparkdatadaytimeintervaltypeintermediarymatlabtype)
        * [compiler.build.spark.data.DayTimeIntervalType.IntermediaryPythonType](#compilerbuildsparkdatadaytimeintervaltypeintermediarypythontype)
        * [compiler.build.spark.data.DayTimeIntervalType.PandasSeriesType](#compilerbuildsparkdatadaytimeintervaltypepandasseriestype)
        * [compiler.build.spark.data.DayTimeIntervalType.col_IMML_to_IMPY](#compilerbuildsparkdatadaytimeintervaltypecol_imml_to_impy)
        * [compiler.build.spark.data.DayTimeIntervalType.col_IMPY_to_IMML](#compilerbuildsparkdatadaytimeintervaltypecol_impy_to_imml)
        * [compiler.build.spark.data.DayTimeIntervalType.colsIteratorInit](#compilerbuildsparkdatadaytimeintervaltypecolsiteratorinit)
        * [compiler.build.spark.data.DayTimeIntervalType.convertMATLABToIntermediate](#compilerbuildsparkdatadaytimeintervaltypeconvertmatlabtointermediate)
        * [compiler.build.spark.data.DayTimeIntervalType.convertPandaColumnToIntermediate](#compilerbuildsparkdatadaytimeintervaltypeconvertpandacolumntointermediate)
        * [compiler.build.spark.data.DayTimeIntervalType.genPythonExampleFunction](#compilerbuildsparkdatadaytimeintervaltypegenpythonexamplefunction)
        * [compiler.build.spark.data.DayTimeIntervalType.getMLPandasSeriesConverterCtor](#compilerbuildsparkdatadaytimeintervaltypegetmlpandasseriesconverterctor)
        * [compiler.build.spark.data.DayTimeIntervalType.getPyPandasSeriesConverterCtor](#compilerbuildsparkdatadaytimeintervaltypegetpypandasseriesconverterctor)
        * [compiler.build.spark.data.DayTimeIntervalType.instantiateMATLABExampleValue](#compilerbuildsparkdatadaytimeintervaltypeinstantiatematlabexamplevalue)
        * [compiler.build.spark.data.DayTimeIntervalType.instantiatePythonExampleValue](#compilerbuildsparkdatadaytimeintervaltypeinstantiatepythonexamplevalue)
        * [compiler.build.spark.data.DayTimeIntervalType.val_IMML_to_ML](#compilerbuildsparkdatadaytimeintervaltypeval_imml_to_ml)
        * [compiler.build.spark.data.DayTimeIntervalType.val_IMPY_to_IMML](#compilerbuildsparkdatadaytimeintervaltypeval_impy_to_imml)
        * [compiler.build.spark.data.DayTimeIntervalType.val_IMPY_to_Spark](#compilerbuildsparkdatadaytimeintervaltypeval_impy_to_spark)
        * [compiler.build.spark.data.DayTimeIntervalType.val_ML_to_IMML](#compilerbuildsparkdatadaytimeintervaltypeval_ml_to_imml)
        * [compiler.build.spark.data.DayTimeIntervalType.val_Spark_to_IMPY](#compilerbuildsparkdatadaytimeintervaltypeval_spark_to_impy)
      * [compiler.build.spark.data.DecimalType](#compilerbuildsparkdatadecimaltype)
        * [compiler.build.spark.data.DecimalType.DecimalType](#compilerbuildsparkdatadecimaltypedecimaltype)
        * [compiler.build.spark.data.DecimalType.PandasSeriesType](#compilerbuildsparkdatadecimaltypepandasseriestype)
        * [compiler.build.spark.data.DecimalType.UniqueTypeName](#compilerbuildsparkdatadecimaltypeuniquetypename)
        * [compiler.build.spark.data.DecimalType.col_IMML_to_IMPY](#compilerbuildsparkdatadecimaltypecol_imml_to_impy)
        * [compiler.build.spark.data.DecimalType.col_MATLABTable](#compilerbuildsparkdatadecimaltypecol_matlabtable)
        * [compiler.build.spark.data.DecimalType.genPythonExampleFunction](#compilerbuildsparkdatadecimaltypegenpythonexamplefunction)
        * [compiler.build.spark.data.DecimalType.getMLPandasSeriesConverterCtor](#compilerbuildsparkdatadecimaltypegetmlpandasseriesconverterctor)
        * [compiler.build.spark.data.DecimalType.getPyPandasSeriesConverterCtor](#compilerbuildsparkdatadecimaltypegetpypandasseriesconverterctor)
        * [compiler.build.spark.data.DecimalType.val_IMPY_to_Spark](#compilerbuildsparkdatadecimaltypeval_impy_to_spark)
        * [compiler.build.spark.data.DecimalType.val_MATLABTable](#compilerbuildsparkdatadecimaltypeval_matlabtable)
        * [compiler.build.spark.data.DecimalType.val_Spark_to_IMPY](#compilerbuildsparkdatadecimaltypeval_spark_to_impy)
      * [compiler.build.spark.data.DoubleType](#compilerbuildsparkdatadoubletype)
        * [compiler.build.spark.data.DoubleType.DoubleType](#compilerbuildsparkdatadoubletypedoubletype)
        * [compiler.build.spark.data.DoubleType.val_MATLABTable](#compilerbuildsparkdatadoubletypeval_matlabtable)
      * [compiler.build.spark.data.FloatType](#compilerbuildsparkdatafloattype)
        * [compiler.build.spark.data.FloatType.FloatType](#compilerbuildsparkdatafloattypefloattype)
        * [compiler.build.spark.data.FloatType.val_MATLABTable](#compilerbuildsparkdatafloattypeval_matlabtable)
      * [compiler.build.spark.data.FractionalType](#compilerbuildsparkdatafractionaltype)
        * [compiler.build.spark.data.FractionalType.FractionalType](#compilerbuildsparkdatafractionaltypefractionaltype)
        * [compiler.build.spark.data.FractionalType.genPythonExampleFunction](#compilerbuildsparkdatafractionaltypegenpythonexamplefunction)
      * [compiler.build.spark.data.IntegerType](#compilerbuildsparkdataintegertype)
        * [compiler.build.spark.data.IntegerType.IntegerType](#compilerbuildsparkdataintegertypeintegertype)
      * [compiler.build.spark.data.IntegralType](#compilerbuildsparkdataintegraltype)
        * [compiler.build.spark.data.IntegralType.IntegralType](#compilerbuildsparkdataintegraltypeintegraltype)
        * [compiler.build.spark.data.IntegralType.genPythonExampleFunction](#compilerbuildsparkdataintegraltypegenpythonexamplefunction)
        * [compiler.build.spark.data.IntegralType.val_MATLABTable](#compilerbuildsparkdataintegraltypeval_matlabtable)
      * [compiler.build.spark.data.LongType](#compilerbuildsparkdatalongtype)
        * [compiler.build.spark.data.LongType.LongType](#compilerbuildsparkdatalongtypelongtype)
      * [compiler.build.spark.data.MapType](#compilerbuildsparkdatamaptype)
        * [compiler.build.spark.data.MapType.MapType](#compilerbuildsparkdatamaptypemaptype)
        * [compiler.build.spark.data.MapType.PandasSeriesType](#compilerbuildsparkdatamaptypepandasseriestype)
        * [compiler.build.spark.data.MapType.UniqueTypeName](#compilerbuildsparkdatamaptypeuniquetypename)
        * [compiler.build.spark.data.MapType.col_IMML_to_IMPY](#compilerbuildsparkdatamaptypecol_imml_to_impy)
        * [compiler.build.spark.data.MapType.col_IMML_to_ML](#compilerbuildsparkdatamaptypecol_imml_to_ml)
        * [compiler.build.spark.data.MapType.col_IMPY_to_IMML](#compilerbuildsparkdatamaptypecol_impy_to_imml)
        * [compiler.build.spark.data.MapType.col_MATLABTable](#compilerbuildsparkdatamaptypecol_matlabtable)
        * [compiler.build.spark.data.MapType.col_ML_to_IMML](#compilerbuildsparkdatamaptypecol_ml_to_imml)
        * [compiler.build.spark.data.MapType.col_Spark_to_IMPY](#compilerbuildsparkdatamaptypecol_spark_to_impy)
        * [compiler.build.spark.data.MapType.genMATLABArray](#compilerbuildsparkdatamaptypegenmatlabarray)
        * [compiler.build.spark.data.MapType.genPythonExampleFunction](#compilerbuildsparkdatamaptypegenpythonexamplefunction)
        * [compiler.build.spark.data.MapType.getIndexString_](#compilerbuildsparkdatamaptypegetindexstring_)
        * [compiler.build.spark.data.MapType.getMLPandasSeriesConverterCtor](#compilerbuildsparkdatamaptypegetmlpandasseriesconverterctor)
        * [compiler.build.spark.data.MapType.getPyPandasSeriesConverterCtor](#compilerbuildsparkdatamaptypegetpypandasseriesconverterctor)
        * [compiler.build.spark.data.MapType.instantiatePythonExampleValue](#compilerbuildsparkdatamaptypeinstantiatepythonexamplevalue)
        * [compiler.build.spark.data.MapType.isLeaf](#compilerbuildsparkdatamaptypeisleaf)
        * [compiler.build.spark.data.MapType.preAllocateMATLABColumn](#compilerbuildsparkdatamaptypepreallocatematlabcolumn)
        * [compiler.build.spark.data.MapType.val_IMML_to_IMPY](#compilerbuildsparkdatamaptypeval_imml_to_impy)
        * [compiler.build.spark.data.MapType.val_IMML_to_ML](#compilerbuildsparkdatamaptypeval_imml_to_ml)
        * [compiler.build.spark.data.MapType.val_IMPY_to_IMML](#compilerbuildsparkdatamaptypeval_impy_to_imml)
        * [compiler.build.spark.data.MapType.val_IMPY_to_Spark](#compilerbuildsparkdatamaptypeval_impy_to_spark)
        * [compiler.build.spark.data.MapType.val_MATLABTable](#compilerbuildsparkdatamaptypeval_matlabtable)
        * [compiler.build.spark.data.MapType.val_ML_to_IMML](#compilerbuildsparkdatamaptypeval_ml_to_imml)
        * [compiler.build.spark.data.MapType.val_Spark_to_IMPY](#compilerbuildsparkdatamaptypeval_spark_to_impy)
      * [compiler.build.spark.data.NumericType](#compilerbuildsparkdatanumerictype)
        * [compiler.build.spark.data.NumericType.NumericType](#compilerbuildsparkdatanumerictypenumerictype)
        * [compiler.build.spark.data.NumericType.array_IMML_to_IMPY](#compilerbuildsparkdatanumerictypearray_imml_to_impy)
        * [compiler.build.spark.data.NumericType.array_IMPY_to_IMML](#compilerbuildsparkdatanumerictypearray_impy_to_imml)
        * [compiler.build.spark.data.NumericType.col_IMML_to_IMPY](#compilerbuildsparkdatanumerictypecol_imml_to_impy)
        * [compiler.build.spark.data.NumericType.col_IMPY_to_IMML](#compilerbuildsparkdatanumerictypecol_impy_to_imml)
        * [compiler.build.spark.data.NumericType.convertStructColumn](#compilerbuildsparkdatanumerictypeconvertstructcolumn)
        * [compiler.build.spark.data.NumericType.genMATLABArray](#compilerbuildsparkdatanumerictypegenmatlabarray)
        * [compiler.build.spark.data.NumericType.getMLPandasSeriesConverterCtor](#compilerbuildsparkdatanumerictypegetmlpandasseriesconverterctor)
        * [compiler.build.spark.data.NumericType.getPyPandasSeriesConverterCtor](#compilerbuildsparkdatanumerictypegetpypandasseriesconverterctor)
        * [compiler.build.spark.data.NumericType.pandasSeriesToColumn](#compilerbuildsparkdatanumerictypepandasseriestocolumn)
        * [compiler.build.spark.data.NumericType.val_IMML_to_ML](#compilerbuildsparkdatanumerictypeval_imml_to_ml)
        * [compiler.build.spark.data.NumericType.val_IMPY_to_IMML](#compilerbuildsparkdatanumerictypeval_impy_to_imml)
      * [compiler.build.spark.data.ShortType](#compilerbuildsparkdatashorttype)
        * [compiler.build.spark.data.ShortType.ShortType](#compilerbuildsparkdatashorttypeshorttype)
      * [compiler.build.spark.data.StringType](#compilerbuildsparkdatastringtype)
        * [compiler.build.spark.data.StringType.StringType](#compilerbuildsparkdatastringtypestringtype)
        * [compiler.build.spark.data.StringType.arrayElemConverter](#compilerbuildsparkdatastringtypearrayelemconverter)
        * [compiler.build.spark.data.StringType.array_IMML_to_IMPY](#compilerbuildsparkdatastringtypearray_imml_to_impy)
        * [compiler.build.spark.data.StringType.array_IMML_to_ML](#compilerbuildsparkdatastringtypearray_imml_to_ml)
        * [compiler.build.spark.data.StringType.col_IMML_to_IMPY](#compilerbuildsparkdatastringtypecol_imml_to_impy)
        * [compiler.build.spark.data.StringType.col_IMML_to_ML](#compilerbuildsparkdatastringtypecol_imml_to_ml)
        * [compiler.build.spark.data.StringType.col_MATLABTable](#compilerbuildsparkdatastringtypecol_matlabtable)
        * [compiler.build.spark.data.StringType.convertIntermediateToMATLAB](#compilerbuildsparkdatastringtypeconvertintermediatetomatlab)
        * [compiler.build.spark.data.StringType.convertMATLABToIntermediate](#compilerbuildsparkdatastringtypeconvertmatlabtointermediate)
        * [compiler.build.spark.data.StringType.convertStructColumn](#compilerbuildsparkdatastringtypeconvertstructcolumn)
        * [compiler.build.spark.data.StringType.genMATLABArray](#compilerbuildsparkdatastringtypegenmatlabarray)
        * [compiler.build.spark.data.StringType.genPythonExampleFunction](#compilerbuildsparkdatastringtypegenpythonexamplefunction)
        * [compiler.build.spark.data.StringType.getMATLABColumnEntry](#compilerbuildsparkdatastringtypegetmatlabcolumnentry)
        * [compiler.build.spark.data.StringType.getMLPandasSeriesConverterCtor](#compilerbuildsparkdatastringtypegetmlpandasseriesconverterctor)
        * [compiler.build.spark.data.StringType.getPyPandasSeriesConverterCtor](#compilerbuildsparkdatastringtypegetpypandasseriesconverterctor)
        * [compiler.build.spark.data.StringType.instantiateMATLABExampleValue](#compilerbuildsparkdatastringtypeinstantiatematlabexamplevalue)
        * [compiler.build.spark.data.StringType.instantiatePythonExampleValue](#compilerbuildsparkdatastringtypeinstantiatepythonexamplevalue)
        * [compiler.build.spark.data.StringType.preAllocateMATLABColumn](#compilerbuildsparkdatastringtypepreallocatematlabcolumn)
        * [compiler.build.spark.data.StringType.val_IMML_to_ML](#compilerbuildsparkdatastringtypeval_imml_to_ml)
        * [compiler.build.spark.data.StringType.val_MATLABTable](#compilerbuildsparkdatastringtypeval_matlabtable)
      * [compiler.build.spark.data.StructField](#compilerbuildsparkdatastructfield)
        * [compiler.build.spark.data.StructField.StructField](#compilerbuildsparkdatastructfieldstructfield)
        * [compiler.build.spark.data.StructField.colName_](#compilerbuildsparkdatastructfieldcolname_)
        * [compiler.build.spark.data.StructField.getMLPandasSeriesConverterCtor](#compilerbuildsparkdatastructfieldgetmlpandasseriesconverterctor)
        * [compiler.build.spark.data.StructField.getPyPandasSeriesConverterCtor](#compilerbuildsparkdatastructfieldgetpypandasseriesconverterctor)
        * [compiler.build.spark.data.StructField.isLeaf](#compilerbuildsparkdatastructfieldisleaf)
      * [compiler.build.spark.data.StructType](#compilerbuildsparkdatastructtype)
        * [compiler.build.spark.data.StructType.NumFields](#compilerbuildsparkdatastructtypenumfields)
        * [compiler.build.spark.data.StructType.PandasSeriesType](#compilerbuildsparkdatastructtypepandasseriestype)
        * [compiler.build.spark.data.StructType.StructType](#compilerbuildsparkdatastructtypestructtype)
        * [compiler.build.spark.data.StructType.UniqueTypeName](#compilerbuildsparkdatastructtypeuniquetypename)
        * [compiler.build.spark.data.StructType.addIteratorRow](#compilerbuildsparkdatastructtypeadditeratorrow)
        * [compiler.build.spark.data.StructType.array_ML_to_IMML](#compilerbuildsparkdatastructtypearray_ml_to_imml)
        * [compiler.build.spark.data.StructType.col_IMML_to_IMPY](#compilerbuildsparkdatastructtypecol_imml_to_impy)
        * [compiler.build.spark.data.StructType.col_IMML_to_ML](#compilerbuildsparkdatastructtypecol_imml_to_ml)
        * [compiler.build.spark.data.StructType.col_IMPY_to_IMML](#compilerbuildsparkdatastructtypecol_impy_to_imml)
        * [compiler.build.spark.data.StructType.col_MATLABTable](#compilerbuildsparkdatastructtypecol_matlabtable)
        * [compiler.build.spark.data.StructType.col_ML_to_IMML](#compilerbuildsparkdatastructtypecol_ml_to_imml)
        * [compiler.build.spark.data.StructType.col_Spark_to_IMPY](#compilerbuildsparkdatastructtypecol_spark_to_impy)
        * [compiler.build.spark.data.StructType.colsIteratorInit](#compilerbuildsparkdatastructtypecolsiteratorinit)
        * [compiler.build.spark.data.StructType.convertMATLABToIntermediate](#compilerbuildsparkdatastructtypeconvertmatlabtointermediate)
        * [compiler.build.spark.data.StructType.convertPandaColumnToIntermediate](#compilerbuildsparkdatastructtypeconvertpandacolumntointermediate)
        * [compiler.build.spark.data.StructType.convertStructColumn](#compilerbuildsparkdatastructtypeconvertstructcolumn)
        * [compiler.build.spark.data.StructType.genPythonExampleFunction](#compilerbuildsparkdatastructtypegenpythonexamplefunction)
        * [compiler.build.spark.data.StructType.getMLPandasSeriesConverterCtor](#compilerbuildsparkdatastructtypegetmlpandasseriesconverterctor)
        * [compiler.build.spark.data.StructType.getPyPandasSeriesConverterCtor](#compilerbuildsparkdatastructtypegetpypandasseriesconverterctor)
        * [compiler.build.spark.data.StructType.instantiateMATLABExampleValue](#compilerbuildsparkdatastructtypeinstantiatematlabexamplevalue)
        * [compiler.build.spark.data.StructType.instantiatePythonExampleValue](#compilerbuildsparkdatastructtypeinstantiatepythonexamplevalue)
        * [compiler.build.spark.data.StructType.isLeaf](#compilerbuildsparkdatastructtypeisleaf)
        * [compiler.build.spark.data.StructType.table_IMML_to_ML](#compilerbuildsparkdatastructtypetable_imml_to_ml)
        * [compiler.build.spark.data.StructType.val_IMML_to_IMPY](#compilerbuildsparkdatastructtypeval_imml_to_impy)
        * [compiler.build.spark.data.StructType.val_IMML_to_ML](#compilerbuildsparkdatastructtypeval_imml_to_ml)
        * [compiler.build.spark.data.StructType.val_IMPY_to_IMML](#compilerbuildsparkdatastructtypeval_impy_to_imml)
        * [compiler.build.spark.data.StructType.val_IMPY_to_Spark](#compilerbuildsparkdatastructtypeval_impy_to_spark)
        * [compiler.build.spark.data.StructType.val_MATLABTable](#compilerbuildsparkdatastructtypeval_matlabtable)
        * [compiler.build.spark.data.StructType.val_ML_to_IMML](#compilerbuildsparkdatastructtypeval_ml_to_imml)
        * [compiler.build.spark.data.StructType.val_Spark_to_IMPY](#compilerbuildsparkdatastructtypeval_spark_to_impy)
      * [compiler.build.spark.data.TimestampNTZType](#compilerbuildsparkdatatimestampntztype)
        * [compiler.build.spark.data.TimestampNTZType.IntermediaryMATLABType](#compilerbuildsparkdatatimestampntztypeintermediarymatlabtype)
        * [compiler.build.spark.data.TimestampNTZType.IntermediaryPythonType](#compilerbuildsparkdatatimestampntztypeintermediarypythontype)
        * [compiler.build.spark.data.TimestampNTZType.PandasSeriesType](#compilerbuildsparkdatatimestampntztypepandasseriestype)
        * [compiler.build.spark.data.TimestampNTZType.TimestampNTZType](#compilerbuildsparkdatatimestampntztypetimestampntztype)
        * [compiler.build.spark.data.TimestampNTZType.array_Spark_to_IMPY](#compilerbuildsparkdatatimestampntztypearray_spark_to_impy)
        * [compiler.build.spark.data.TimestampNTZType.col_IMPY_to_IMML](#compilerbuildsparkdatatimestampntztypecol_impy_to_imml)
        * [compiler.build.spark.data.TimestampNTZType.col_MATLABTable](#compilerbuildsparkdatatimestampntztypecol_matlabtable)
        * [compiler.build.spark.data.TimestampNTZType.convertIntermediateToMATLAB](#compilerbuildsparkdatatimestampntztypeconvertintermediatetomatlab)
        * [compiler.build.spark.data.TimestampNTZType.convertMATLABToIntermediate](#compilerbuildsparkdatatimestampntztypeconvertmatlabtointermediate)
        * [compiler.build.spark.data.TimestampNTZType.genMATLABArray](#compilerbuildsparkdatatimestampntztypegenmatlabarray)
        * [compiler.build.spark.data.TimestampNTZType.genPythonExampleFunction](#compilerbuildsparkdatatimestampntztypegenpythonexamplefunction)
        * [compiler.build.spark.data.TimestampNTZType.getMLPandasSeriesConverterCtor](#compilerbuildsparkdatatimestampntztypegetmlpandasseriesconverterctor)
        * [compiler.build.spark.data.TimestampNTZType.getPyPandasSeriesConverterCtor](#compilerbuildsparkdatatimestampntztypegetpypandasseriesconverterctor)
        * [compiler.build.spark.data.TimestampNTZType.instantiateColExampleData](#compilerbuildsparkdatatimestampntztypeinstantiatecolexampledata)
        * [compiler.build.spark.data.TimestampNTZType.instantiateMATLABExampleValue](#compilerbuildsparkdatatimestampntztypeinstantiatematlabexamplevalue)
        * [compiler.build.spark.data.TimestampNTZType.instantiatePythonExampleValue](#compilerbuildsparkdatatimestampntztypeinstantiatepythonexamplevalue)
        * [compiler.build.spark.data.TimestampNTZType.preAllocateMATLABColumn](#compilerbuildsparkdatatimestampntztypepreallocatematlabcolumn)
        * [compiler.build.spark.data.TimestampNTZType.val_IMML_to_ML](#compilerbuildsparkdatatimestampntztypeval_imml_to_ml)
        * [compiler.build.spark.data.TimestampNTZType.val_IMPY_to_IMML](#compilerbuildsparkdatatimestampntztypeval_impy_to_imml)
        * [compiler.build.spark.data.TimestampNTZType.val_IMPY_to_Spark](#compilerbuildsparkdatatimestampntztypeval_impy_to_spark)
        * [compiler.build.spark.data.TimestampNTZType.val_MATLABTable](#compilerbuildsparkdatatimestampntztypeval_matlabtable)
        * [compiler.build.spark.data.TimestampNTZType.val_ML_to_IMML](#compilerbuildsparkdatatimestampntztypeval_ml_to_imml)
        * [compiler.build.spark.data.TimestampNTZType.val_Spark_to_IMPY](#compilerbuildsparkdatatimestampntztypeval_spark_to_impy)
      * [compiler.build.spark.data.TimestampType](#compilerbuildsparkdatatimestamptype)
        * [compiler.build.spark.data.TimestampType.IntermediaryMATLABType](#compilerbuildsparkdatatimestamptypeintermediarymatlabtype)
        * [compiler.build.spark.data.TimestampType.IntermediaryPythonType](#compilerbuildsparkdatatimestamptypeintermediarypythontype)
        * [compiler.build.spark.data.TimestampType.PandasSeriesType](#compilerbuildsparkdatatimestamptypepandasseriestype)
        * [compiler.build.spark.data.TimestampType.TimestampType](#compilerbuildsparkdatatimestamptypetimestamptype)
        * [compiler.build.spark.data.TimestampType.array_Spark_to_IMPY](#compilerbuildsparkdatatimestamptypearray_spark_to_impy)
        * [compiler.build.spark.data.TimestampType.col_MATLABTable](#compilerbuildsparkdatatimestamptypecol_matlabtable)
        * [compiler.build.spark.data.TimestampType.convertIntermediateToMATLAB](#compilerbuildsparkdatatimestamptypeconvertintermediatetomatlab)
        * [compiler.build.spark.data.TimestampType.convertMATLABToIntermediate](#compilerbuildsparkdatatimestamptypeconvertmatlabtointermediate)
        * [compiler.build.spark.data.TimestampType.genMATLABArray](#compilerbuildsparkdatatimestamptypegenmatlabarray)
        * [compiler.build.spark.data.TimestampType.genPythonExampleFunction](#compilerbuildsparkdatatimestamptypegenpythonexamplefunction)
        * [compiler.build.spark.data.TimestampType.getMLPandasSeriesConverterCtor](#compilerbuildsparkdatatimestamptypegetmlpandasseriesconverterctor)
        * [compiler.build.spark.data.TimestampType.getPyPandasSeriesConverterCtor](#compilerbuildsparkdatatimestamptypegetpypandasseriesconverterctor)
        * [compiler.build.spark.data.TimestampType.instantiateColExampleData](#compilerbuildsparkdatatimestamptypeinstantiatecolexampledata)
        * [compiler.build.spark.data.TimestampType.instantiateMATLABExampleValue](#compilerbuildsparkdatatimestamptypeinstantiatematlabexamplevalue)
        * [compiler.build.spark.data.TimestampType.instantiatePythonExampleValue](#compilerbuildsparkdatatimestamptypeinstantiatepythonexamplevalue)
        * [compiler.build.spark.data.TimestampType.preAllocateMATLABColumn](#compilerbuildsparkdatatimestamptypepreallocatematlabcolumn)
        * [compiler.build.spark.data.TimestampType.val_IMML_to_ML](#compilerbuildsparkdatatimestamptypeval_imml_to_ml)
        * [compiler.build.spark.data.TimestampType.val_IMPY_to_Spark](#compilerbuildsparkdatatimestamptypeval_impy_to_spark)
        * [compiler.build.spark.data.TimestampType.val_MATLABTable](#compilerbuildsparkdatatimestamptypeval_matlabtable)
        * [compiler.build.spark.data.TimestampType.val_ML_to_IMML](#compilerbuildsparkdatatimestamptypeval_ml_to_imml)
        * [compiler.build.spark.data.TimestampType.val_Spark_to_IMPY](#compilerbuildsparkdatatimestamptypeval_spark_to_impy)
      * [compiler.build.spark.data.fromSchema](#compilerbuildsparkdatafromschema)
    * [compiler.build.spark.internal](#compilerbuildsparkinternal)
      * [compiler.build.spark.internal.calcDigest](#compilerbuildsparkinternalcalcdigest)
      * [compiler.build.spark.internal.getArgNames](#compilerbuildsparkinternalgetargnames)
      * [compiler.build.spark.internal.getFcnFileName](#compilerbuildsparkinternalgetfcnfilename)
      * [compiler.build.spark.internal.getJSONName](#compilerbuildsparkinternalgetjsonname)
      * [compiler.build.spark.internal.getSchemaName](#compilerbuildsparkinternalgetschemaname)
      * [compiler.build.spark.internal.hasMWStringArray](#compilerbuildsparkinternalhasmwstringarray)
      * [compiler.build.spark.internal.rowOutputsToTable](#compilerbuildsparkinternalrowoutputstotable)
      * [compiler.build.spark.internal.shortenIdentifier](#compilerbuildsparkinternalshortenidentifier)
      * [compiler.build.spark.internal.tableDebugInfo](#compilerbuildsparkinternaltabledebuginfo)
      * [compiler.build.spark.internal.tableToColumnInputs](#compilerbuildsparkinternaltabletocolumninputs)
      * [compiler.build.spark.internal.tableToRowInputs](#compilerbuildsparkinternaltabletorowinputs)
    * [compiler.build.spark.schema](#compilerbuildsparkschema)
      * [compiler.build.spark.schema.mathworks](#compilerbuildsparkschemamathworks)
        * [compiler.build.spark.schema.mathworks.CommonBase](#compilerbuildsparkschemamathworkscommonbase)
          * [compiler.build.spark.schema.mathworks.CommonBase.CommonBase](#compilerbuildsparkschemamathworkscommonbasecommonbase)
          * [compiler.build.spark.schema.mathworks.CommonBase.classFromType](#compilerbuildsparkschemamathworkscommonbaseclassfromtype)
          * [compiler.build.spark.schema.mathworks.CommonBase.fromVal](#compilerbuildsparkschemamathworkscommonbasefromval)
          * [compiler.build.spark.schema.mathworks.CommonBase.instanceFromVal](#compilerbuildsparkschemamathworkscommonbaseinstancefromval)
          * [compiler.build.spark.schema.mathworks.CommonBase.json](#compilerbuildsparkschemamathworkscommonbasejson)
          * [compiler.build.spark.schema.mathworks.CommonBase.load](#compilerbuildsparkschemamathworkscommonbaseload)
          * [compiler.build.spark.schema.mathworks.CommonBase.toStruct](#compilerbuildsparkschemamathworkscommonbasetostruct)
        * [compiler.build.spark.schema.mathworks.CompilerType](#compilerbuildsparkschemamathworkscompilertype)
          * [compiler.build.spark.schema.mathworks.CompilerType.CompilerType](#compilerbuildsparkschemamathworkscompilertypecompilertype)
          * [compiler.build.spark.schema.mathworks.CompilerType.addInput](#compilerbuildsparkschemamathworkscompilertypeaddinput)
          * [compiler.build.spark.schema.mathworks.CompilerType.addOutput](#compilerbuildsparkschemamathworkscompilertypeaddoutput)
          * [compiler.build.spark.schema.mathworks.CompilerType.checkTypeCompliance](#compilerbuildsparkschemamathworkscompilertypechecktypecompliance)
          * [compiler.build.spark.schema.mathworks.CompilerType.fromVal](#compilerbuildsparkschemamathworkscompilertypefromval)
          * [compiler.build.spark.schema.mathworks.CompilerType.init](#compilerbuildsparkschemamathworkscompilertypeinit)
          * [compiler.build.spark.schema.mathworks.CompilerType.toStruct](#compilerbuildsparkschemamathworkscompilertypetostruct)
        * [compiler.build.spark.schema.mathworks.DHMSInterval](#compilerbuildsparkschemamathworksdhmsinterval)
          * [compiler.build.spark.schema.mathworks.DHMSInterval.DHMSInterval](#compilerbuildsparkschemamathworksdhmsintervaldhmsinterval)
        * [compiler.build.spark.schema.mathworks.IOType](#compilerbuildsparkschemamathworksiotype)
          * [compiler.build.spark.schema.mathworks.IOType.IOType](#compilerbuildsparkschemamathworksiotypeiotype)
          * [compiler.build.spark.schema.mathworks.IOType.fromVal](#compilerbuildsparkschemamathworksiotypefromval)
          * [compiler.build.spark.schema.mathworks.IOType.init3_4](#compilerbuildsparkschemamathworksiotypeinit3_4)
          * [compiler.build.spark.schema.mathworks.IOType.pythonInitCode](#compilerbuildsparkschemamathworksiotypepythoninitcode)
          * [compiler.build.spark.schema.mathworks.IOType.toStruct](#compilerbuildsparkschemamathworksiotypetostruct)
        * [compiler.build.spark.schema.mathworks.NonSparkType](#compilerbuildsparkschemamathworksnonsparktype)
          * [compiler.build.spark.schema.mathworks.NonSparkType.NonSparkType](#compilerbuildsparkschemamathworksnonsparktypenonsparktype)
        * [compiler.build.spark.schema.mathworks.generateFunctionSchema](#compilerbuildsparkschemamathworksgeneratefunctionschema)
      * [compiler.build.spark.schema.AnsiIntervalType](#compilerbuildsparkschemaansiintervaltype)
        * [compiler.build.spark.schema.AnsiIntervalType.AnsiIntervalType](#compilerbuildsparkschemaansiintervaltypeansiintervaltype)
      * [compiler.build.spark.schema.ArrayType](#compilerbuildsparkschemaarraytype)
        * [compiler.build.spark.schema.ArrayType.ArrayType](#compilerbuildsparkschemaarraytypearraytype)
        * [compiler.build.spark.schema.ArrayType.fromVal](#compilerbuildsparkschemaarraytypefromval)
        * [compiler.build.spark.schema.ArrayType.getPythonImports](#compilerbuildsparkschemaarraytypegetpythonimports)
        * [compiler.build.spark.schema.ArrayType.pythonInitCode](#compilerbuildsparkschemaarraytypepythoninitcode)
        * [compiler.build.spark.schema.ArrayType.pythonSchemaType](#compilerbuildsparkschemaarraytypepythonschematype)
        * [compiler.build.spark.schema.ArrayType.toStruct](#compilerbuildsparkschemaarraytypetostruct)
      * [compiler.build.spark.schema.AtomicType](#compilerbuildsparkschemaatomictype)
        * [compiler.build.spark.schema.AtomicType.AtomicType](#compilerbuildsparkschemaatomictypeatomictype)
      * [compiler.build.spark.schema.BinaryType](#compilerbuildsparkschemabinarytype)
        * [compiler.build.spark.schema.BinaryType.BinaryType](#compilerbuildsparkschemabinarytypebinarytype)
      * [compiler.build.spark.schema.BooleanType](#compilerbuildsparkschemabooleantype)
        * [compiler.build.spark.schema.BooleanType.BooleanType](#compilerbuildsparkschemabooleantypebooleantype)
      * [compiler.build.spark.schema.ByteType](#compilerbuildsparkschemabytetype)
        * [compiler.build.spark.schema.ByteType.ByteType](#compilerbuildsparkschemabytetypebytetype)
      * [compiler.build.spark.schema.DataType](#compilerbuildsparkschemadatatype)
        * [compiler.build.spark.schema.DataType.DataType](#compilerbuildsparkschemadatatypedatatype)
        * [compiler.build.spark.schema.DataType.arrayToSchema_col](#compilerbuildsparkschemadatatypearraytoschema_col)
        * [compiler.build.spark.schema.DataType.createSchema](#compilerbuildsparkschemadatatypecreateschema)
        * [compiler.build.spark.schema.DataType.getClassTS](#compilerbuildsparkschemadatatypegetclassts)
        * [compiler.build.spark.schema.DataType.getPythonImports](#compilerbuildsparkschemadatatypegetpythonimports)
        * [compiler.build.spark.schema.DataType.getSparkType](#compilerbuildsparkschemadatatypegetsparktype)
        * [compiler.build.spark.schema.DataType.matlabClassToSchema](#compilerbuildsparkschemadatatypematlabclasstoschema)
        * [compiler.build.spark.schema.DataType.matlabClassToSchema_col](#compilerbuildsparkschemadatatypematlabclasstoschema_col)
        * [compiler.build.spark.schema.DataType.matlabValueToSchema](#compilerbuildsparkschemadatatypematlabvaluetoschema)
        * [compiler.build.spark.schema.DataType.pyTF](#compilerbuildsparkschemadatatypepytf)
        * [compiler.build.spark.schema.DataType.pyTypeToSchema](#compilerbuildsparkschemadatatypepytypetoschema)
        * [compiler.build.spark.schema.DataType.pythonInitCode](#compilerbuildsparkschemadatatypepythoninitcode)
        * [compiler.build.spark.schema.DataType.pythonSchemaType](#compilerbuildsparkschemadatatypepythonschematype)
        * [compiler.build.spark.schema.DataType.pythonType](#compilerbuildsparkschemadatatypepythontype)
        * [compiler.build.spark.schema.DataType.structToSchema](#compilerbuildsparkschemadatatypestructtoschema)
        * [compiler.build.spark.schema.DataType.structToSchema_col](#compilerbuildsparkschemadatatypestructtoschema_col)
        * [compiler.build.spark.schema.DataType.tableColumnToSchema](#compilerbuildsparkschemadatatypetablecolumntoschema)
        * [compiler.build.spark.schema.DataType.tableColumnToSchema_old](#compilerbuildsparkschemadatatypetablecolumntoschema_old)
        * [compiler.build.spark.schema.DataType.tableToSchema](#compilerbuildsparkschemadatatypetabletoschema)
      * [compiler.build.spark.schema.DateType](#compilerbuildsparkschemadatetype)
        * [compiler.build.spark.schema.DateType.DateType](#compilerbuildsparkschemadatetypedatetype)
      * [compiler.build.spark.schema.DayTimeIntervalType](#compilerbuildsparkschemadaytimeintervaltype)
        * [compiler.build.spark.schema.DayTimeIntervalType.DayTimeIntervalType](#compilerbuildsparkschemadaytimeintervaltypedaytimeintervaltype)
        * [compiler.build.spark.schema.DayTimeIntervalType.pythonInitCode](#compilerbuildsparkschemadaytimeintervaltypepythoninitcode)
        * [compiler.build.spark.schema.DayTimeIntervalType.pythonSchemaType](#compilerbuildsparkschemadaytimeintervaltypepythonschematype)
        * [compiler.build.spark.schema.DayTimeIntervalType.toStruct](#compilerbuildsparkschemadaytimeintervaltypetostruct)
      * [compiler.build.spark.schema.DecimalType](#compilerbuildsparkschemadecimaltype)
        * [compiler.build.spark.schema.DecimalType.DecimalType](#compilerbuildsparkschemadecimaltypedecimaltype)
        * [compiler.build.spark.schema.DecimalType.pythonInitCode](#compilerbuildsparkschemadecimaltypepythoninitcode)
        * [compiler.build.spark.schema.DecimalType.pythonSchemaType](#compilerbuildsparkschemadecimaltypepythonschematype)
        * [compiler.build.spark.schema.DecimalType.toStruct](#compilerbuildsparkschemadecimaltypetostruct)
      * [compiler.build.spark.schema.DoubleType](#compilerbuildsparkschemadoubletype)
        * [compiler.build.spark.schema.DoubleType.DoubleType](#compilerbuildsparkschemadoubletypedoubletype)
      * [compiler.build.spark.schema.FloatType](#compilerbuildsparkschemafloattype)
        * [compiler.build.spark.schema.FloatType.FloatType](#compilerbuildsparkschemafloattypefloattype)
      * [compiler.build.spark.schema.FractionalType](#compilerbuildsparkschemafractionaltype)
        * [compiler.build.spark.schema.FractionalType.FractionalType](#compilerbuildsparkschemafractionaltypefractionaltype)
      * [compiler.build.spark.schema.IntegerType](#compilerbuildsparkschemaintegertype)
        * [compiler.build.spark.schema.IntegerType.IntegerType](#compilerbuildsparkschemaintegertypeintegertype)
      * [compiler.build.spark.schema.IntegralType](#compilerbuildsparkschemaintegraltype)
        * [compiler.build.spark.schema.IntegralType.IntegralType](#compilerbuildsparkschemaintegraltypeintegraltype)
      * [compiler.build.spark.schema.LongType](#compilerbuildsparkschemalongtype)
        * [compiler.build.spark.schema.LongType.LongType](#compilerbuildsparkschemalongtypelongtype)
        * [compiler.build.spark.schema.LongType.pythonSchemaType](#compilerbuildsparkschemalongtypepythonschematype)
      * [compiler.build.spark.schema.MapType](#compilerbuildsparkschemamaptype)
        * [compiler.build.spark.schema.MapType.MapType](#compilerbuildsparkschemamaptypemaptype)
        * [compiler.build.spark.schema.MapType.fromVal](#compilerbuildsparkschemamaptypefromval)
        * [compiler.build.spark.schema.MapType.getPythonImports](#compilerbuildsparkschemamaptypegetpythonimports)
        * [compiler.build.spark.schema.MapType.pythonInitCode](#compilerbuildsparkschemamaptypepythoninitcode)
        * [compiler.build.spark.schema.MapType.pythonSchemaType](#compilerbuildsparkschemamaptypepythonschematype)
        * [compiler.build.spark.schema.MapType.toStruct](#compilerbuildsparkschemamaptypetostruct)
      * [compiler.build.spark.schema.NumericType](#compilerbuildsparkschemanumerictype)
        * [compiler.build.spark.schema.NumericType.NumericType](#compilerbuildsparkschemanumerictypenumerictype)
      * [compiler.build.spark.schema.ShortType](#compilerbuildsparkschemashorttype)
        * [compiler.build.spark.schema.ShortType.ShortType](#compilerbuildsparkschemashorttypeshorttype)
      * [compiler.build.spark.schema.StringType](#compilerbuildsparkschemastringtype)
        * [compiler.build.spark.schema.StringType.StringType](#compilerbuildsparkschemastringtypestringtype)
      * [compiler.build.spark.schema.StructField](#compilerbuildsparkschemastructfield)
        * [compiler.build.spark.schema.StructField.StructField](#compilerbuildsparkschemastructfieldstructfield)
        * [compiler.build.spark.schema.StructField.initSeparateFields](#compilerbuildsparkschemastructfieldinitseparatefields)
        * [compiler.build.spark.schema.StructField.initStructField](#compilerbuildsparkschemastructfieldinitstructfield)
        * [compiler.build.spark.schema.StructField.pythonInitCode](#compilerbuildsparkschemastructfieldpythoninitcode)
        * [compiler.build.spark.schema.StructField.toStruct](#compilerbuildsparkschemastructfieldtostruct)
      * [compiler.build.spark.schema.StructType](#compilerbuildsparkschemastructtype)
        * [compiler.build.spark.schema.StructType.StructType](#compilerbuildsparkschemastructtypestructtype)
        * [compiler.build.spark.schema.StructType.add](#compilerbuildsparkschemastructtypeadd)
        * [compiler.build.spark.schema.StructType.fromVal](#compilerbuildsparkschemastructtypefromval)
        * [compiler.build.spark.schema.StructType.pythonInitCode](#compilerbuildsparkschemastructtypepythoninitcode)
        * [compiler.build.spark.schema.StructType.pythonSchemaType](#compilerbuildsparkschemastructtypepythonschematype)
        * [compiler.build.spark.schema.StructType.toStruct](#compilerbuildsparkschemastructtypetostruct)
      * [compiler.build.spark.schema.TimestampNTZType](#compilerbuildsparkschematimestampntztype)
        * [compiler.build.spark.schema.TimestampNTZType.TimestampNTZType](#compilerbuildsparkschematimestampntztypetimestampntztype)
      * [compiler.build.spark.schema.TimestampType](#compilerbuildsparkschematimestamptype)
        * [compiler.build.spark.schema.TimestampType.TimestampType](#compilerbuildsparkschematimestamptypetimestamptype)
    * [compiler.build.spark.transformers](#compilerbuildsparktransformers)
      * [compiler.build.spark.transformers.PandasTransformer](#compilerbuildsparktransformerspandastransformer)
        * [compiler.build.spark.transformers.PandasTransformer.PandasTransformer](#compilerbuildsparktransformerspandastransformerpandastransformer)
        * [compiler.build.spark.transformers.PandasTransformer.generate](#compilerbuildsparktransformerspandastransformergenerate)
      * [compiler.build.spark.transformers.PythonTransformer](#compilerbuildsparktransformerspythontransformer)
        * [compiler.build.spark.transformers.PythonTransformer.PythonTransformer](#compilerbuildsparktransformerspythontransformerpythontransformer)
      * [compiler.build.spark.transformers.Transformer](#compilerbuildsparktransformerstransformer)
        * [compiler.build.spark.transformers.Transformer.Transformer](#compilerbuildsparktransformerstransformertransformer)
    * [compiler.build.spark.types](#compilerbuildsparktypes)
      * [compiler.build.spark.types.ArgType](#compilerbuildsparktypesargtype)
        * [compiler.build.spark.types.ArgType.ArgType](#compilerbuildsparktypesargtypeargtype)
        * [compiler.build.spark.types.ArgType.castLongColumnToValue](#compilerbuildsparktypesargtypecastlongcolumntovalue)
        * [compiler.build.spark.types.ArgType.convertExternalToIntermediate](#compilerbuildsparktypesargtypeconvertexternaltointermediate)
        * [compiler.build.spark.types.ArgType.convertIntermediateColumnForRuntime](#compilerbuildsparktypesargtypeconvertintermediatecolumnforruntime)
        * [compiler.build.spark.types.ArgType.convertIntermediateMWColumnToExternal](#compilerbuildsparktypesargtypeconvertintermediatemwcolumntoexternal)
        * [compiler.build.spark.types.ArgType.convertIntermediateToExternal](#compilerbuildsparktypesargtypeconvertintermediatetoexternal)
        * [compiler.build.spark.types.ArgType.convertIntermediateToMATLAB](#compilerbuildsparktypesargtypeconvertintermediatetomatlab)
        * [compiler.build.spark.types.ArgType.convertIntermediatelColumnToMATLAB](#compilerbuildsparktypesargtypeconvertintermediatelcolumntomatlab)
        * [compiler.build.spark.types.ArgType.convertMATLABToIntermediate](#compilerbuildsparktypesargtypeconvertmatlabtointermediate)
        * [compiler.build.spark.types.ArgType.convertMWToRetValue](#compilerbuildsparktypesargtypeconvertmwtoretvalue)
        * [compiler.build.spark.types.ArgType.convertMWValueForPython](#compilerbuildsparktypesargtypeconvertmwvalueforpython)
        * [compiler.build.spark.types.ArgType.convertPandaColumnFromIntermediate](#compilerbuildsparktypesargtypeconvertpandacolumnfromintermediate)
        * [compiler.build.spark.types.ArgType.convertPandaColumnToIntermediate](#compilerbuildsparktypesargtypeconvertpandacolumntointermediate)
        * [compiler.build.spark.types.ArgType.convertPythonValueForMW](#compilerbuildsparktypesargtypeconvertpythonvalueformw)
        * [compiler.build.spark.types.ArgType.createMWValueToJavaStatement](#compilerbuildsparktypesargtypecreatemwvaluetojavastatement)
        * [compiler.build.spark.types.ArgType.declareAndSetRowValue](#compilerbuildsparktypesargtypedeclareandsetrowvalue)
        * [compiler.build.spark.types.ArgType.genInterColToPySeries](#compilerbuildsparktypesargtypegenintercoltopyseries)
        * [compiler.build.spark.types.ArgType.genIntermediateArrayToPython](#compilerbuildsparktypesargtypegenintermediatearraytopython)
        * [compiler.build.spark.types.ArgType.getBoxedJavaValue](#compilerbuildsparktypesargtypegetboxedjavavalue)
        * [compiler.build.spark.types.ArgType.getBuildType](#compilerbuildsparktypesargtypegetbuildtype)
        * [compiler.build.spark.types.ArgType.getColumnElemType](#compilerbuildsparktypesargtypegetcolumnelemtype)
        * [compiler.build.spark.types.ArgType.getComma](#compilerbuildsparktypesargtypegetcomma)
        * [compiler.build.spark.types.ArgType.getEncoderCreator](#compilerbuildsparktypesargtypegetencodercreator)
        * [compiler.build.spark.types.ArgType.getEncoderInstantiation](#compilerbuildsparktypesargtypegetencoderinstantiation)
        * [compiler.build.spark.types.ArgType.getEncoderType](#compilerbuildsparktypesargtypegetencodertype)
        * [compiler.build.spark.types.ArgType.getFileParent](#compilerbuildsparktypesargtypegetfileparent)
        * [compiler.build.spark.types.ArgType.getFuncArgType](#compilerbuildsparktypesargtypegetfuncargtype)
        * [compiler.build.spark.types.ArgType.getFuncArgTypes](#compilerbuildsparktypesargtypegetfuncargtypes)
        * [compiler.build.spark.types.ArgType.getJavaType](#compilerbuildsparktypesargtypegetjavatype)
        * [compiler.build.spark.types.ArgType.getMATLABHelperInputConversion](#compilerbuildsparktypesargtypegetmatlabhelperinputconversion)
        * [compiler.build.spark.types.ArgType.getMATLABHelperOutputConversion](#compilerbuildsparktypesargtypegetmatlabhelperoutputconversion)
        * [compiler.build.spark.types.ArgType.getMATLABInputColumn](#compilerbuildsparktypesargtypegetmatlabinputcolumn)
        * [compiler.build.spark.types.ArgType.getMWArgType](#compilerbuildsparktypesargtypegetmwargtype)
        * [compiler.build.spark.types.ArgType.getMWResultType](#compilerbuildsparktypesargtypegetmwresulttype)
        * [compiler.build.spark.types.ArgType.getPrimitiveJavaType](#compilerbuildsparktypesargtypegetprimitivejavatype)
        * [compiler.build.spark.types.ArgType.getReturnType](#compilerbuildsparktypesargtypegetreturntype)
        * [compiler.build.spark.types.ArgType.getReturnTypes](#compilerbuildsparktypesargtypegetreturntypes)
        * [compiler.build.spark.types.ArgType.getRowInputValue](#compilerbuildsparktypesargtypegetrowinputvalue)
        * [compiler.build.spark.types.ArgType.getSparkTypeConstructor](#compilerbuildsparktypesargtypegetsparktypeconstructor)
        * [compiler.build.spark.types.ArgType.getUDFFuncArgType](#compilerbuildsparktypesargtypegetudffuncargtype)
        * [compiler.build.spark.types.ArgType.getVectorLength](#compilerbuildsparktypesargtypegetvectorlength)
        * [compiler.build.spark.types.ArgType.init](#compilerbuildsparktypesargtypeinit)
        * [compiler.build.spark.types.ArgType.instantiate](#compilerbuildsparktypesargtypeinstantiate)
        * [compiler.build.spark.types.ArgType.instantiateMWValue](#compilerbuildsparktypesargtypeinstantiatemwvalue)
        * [compiler.build.spark.types.ArgType.instantiatePythonExampleValue](#compilerbuildsparktypesargtypeinstantiatepythonexamplevalue)
        * [compiler.build.spark.types.ArgType.instantiateScalaExampleValue](#compilerbuildsparktypesargtypeinstantiatescalaexamplevalue)
        * [compiler.build.spark.types.ArgType.isArray](#compilerbuildsparktypesargtypeisarray)
        * [compiler.build.spark.types.ArgType.isJavaBuild](#compilerbuildsparktypesargtypeisjavabuild)
        * [compiler.build.spark.types.ArgType.isPythonBuild](#compilerbuildsparktypesargtypeispythonbuild)
        * [compiler.build.spark.types.ArgType.isScalarData](#compilerbuildsparktypesargtypeisscalardata)
        * [compiler.build.spark.types.ArgType.pythonInputArgumentNeedsCasting](#compilerbuildsparktypesargtypepythoninputargumentneedscasting)
        * [compiler.build.spark.types.ArgType.pythonSchemaType](#compilerbuildsparktypesargtypepythonschematype)
        * [compiler.build.spark.types.ArgType.setParent](#compilerbuildsparktypesargtypesetparent)
      * [compiler.build.spark.types.Boolean](#compilerbuildsparktypesboolean)
        * [compiler.build.spark.types.Boolean.Boolean](#compilerbuildsparktypesbooleanboolean)
        * [compiler.build.spark.types.Boolean.convertMWToRetValue](#compilerbuildsparktypesbooleanconvertmwtoretvalue)
        * [compiler.build.spark.types.Boolean.getEncoderInstantiation](#compilerbuildsparktypesbooleangetencoderinstantiation)
        * [compiler.build.spark.types.Boolean.getEncoderType](#compilerbuildsparktypesbooleangetencodertype)
        * [compiler.build.spark.types.Boolean.instantiateScalaExampleValue](#compilerbuildsparktypesbooleaninstantiatescalaexamplevalue)
      * [compiler.build.spark.types.Double](#compilerbuildsparktypesdouble)
        * [compiler.build.spark.types.Double.Double](#compilerbuildsparktypesdoubledouble)
        * [compiler.build.spark.types.Double.convertIntermediateToExternal](#compilerbuildsparktypesdoubleconvertintermediatetoexternal)
        * [compiler.build.spark.types.Double.convertMWToRetValue](#compilerbuildsparktypesdoubleconvertmwtoretvalue)
        * [compiler.build.spark.types.Double.convertMWValueForPython](#compilerbuildsparktypesdoubleconvertmwvalueforpython)
        * [compiler.build.spark.types.Double.getEncoderInstantiation](#compilerbuildsparktypesdoublegetencoderinstantiation)
        * [compiler.build.spark.types.Double.getEncoderType](#compilerbuildsparktypesdoublegetencodertype)
      * [compiler.build.spark.types.Float](#compilerbuildsparktypesfloat)
        * [compiler.build.spark.types.Float.Float](#compilerbuildsparktypesfloatfloat)
        * [compiler.build.spark.types.Float.convertIntermediateToMATLAB](#compilerbuildsparktypesfloatconvertintermediatetomatlab)
        * [compiler.build.spark.types.Float.convertMWToRetValue](#compilerbuildsparktypesfloatconvertmwtoretvalue)
        * [compiler.build.spark.types.Float.convertMWValueForPython](#compilerbuildsparktypesfloatconvertmwvalueforpython)
        * [compiler.build.spark.types.Float.getEncoderInstantiation](#compilerbuildsparktypesfloatgetencoderinstantiation)
        * [compiler.build.spark.types.Float.getEncoderType](#compilerbuildsparktypesfloatgetencodertype)
        * [compiler.build.spark.types.Float.getMATLABHelperInputConversion](#compilerbuildsparktypesfloatgetmatlabhelperinputconversion)
      * [compiler.build.spark.types.Integer](#compilerbuildsparktypesinteger)
        * [compiler.build.spark.types.Integer.Integer](#compilerbuildsparktypesintegerinteger)
        * [compiler.build.spark.types.Integer.castLongColumnToValue](#compilerbuildsparktypesintegercastlongcolumntovalue)
        * [compiler.build.spark.types.Integer.convertIntermediateToMATLAB](#compilerbuildsparktypesintegerconvertintermediatetomatlab)
        * [compiler.build.spark.types.Integer.convertMWToRetValue](#compilerbuildsparktypesintegerconvertmwtoretvalue)
        * [compiler.build.spark.types.Integer.convertMWValueForPython](#compilerbuildsparktypesintegerconvertmwvalueforpython)
        * [compiler.build.spark.types.Integer.getEncoderInstantiation](#compilerbuildsparktypesintegergetencoderinstantiation)
        * [compiler.build.spark.types.Integer.getEncoderType](#compilerbuildsparktypesintegergetencodertype)
        * [compiler.build.spark.types.Integer.getMATLABHelperInputConversion](#compilerbuildsparktypesintegergetmatlabhelperinputconversion)
        * [compiler.build.spark.types.Integer.instantiateScalaExampleValue](#compilerbuildsparktypesintegerinstantiatescalaexamplevalue)
      * [compiler.build.spark.types.Long](#compilerbuildsparktypeslong)
        * [compiler.build.spark.types.Long.Long](#compilerbuildsparktypeslonglong)
        * [compiler.build.spark.types.Long.convertMWToRetValue](#compilerbuildsparktypeslongconvertmwtoretvalue)
        * [compiler.build.spark.types.Long.convertMWValueForPython](#compilerbuildsparktypeslongconvertmwvalueforpython)
        * [compiler.build.spark.types.Long.getEncoderInstantiation](#compilerbuildsparktypeslonggetencoderinstantiation)
        * [compiler.build.spark.types.Long.getEncoderType](#compilerbuildsparktypeslonggetencodertype)
        * [compiler.build.spark.types.Long.pythonSchemaType](#compilerbuildsparktypeslongpythonschematype)
      * [compiler.build.spark.types.Short](#compilerbuildsparktypesshort)
        * [compiler.build.spark.types.Short.Short](#compilerbuildsparktypesshortshort)
        * [compiler.build.spark.types.Short.convertIntermediateToMATLAB](#compilerbuildsparktypesshortconvertintermediatetomatlab)
        * [compiler.build.spark.types.Short.convertMWToRetValue](#compilerbuildsparktypesshortconvertmwtoretvalue)
        * [compiler.build.spark.types.Short.convertMWValueForPython](#compilerbuildsparktypesshortconvertmwvalueforpython)
        * [compiler.build.spark.types.Short.getEncoderInstantiation](#compilerbuildsparktypesshortgetencoderinstantiation)
        * [compiler.build.spark.types.Short.getEncoderType](#compilerbuildsparktypesshortgetencodertype)
        * [compiler.build.spark.types.Short.getMATLABHelperInputConversion](#compilerbuildsparktypesshortgetmatlabhelperinputconversion)
      * [compiler.build.spark.types.String](#compilerbuildsparktypesstring)
        * [compiler.build.spark.types.String.String](#compilerbuildsparktypesstringstring)
        * [compiler.build.spark.types.String.castLongColumnToValue](#compilerbuildsparktypesstringcastlongcolumntovalue)
        * [compiler.build.spark.types.String.convertExternalToIntermediate](#compilerbuildsparktypesstringconvertexternaltointermediate)
        * [compiler.build.spark.types.String.convertIntermediateColumnForRuntime](#compilerbuildsparktypesstringconvertintermediatecolumnforruntime)
        * [compiler.build.spark.types.String.convertIntermediateMWColumnToExternal](#compilerbuildsparktypesstringconvertintermediatemwcolumntoexternal)
        * [compiler.build.spark.types.String.convertIntermediateToMATLAB](#compilerbuildsparktypesstringconvertintermediatetomatlab)
        * [compiler.build.spark.types.String.convertMATLABToIntermediate](#compilerbuildsparktypesstringconvertmatlabtointermediate)
        * [compiler.build.spark.types.String.convertMWToRetValue](#compilerbuildsparktypesstringconvertmwtoretvalue)
        * [compiler.build.spark.types.String.convertMWValueForPython](#compilerbuildsparktypesstringconvertmwvalueforpython)
        * [compiler.build.spark.types.String.convertPythonValueForMW](#compilerbuildsparktypesstringconvertpythonvalueformw)
        * [compiler.build.spark.types.String.createMWValueToJavaStatement](#compilerbuildsparktypesstringcreatemwvaluetojavastatement)
        * [compiler.build.spark.types.String.genInterColToPySeries](#compilerbuildsparktypesstringgenintercoltopyseries)
        * [compiler.build.spark.types.String.getColumnElemType](#compilerbuildsparktypesstringgetcolumnelemtype)
        * [compiler.build.spark.types.String.getEncoderInstantiation](#compilerbuildsparktypesstringgetencoderinstantiation)
        * [compiler.build.spark.types.String.getEncoderType](#compilerbuildsparktypesstringgetencodertype)
        * [compiler.build.spark.types.String.getMATLABHelperInputConversion](#compilerbuildsparktypesstringgetmatlabhelperinputconversion)
        * [compiler.build.spark.types.String.getMATLABHelperOutputConversion](#compilerbuildsparktypesstringgetmatlabhelperoutputconversion)
        * [compiler.build.spark.types.String.getMWResultType](#compilerbuildsparktypesstringgetmwresulttype)
        * [compiler.build.spark.types.String.instantiatePythonExampleValue](#compilerbuildsparktypesstringinstantiatepythonexamplevalue)
      * [compiler.build.spark.types.Table](#compilerbuildsparktypestable)
        * [compiler.build.spark.types.Table.Table](#compilerbuildsparktypestabletable)
        * [compiler.build.spark.types.Table.convertMWToRetValue](#compilerbuildsparktypestableconvertmwtoretvalue)
        * [compiler.build.spark.types.Table.getEncoderInstantiation](#compilerbuildsparktypestablegetencoderinstantiation)
        * [compiler.build.spark.types.Table.getEncoderType](#compilerbuildsparktypestablegetencodertype)
        * [compiler.build.spark.types.Table.initTable](#compilerbuildsparktypestableinittable)
      * [compiler.build.spark.types.Timestamp](#compilerbuildsparktypestimestamp)
        * [compiler.build.spark.types.Timestamp.Timestamp](#compilerbuildsparktypestimestamptimestamp)
        * [compiler.build.spark.types.Timestamp.castLongColumnToValue](#compilerbuildsparktypestimestampcastlongcolumntovalue)
        * [compiler.build.spark.types.Timestamp.convertExternalToIntermediate](#compilerbuildsparktypestimestampconvertexternaltointermediate)
        * [compiler.build.spark.types.Timestamp.convertIntermediateColumnForRuntime](#compilerbuildsparktypestimestampconvertintermediatecolumnforruntime)
        * [compiler.build.spark.types.Timestamp.convertIntermediateMWColumnToExternal](#compilerbuildsparktypestimestampconvertintermediatemwcolumntoexternal)
        * [compiler.build.spark.types.Timestamp.convertIntermediateToMATLAB](#compilerbuildsparktypestimestampconvertintermediatetomatlab)
        * [compiler.build.spark.types.Timestamp.convertIntermediatelColumnToMATLAB](#compilerbuildsparktypestimestampconvertintermediatelcolumntomatlab)
        * [compiler.build.spark.types.Timestamp.convertMATLABToIntermediate](#compilerbuildsparktypestimestampconvertmatlabtointermediate)
        * [compiler.build.spark.types.Timestamp.convertMWToRetValue](#compilerbuildsparktypestimestampconvertmwtoretvalue)
        * [compiler.build.spark.types.Timestamp.convertMWValueForPython](#compilerbuildsparktypestimestampconvertmwvalueforpython)
        * [compiler.build.spark.types.Timestamp.convertPandaColumnFromIntermediate](#compilerbuildsparktypestimestampconvertpandacolumnfromintermediate)
        * [compiler.build.spark.types.Timestamp.convertPandaColumnToIntermediate](#compilerbuildsparktypestimestampconvertpandacolumntointermediate)
        * [compiler.build.spark.types.Timestamp.convertPythonValueForMW](#compilerbuildsparktypestimestampconvertpythonvalueformw)
        * [compiler.build.spark.types.Timestamp.genInterColToPySeries](#compilerbuildsparktypestimestampgenintercoltopyseries)
        * [compiler.build.spark.types.Timestamp.getColumnElemType](#compilerbuildsparktypestimestampgetcolumnelemtype)
        * [compiler.build.spark.types.Timestamp.getEncoderInstantiation](#compilerbuildsparktypestimestampgetencoderinstantiation)
        * [compiler.build.spark.types.Timestamp.getEncoderType](#compilerbuildsparktypestimestampgetencodertype)
        * [compiler.build.spark.types.Timestamp.getMATLABHelperInputConversion](#compilerbuildsparktypestimestampgetmatlabhelperinputconversion)
        * [compiler.build.spark.types.Timestamp.getMATLABHelperOutputConversion](#compilerbuildsparktypestimestampgetmatlabhelperoutputconversion)
        * [compiler.build.spark.types.Timestamp.instantiatePythonExampleValue](#compilerbuildsparktypestimestampinstantiatepythonexamplevalue)
        * [compiler.build.spark.types.Timestamp.instantiateScalaExampleValue](#compilerbuildsparktypestimestampinstantiatescalaexamplevalue)
        * [compiler.build.spark.types.Timestamp.pythonSchemaType](#compilerbuildsparktypestimestamppythonschematype)
      * [compiler.build.spark.types.generateFunctionSignature](#compilerbuildsparktypesgeneratefunctionsignature)
      * [compiler.build.spark.types.getFileArgumentInfo](#compilerbuildsparktypesgetfileargumentinfo)
      * [compiler.build.spark.types.getTypeEncoding](#compilerbuildsparktypesgettypeencoding)
    * [compiler.build.spark.CallContext](#compilerbuildsparkcallcontext)
      * [compiler.build.spark.CallContext.CallContext](#compilerbuildsparkcallcontextcallcontext)
    * [compiler.build.spark.File](#compilerbuildsparkfile)
      * [compiler.build.spark.File.File](#compilerbuildsparkfilefile)
      * [compiler.build.spark.File.addMethodType](#compilerbuildsparkfileaddmethodtype)
      * [compiler.build.spark.File.createArgument](#compilerbuildsparkfilecreateargument)
      * [compiler.build.spark.File.determineMethodTypes](#compilerbuildsparkfiledeterminemethodtypes)
      * [compiler.build.spark.File.fillEmptyNames](#compilerbuildsparkfilefillemptynames)
      * [compiler.build.spark.File.genMATLABHelperOutputConversions](#compilerbuildsparkfilegenmatlabhelperoutputconversions)
      * [compiler.build.spark.File.generateArgNames](#compilerbuildsparkfilegenerateargnames)
      * [compiler.build.spark.File.generateNameList](#compilerbuildsparkfilegeneratenamelist)
      * [compiler.build.spark.File.generatePythonInputArgs](#compilerbuildsparkfilegeneratepythoninputargs)
      * [compiler.build.spark.File.generatePythonRowInputArgs](#compilerbuildsparkfilegeneratepythonrowinputargs)
      * [compiler.build.spark.File.generatePythonRowIteratorArgs](#compilerbuildsparkfilegeneratepythonrowiteratorargs)
      * [compiler.build.spark.File.getArgArray](#compilerbuildsparkfilegetargarray)
      * [compiler.build.spark.File.getBuildType](#compilerbuildsparkfilegetbuildtype)
      * [compiler.build.spark.File.getEncoderCreator](#compilerbuildsparkfilegetencodercreator)
      * [compiler.build.spark.File.getEncoderStruct](#compilerbuildsparkfilegetencoderstruct)
      * [compiler.build.spark.File.getHelperFcnName](#compilerbuildsparkfilegethelperfcnname)
      * [compiler.build.spark.File.getInputElements](#compilerbuildsparkfilegetinputelements)
      * [compiler.build.spark.File.getOutSparkType](#compilerbuildsparkfilegetoutsparktype)
      * [compiler.build.spark.File.getOutputElements](#compilerbuildsparkfilegetoutputelements)
      * [compiler.build.spark.File.getReturnType](#compilerbuildsparkfilegetreturntype)
      * [compiler.build.spark.File.getUDFInfo](#compilerbuildsparkfilegetudfinfo)
      * [compiler.build.spark.File.getWrapperFcnName](#compilerbuildsparkfilegetwrapperfcnname)
      * [compiler.build.spark.File.hasInputArrays](#compilerbuildsparkfilehasinputarrays)
      * [compiler.build.spark.File.init](#compilerbuildsparkfileinit)
      * [compiler.build.spark.File.initWithCellArgs](#compilerbuildsparkfileinitwithcellargs)
      * [compiler.build.spark.File.needsOutputConversion](#compilerbuildsparkfileneedsoutputconversion)
      * [compiler.build.spark.File.setTableProperties](#compilerbuildsparkfilesettableproperties)
      * [compiler.build.spark.File.ticTocHelper](#compilerbuildsparkfiletictochelper)
      * [compiler.build.spark.File.useDebug](#compilerbuildsparkfileusedebug)
      * [compiler.build.spark.File.writeMethodComment](#compilerbuildsparkfilewritemethodcomment)
    * [compiler.build.spark.MethodType](#compilerbuildsparkmethodtype)
      * [compiler.build.spark.MethodType.MethodType](#compilerbuildsparkmethodtypemethodtype)
    * [compiler.build.spark.PythonFile](#compilerbuildsparkpythonfile)
      * [compiler.build.spark.PythonFile.PythonFile](#compilerbuildsparkpythonfilepythonfile)
      * [compiler.build.spark.PythonFile.applyInPandas_PythonMATLABHelper](#compilerbuildsparkpythonfileapplyinpandas_pythonmatlabhelper)
      * [compiler.build.spark.PythonFile.applyInPandas_PythonWrapper](#compilerbuildsparkpythonfileapplyinpandas_pythonwrapper)
      * [compiler.build.spark.PythonFile.colsIterator_PythonWrapper](#compilerbuildsparkpythonfilecolsiterator_pythonwrapper)
      * [compiler.build.spark.PythonFile.columnsToPandas_PythonWrapper](#compilerbuildsparkpythonfilecolumnstopandas_pythonwrapper)
      * [compiler.build.spark.PythonFile.convertExternalToIntermediate](#compilerbuildsparkpythonfileconvertexternaltointermediate)
      * [compiler.build.spark.PythonFile.genMATLABHelperInputConversions](#compilerbuildsparkpythonfilegenmatlabhelperinputconversions)
      * [compiler.build.spark.PythonFile.generateExamples](#compilerbuildsparkpythonfilegenerateexamples)
      * [compiler.build.spark.PythonFile.generateMATLABUDFHelper](#compilerbuildsparkpythonfilegeneratematlabudfhelper)
      * [compiler.build.spark.PythonFile.generatePythonPandasSchema](#compilerbuildsparkpythonfilegeneratepythonpandasschema)
      * [compiler.build.spark.PythonFile.generatePythonTableHelperArgs](#compilerbuildsparkpythonfilegeneratepythontablehelperargs)
      * [compiler.build.spark.PythonFile.generatePythonTableRestArgs](#compilerbuildsparkpythonfilegeneratepythontablerestargs)
      * [compiler.build.spark.PythonFile.getImports](#compilerbuildsparkpythonfilegetimports)
      * [compiler.build.spark.PythonFile.getInputNameArray](#compilerbuildsparkpythonfilegetinputnamearray)
      * [compiler.build.spark.PythonFile.getOutputNameArray](#compilerbuildsparkpythonfilegetoutputnamearray)
      * [compiler.build.spark.PythonFile.hasOutputArrays](#compilerbuildsparkpythonfilehasoutputarrays)
      * [compiler.build.spark.PythonFile.initFromSchema](#compilerbuildsparkpythonfileinitfromschema)
      * [compiler.build.spark.PythonFile.inputsTransformer_PythonWrapper](#compilerbuildsparkpythonfileinputstransformer_pythonwrapper)
      * [compiler.build.spark.PythonFile.isJavaBuild](#compilerbuildsparkpythonfileisjavabuild)
      * [compiler.build.spark.PythonFile.isPythonBuild](#compilerbuildsparkpythonfileispythonbuild)
      * [compiler.build.spark.PythonFile.mapInPandas_PythonWrapper](#compilerbuildsparkpythonfilemapinpandas_pythonwrapper)
      * [compiler.build.spark.PythonFile.mapPartitionsTable_PythonMATLABHelper](#compilerbuildsparkpythonfilemappartitionstable_pythonmatlabhelper)
      * [compiler.build.spark.PythonFile.mapPartitionsTable_PythonWrapper](#compilerbuildsparkpythonfilemappartitionstable_pythonwrapper)
      * [compiler.build.spark.PythonFile.mapPartitions_PythonMATLABHelper](#compilerbuildsparkpythonfilemappartitions_pythonmatlabhelper)
      * [compiler.build.spark.PythonFile.mapPartitions_PythonWrapper](#compilerbuildsparkpythonfilemappartitions_pythonwrapper)
      * [compiler.build.spark.PythonFile.map_PythonWrapper](#compilerbuildsparkpythonfilemap_pythonwrapper)
      * [compiler.build.spark.PythonFile.needsInputTransformer](#compilerbuildsparkpythonfileneedsinputtransformer)
      * [compiler.build.spark.PythonFile.needsOutputTransformer](#compilerbuildsparkpythonfileneedsoutputtransformer)
      * [compiler.build.spark.PythonFile.outputConversion_PythonWrapper](#compilerbuildsparkpythonfileoutputconversion_pythonwrapper)
      * [compiler.build.spark.PythonFile.outputNames_PythonWrapper](#compilerbuildsparkpythonfileoutputnames_pythonwrapper)
      * [compiler.build.spark.PythonFile.outputsTransformer_PythonWrapper](#compilerbuildsparkpythonfileoutputstransformer_pythonwrapper)
      * [compiler.build.spark.PythonFile.pandasSeries_PythonMATLABHelper](#compilerbuildsparkpythonfilepandasseries_pythonmatlabhelper)
      * [compiler.build.spark.PythonFile.pandasSeries_PythonWrapper](#compilerbuildsparkpythonfilepandasseries_pythonwrapper)
      * [compiler.build.spark.PythonFile.pandasToColumns_PythonWrapper](#compilerbuildsparkpythonfilepandastocolumns_pythonwrapper)
      * [compiler.build.spark.PythonFile.plain_PythonMATLABHelper](#compilerbuildsparkpythonfileplain_pythonmatlabhelper)
      * [compiler.build.spark.PythonFile.plain_PythonWrapper](#compilerbuildsparkpythonfileplain_pythonwrapper)
      * [compiler.build.spark.PythonFile.rowIterator_PythonWrapper](#compilerbuildsparkpythonfilerowiterator_pythonwrapper)
    * [compiler.build.spark.PythonFileV2](#compilerbuildsparkpythonfilev2)
      * [compiler.build.spark.PythonFileV2.PythonFileV2](#compilerbuildsparkpythonfilev2pythonfilev2)
      * [compiler.build.spark.PythonFileV2.applyInPandas_PythonMATLABHelper](#compilerbuildsparkpythonfilev2applyinpandas_pythonmatlabhelper)
      * [compiler.build.spark.PythonFileV2.applyInPandas_PythonWrapper](#compilerbuildsparkpythonfilev2applyinpandas_pythonwrapper)
      * [compiler.build.spark.PythonFileV2.chooseGroupbyColumn](#compilerbuildsparkpythonfilev2choosegroupbycolumn)
      * [compiler.build.spark.PythonFileV2.colsIterator_PythonWrapper](#compilerbuildsparkpythonfilev2colsiterator_pythonwrapper)
      * [compiler.build.spark.PythonFileV2.colsToRows_PythonWrapper](#compilerbuildsparkpythonfilev2colstorows_pythonwrapper)
      * [compiler.build.spark.PythonFileV2.columnsToPandas_PythonWrapper](#compilerbuildsparkpythonfilev2columnstopandas_pythonwrapper)
      * [compiler.build.spark.PythonFileV2.determineMethodTypes](#compilerbuildsparkpythonfilev2determinemethodtypes)
      * [compiler.build.spark.PythonFileV2.genExampleInputs](#compilerbuildsparkpythonfilev2genexampleinputs)
      * [compiler.build.spark.PythonFileV2.generateArtifactsExample](#compilerbuildsparkpythonfilev2generateartifactsexample)
      * [compiler.build.spark.PythonFileV2.generateExamples](#compilerbuildsparkpythonfilev2generateexamples)
      * [compiler.build.spark.PythonFileV2.generateMATLABUDFHelper](#compilerbuildsparkpythonfilev2generatematlabudfhelper)
      * [compiler.build.spark.PythonFileV2.generatePythonInputArgs](#compilerbuildsparkpythonfilev2generatepythoninputargs)
      * [compiler.build.spark.PythonFileV2.generatePythonNotebookTask](#compilerbuildsparkpythonfilev2generatepythonnotebooktask)
      * [compiler.build.spark.PythonFileV2.generatePythonPandasSchema](#compilerbuildsparkpythonfilev2generatepythonpandasschema)
      * [compiler.build.spark.PythonFileV2.generatePythonTableHelperArgs](#compilerbuildsparkpythonfilev2generatepythontablehelperargs)
      * [compiler.build.spark.PythonFileV2.generatePythonTableRestArgs](#compilerbuildsparkpythonfilev2generatepythontablerestargs)
      * [compiler.build.spark.PythonFileV2.getImports](#compilerbuildsparkpythonfilev2getimports)
      * [compiler.build.spark.PythonFileV2.getInputElements](#compilerbuildsparkpythonfilev2getinputelements)
      * [compiler.build.spark.PythonFileV2.getInputNames](#compilerbuildsparkpythonfilev2getinputnames)
      * [compiler.build.spark.PythonFileV2.getOutputElements](#compilerbuildsparkpythonfilev2getoutputelements)
      * [compiler.build.spark.PythonFileV2.getOutputNames](#compilerbuildsparkpythonfilev2getoutputnames)
      * [compiler.build.spark.PythonFileV2.hasOutputArrays](#compilerbuildsparkpythonfilev2hasoutputarrays)
      * [compiler.build.spark.PythonFileV2.init](#compilerbuildsparkpythonfilev2init)
      * [compiler.build.spark.PythonFileV2.inputNames_PythonWrapper](#compilerbuildsparkpythonfilev2inputnames_pythonwrapper)
      * [compiler.build.spark.PythonFileV2.ioSchemasAlign](#compilerbuildsparkpythonfilev2ioschemasalign)
      * [compiler.build.spark.PythonFileV2.mapInPandas_PythonWrapper](#compilerbuildsparkpythonfilev2mapinpandas_pythonwrapper)
      * [compiler.build.spark.PythonFileV2.mapPartitions_PythonMATLABHelper](#compilerbuildsparkpythonfilev2mappartitions_pythonmatlabhelper)
      * [compiler.build.spark.PythonFileV2.mapPartitions_PythonWrapper](#compilerbuildsparkpythonfilev2mappartitions_pythonwrapper)
      * [compiler.build.spark.PythonFileV2.map_PythonWrapper](#compilerbuildsparkpythonfilev2map_pythonwrapper)
      * [compiler.build.spark.PythonFileV2.outputNames_PythonWrapper](#compilerbuildsparkpythonfilev2outputnames_pythonwrapper)
      * [compiler.build.spark.PythonFileV2.pandasSeries_PythonMATLABHelper](#compilerbuildsparkpythonfilev2pandasseries_pythonmatlabhelper)
      * [compiler.build.spark.PythonFileV2.pandasSeries_PythonWrapper](#compilerbuildsparkpythonfilev2pandasseries_pythonwrapper)
      * [compiler.build.spark.PythonFileV2.pandasToColumns_PythonWrapper](#compilerbuildsparkpythonfilev2pandastocolumns_pythonwrapper)
      * [compiler.build.spark.PythonFileV2.plain_PythonMATLABHelper](#compilerbuildsparkpythonfilev2plain_pythonmatlabhelper)
      * [compiler.build.spark.PythonFileV2.plain_PythonWrapper](#compilerbuildsparkpythonfilev2plain_pythonwrapper)
    * [compiler.build.spark.PythonSparkBuilder](#compilerbuildsparkpythonsparkbuilder)
      * [compiler.build.spark.PythonSparkBuilder.PythonSparkBuilder](#compilerbuildsparkpythonsparkbuilderpythonsparkbuilder)
      * [compiler.build.spark.PythonSparkBuilder.addArtifact](#compilerbuildsparkpythonsparkbuilderaddartifact)
      * [compiler.build.spark.PythonSparkBuilder.addFile](#compilerbuildsparkpythonsparkbuilderaddfile)
      * [compiler.build.spark.PythonSparkBuilder.addHelperFilesToBuild](#compilerbuildsparkpythonsparkbuilderaddhelperfilestobuild)
      * [compiler.build.spark.PythonSparkBuilder.build](#compilerbuildsparkpythonsparkbuilderbuild)
      * [compiler.build.spark.PythonSparkBuilder.clean](#compilerbuildsparkpythonsparkbuilderclean)
      * [compiler.build.spark.PythonSparkBuilder.clearMATLABWriter](#compilerbuildsparkpythonsparkbuilderclearmatlabwriter)
      * [compiler.build.spark.PythonSparkBuilder.clearPythonWriter](#compilerbuildsparkpythonsparkbuilderclearpythonwriter)
      * [compiler.build.spark.PythonSparkBuilder.clearStringWriter](#compilerbuildsparkpythonsparkbuilderclearstringwriter)
      * [compiler.build.spark.PythonSparkBuilder.createWheel](#compilerbuildsparkpythonsparkbuildercreatewheel)
      * [compiler.build.spark.PythonSparkBuilder.createZipArtifact](#compilerbuildsparkpythonsparkbuildercreatezipartifact)
      * [compiler.build.spark.PythonSparkBuilder.determineMethodTypes](#compilerbuildsparkpythonsparkbuilderdeterminemethodtypes)
      * [compiler.build.spark.PythonSparkBuilder.genPartitionHelpers](#compilerbuildsparkpythonsparkbuildergenpartitionhelpers)
      * [compiler.build.spark.PythonSparkBuilder.genPythonSetup](#compilerbuildsparkpythonsparkbuildergenpythonsetup)
      * [compiler.build.spark.PythonSparkBuilder.generateExamples](#compilerbuildsparkpythonsparkbuildergenerateexamples)
      * [compiler.build.spark.PythonSparkBuilder.generateMATLABUDFHelpers](#compilerbuildsparkpythonsparkbuildergeneratematlabudfhelpers)
      * [compiler.build.spark.PythonSparkBuilder.generatePythonExample](#compilerbuildsparkpythonsparkbuildergeneratepythonexample)
      * [compiler.build.spark.PythonSparkBuilder.generateSparkShellHelper](#compilerbuildsparkpythonsparkbuildergeneratesparkshellhelper)
      * [compiler.build.spark.PythonSparkBuilder.generateWrapper](#compilerbuildsparkpythonsparkbuildergeneratewrapper)
      * [compiler.build.spark.PythonSparkBuilder.getAPIs](#compilerbuildsparkpythonsparkbuildergetapis)
      * [compiler.build.spark.PythonSparkBuilder.getFileArguments](#compilerbuildsparkpythonsparkbuildergetfilearguments)
      * [compiler.build.spark.PythonSparkBuilder.getImports](#compilerbuildsparkpythonsparkbuildergetimports)
      * [compiler.build.spark.PythonSparkBuilder.getWheelFile](#compilerbuildsparkpythonsparkbuildergetwheelfile)
      * [compiler.build.spark.PythonSparkBuilder.init](#compilerbuildsparkpythonsparkbuilderinit)
      * [compiler.build.spark.PythonSparkBuilder.installWheelOnDatabricksCluster](#compilerbuildsparkpythonsparkbuilderinstallwheelondatabrickscluster)
      * [compiler.build.spark.PythonSparkBuilder.setCallCtx](#compilerbuildsparkpythonsparkbuildersetcallctx)
      * [compiler.build.spark.PythonSparkBuilder.setMATLABWriter](#compilerbuildsparkpythonsparkbuildersetmatlabwriter)
      * [compiler.build.spark.PythonSparkBuilder.setPythonWriter](#compilerbuildsparkpythonsparkbuildersetpythonwriter)
      * [compiler.build.spark.PythonSparkBuilder.setScopedCallContext](#compilerbuildsparkpythonsparkbuildersetscopedcallcontext)
      * [compiler.build.spark.PythonSparkBuilder.setStringWriter](#compilerbuildsparkpythonsparkbuildersetstringwriter)
      * [compiler.build.spark.PythonSparkBuilder.uploadExampleNotebooks](#compilerbuildsparkpythonsparkbuilderuploadexamplenotebooks)
      * [compiler.build.spark.PythonSparkBuilder.uploadWheelFile](#compilerbuildsparkpythonsparkbuilderuploadwheelfile)
      * [compiler.build.spark.PythonSparkBuilder.useMetrics](#compilerbuildsparkpythonsparkbuilderusemetrics)
    * [compiler.build.spark.TicTocHelper](#compilerbuildsparktictochelper)
      * [compiler.build.spark.TicTocHelper.TicTocHelper](#compilerbuildsparktictochelpertictochelper)
      * [compiler.build.spark.TicTocHelper.delete](#compilerbuildsparktictochelperdelete)
      * [compiler.build.spark.TicTocHelper.endMeasurement](#compilerbuildsparktictochelperendmeasurement)
      * [compiler.build.spark.TicTocHelper.initMeasurement](#compilerbuildsparktictochelperinitmeasurement)
    * [compiler.build.spark.pythonPackage](#compilerbuildsparkpythonpackage)

## Help

### compiler.build.spark

### compiler.build.spark.converters

### compiler.build.spark.converters.ArraySeriesConverter

Superclass: compiler.build.spark.converters.SeriesConverter

```text
ARRAYSERIESCONVERTERS  Constructs a MATLAB cell array from a MATLAB struct
  representing a a variable-length Pandas Series (i.e. each element is a
  list).
```

#### compiler.build.spark.converters.ArraySeriesConverter.ArraySeriesConverter

```text
ARRAYSERIESCONVERTERS  Constructs a MATLAB cell array from a MATLAB struct
  representing a a variable-length Pandas Series (i.e. each element is a
  list).

    Documentation for compiler.build.spark.converters.ArraySeriesConverter
```

#### compiler.build.spark.converters.ArraySeriesConverter.convert

```text
compiler.build.spark.converters.ArraySeriesConverter/convert is a function.
    output = convert(obj, data)
```

### compiler.build.spark.converters.BinarySeriesConverter

Superclass: compiler.build.spark.converters.SeriesConverter

```text
BINARYSERIESCONVERTER  Constructs a cell array containing uint8 row
  vectors from a MATLAB struct array representing a pandas series of
  variable-length byt4e arrays.
```

#### compiler.build.spark.converters.BinarySeriesConverter.BinarySeriesConverter

```text
BINARYSERIESCONVERTER  Constructs a cell array containing uint8 row
  vectors from a MATLAB struct array representing a pandas series of
  variable-length byt4e arrays.

    Documentation for compiler.build.spark.converters.BinarySeriesConverter
```

#### compiler.build.spark.converters.BinarySeriesConverter.convert

```text
data is a scalar struct with two fields: Lengths and Bytes.
 
  The Lengths field is a int64 array. Each int64 value specifies
  the length of the corresponding uint8 array in the output
  cell array.
  
  The Bytes field is a uint8 array.
```

### compiler.build.spark.converters.DateSeriesConverter

Superclass: compiler.build.spark.converters.SeriesConverter

```text
DATESERIESCONVERTER Constructs a MATLAB dateteime array from a MATLAB
  int64 array representing a Pandas Series of datetime.date values.
```

#### compiler.build.spark.converters.DateSeriesConverter.DateSeriesConverter

```text
DATESERIESCONVERTER Constructs a MATLAB dateteime array from a MATLAB
  int64 array representing a Pandas Series of datetime.date values.

    Documentation for compiler.build.spark.converters.DateSeriesConverter
```

#### compiler.build.spark.converters.DateSeriesConverter.convert

```text
data is a int64 array in which each element is a
  proleptic Gregorian ordinal (i.e. number of days from 
  Jan-01-0001, inclusive).
```

### compiler.build.spark.converters.MapSeriesConverter

Superclass: compiler.build.spark.converters.SeriesConverter

```text
MAPSERIESCONVERTER Constructs a Nx1 MATLAB struct array from a MATLAB cell 
  array representing a Pandas Series of objects, in which the objects are
  dictionaries. The dictionary keys are type-consistent, and the
  dictionary values are type-consistent as well.
```

#### compiler.build.spark.converters.MapSeriesConverter.MapSeriesConverter

```text
MAPSERIESCONVERTER Constructs a Nx1 MATLAB struct array from a MATLAB cell 
  array representing a Pandas Series of objects, in which the objects are
  dictionaries. The dictionary keys are type-consistent, and the
  dictionary values are type-consistent as well.

    Documentation for compiler.build.spark.converters.MapSeriesConverter
```

#### compiler.build.spark.converters.MapSeriesConverter.convert

```text
compiler.build.spark.converters.MapSeriesConverter/convert is a function.
    output = convert(obj, data)
```

### compiler.build.spark.converters.PrimitiveSeriesConverter

Superclass: compiler.build.spark.converters.SeriesConverter

```text
PRIMITIVESERIESCONVERTER   Converter for constructing primitive MATLAB
  arrays that require zero data-manipulation.
```

#### compiler.build.spark.converters.PrimitiveSeriesConverter.PrimitiveSeriesConverter

```text
PRIMITIVESERIESCONVERTER   Converter for constructing primitive MATLAB
  arrays that require zero data-manipulation.

    Documentation for compiler.build.spark.converters.PrimitiveSeriesConverter
```

#### compiler.build.spark.converters.PrimitiveSeriesConverter.convert

```text
compiler.build.spark.converters.PrimitiveSeriesConverter/convert is a function.
    output = convert(~, data)
```

### compiler.build.spark.converters.SeriesConverter

Superclass: matlab.mixin.Heterogeneous

```text
SERIESCONVERTER Defines the interface for converting Pandas Series
  into MATLAB arrays.
```

#### compiler.build.spark.converters.SeriesConverter.SeriesConverter

```text
SERIESCONVERTER Defines the interface for converting Pandas Series
  into MATLAB arrays.

    Documentation for compiler.build.spark.converters.SeriesConverter
```

#### compiler.build.spark.converters.SeriesConverter.convert

```text
compiler.build.spark.converters.SeriesConverter/convert is a function.
    obj = compiler.build.spark.converters.SeriesConverter
```

### compiler.build.spark.converters.StringSeriesConverter

Superclass: compiler.build.spark.converters.SeriesConverter

```text
STRINGSERIESCONVERTER Constructs a MATLAB string array from a MATLAB
  cellstr array representing a Pandas Series of string values.
```

#### compiler.build.spark.converters.StringSeriesConverter.StringSeriesConverter

```text
STRINGSERIESCONVERTER Constructs a MATLAB string array from a MATLAB
  cellstr array representing a Pandas Series of string values.

    Documentation for compiler.build.spark.converters.StringSeriesConverter
```

#### compiler.build.spark.converters.StringSeriesConverter.convert

```text
compiler.build.spark.converters.StringSeriesConverter/convert is a function.
    output = convert(~, data)
```

### compiler.build.spark.converters.StructField

```text
STRUCTFIELD A Named-tuple consisting of a name and a 
  compiler.build.spark.converters.SeriesConverter.
```

#### compiler.build.spark.converters.StructField.StructField

```text
STRUCTFIELD A Named-tuple consisting of a name and a 
  compiler.build.spark.converters.SeriesConverter.

    Documentation for compiler.build.spark.converters.StructField
```

### compiler.build.spark.converters.StructSeriesConverter

Superclass: compiler.build.spark.converters.SeriesConverter

```text
STRUCTSERIES   Constructs a Nx1 MATLAB struct array from a MATLAB cell 
  array representing a Pandas Series of objects, in which the objects are
  dictionaries with identical key names. In addition, key values have
  identical datatypes across rows.
```

#### compiler.build.spark.converters.StructSeriesConverter.StructSeriesConverter

```text
STRUCTSERIES   Constructs a Nx1 MATLAB struct array from a MATLAB cell 
  array representing a Pandas Series of objects, in which the objects are
  dictionaries with identical key names. In addition, key values have
  identical datatypes across rows.

    Documentation for compiler.build.spark.converters.StructSeriesConverter
```

#### compiler.build.spark.converters.StructSeriesConverter.convert

```text
compiler.build.spark.converters.StructSeriesConverter/convert is a function.
    output = convert(obj, data)
```

### compiler.build.spark.converters.TimeUnit

```text
TIMEUNIT Enumeration class representing time units.
```

```text
Enumeration values:
  Seconds
  Milliseconds
  Microseconds
  Nanoseconds

```

#### compiler.build.spark.converters.TimeUnit.TimeUnit

```text
TIMEUNIT Enumeration class representing time units.

    Documentation for compiler.build.spark.converters.TimeUnit
```

#### compiler.build.spark.converters.TimeUnit.ticksPerSecond

```text
compiler.build.spark.converters.TimeUnit/ticksPerSecond is a function.
    ticks = ticksPerSecond(obj)
```

### compiler.build.spark.converters.TimedeltaSeriesConverter

Superclass: compiler.build.spark.converters.SeriesConverter

```text
TIMESTAMPSERIESCONVERTER   Constructs a MATLAB duration array from a
  MATLAB int64 array representing a Pandas Series of timedelta64 values.
```

#### compiler.build.spark.converters.TimedeltaSeriesConverter.TimedeltaSeriesConverter

```text
TIMESTAMPSERIESCONVERTER   Constructs a MATLAB duration array from a
  MATLAB int64 array representing a Pandas Series of timedelta64 values.

    Documentation for compiler.build.spark.converters.TimedeltaSeriesConverter
```

#### compiler.build.spark.converters.TimedeltaSeriesConverter.convert

```text
compiler.build.spark.converters.TimedeltaSeriesConverter/convert is a function.
    output = convert(obj, data)
```

### compiler.build.spark.converters.TimestampSeriesConverter

Superclass: compiler.build.spark.converters.SeriesConverter

```text
TIMESTAMPSERIESCONVERTER   Constructs a MATLAB datetime array from a
  MATLAB int64 array representing a Pandas Series of datetime64 values.
```

#### compiler.build.spark.converters.TimestampSeriesConverter.TimestampSeriesConverter

```text
TIMESTAMPSERIESCONVERTER   Constructs a MATLAB datetime array from a
  MATLAB int64 array representing a Pandas Series of datetime64 values.

    Documentation for compiler.build.spark.converters.TimestampSeriesConverter
```

#### compiler.build.spark.converters.TimestampSeriesConverter.convert

```text
compiler.build.spark.converters.TimestampSeriesConverter/convert is a function.
    output = convert(obj, data)
```

### compiler.build.spark.data

### compiler.build.spark.data.AnsiIntervalType

Superclass: compiler.build.spark.data.AtomicType

```text
AnsiIntervalType Implementation for types in Compiler workflow
```

#### compiler.build.spark.data.AnsiIntervalType.AnsiIntervalType

```text
AnsiIntervalType Implementation for types in Compiler workflow

    Documentation for compiler.build.spark.data.AnsiIntervalType
```

#### compiler.build.spark.data.AnsiIntervalType.array_IMML_to_IMPY

```text
array_IMML_to_IMPY Ensure the results are an array
 
  A table with 1 row will be returned as scalars from MATLAB
  Runtime.
 
  Returns the name of a function. If the function name is
  empty, no conversion is necessary.
```

### compiler.build.spark.data.ArrayType

Superclass: compiler.build.spark.data.DataType

```text
ArrayType Implementation for types in Compiler workflow
```

#### compiler.build.spark.data.ArrayType.ArrayType

```text
ArrayType Implementation for types in Compiler workflow

    Documentation for compiler.build.spark.data.ArrayType
```

#### compiler.build.spark.data.ArrayType.PandasSeriesType

```text
PandasSeriesType The series type to be used in Pandas
```

#### compiler.build.spark.data.ArrayType.UniqueTypeName

```text
UniqueTypeName - A unique name for conversion functions
  This name will simply be the MATLABType for simple types,
  and some convoluted name for complex types.
```

#### compiler.build.spark.data.ArrayType.addIteratorRow

```text
compiler.build.spark.data.ArrayType/addIteratorRow is a function.
    codeLines = addIteratorRow(obj, rowSrc)
```

#### compiler.build.spark.data.ArrayType.colIntermediateMATLABToPython

```text
compiler.build.spark.data.ArrayType/colIntermediateMATLABToPython is a function.
    funcName = colIntermediateMATLABToPython(obj)
```

#### compiler.build.spark.data.ArrayType.col_IMML_to_IMPY

```text
col_IMML_to_IMPY Convert a column to python
  Converts from intermediate MATLAB (e.g. matlab.int64([]) to
  intermediate python, e.g. [1,2,3]
```

#### compiler.build.spark.data.ArrayType.col_IMML_to_ML

```text
col_IMML_to_ML Convert intermediate MATLAB column to MATLAB
  This column should be apt as an argument to the table constructor
```

#### compiler.build.spark.data.ArrayType.col_IMPY_to_IMML

```text
col_IMPY_to_IMML  Convert Spark to intermediate py
```

#### compiler.build.spark.data.ArrayType.col_MATLABTable

```text
col_MATLABTable Convert column to MATLAB Table
 
  This is a helper function, that may be needed in case the normal
  MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
  convert everything from python values to MATLAB
```

#### compiler.build.spark.data.ArrayType.col_ML_to_IMML

```text
col_ML_to_IMML Convert MATLAB column to intermediate value
```

#### compiler.build.spark.data.ArrayType.col_Spark_to_IMPY

```text
col_Spark_to_IMPY  Convert Spark to intermediate py
```

#### compiler.build.spark.data.ArrayType.convertIntermediateToMATLAB

```text
convertIntermediateToMATLAB Intermediate to MATLAB
 
  For some datatypes, an intermediate representation is
  necessary (e.g. timestamps). If no conversion is necessary,
  this just returns the same value
```

#### compiler.build.spark.data.ArrayType.convertMATLABToIntermediate

```text
convertMATLABToIntermediate Convert MATLAB values to interm.
 
  For some datatypes, an intermediate representation is
  necessary (e.g. timestamps). If no conversion is necessary,
  this just returns the same value
```

#### compiler.build.spark.data.ArrayType.convertStructColumn

```text
convertStructColumn Helper for struct columns
 
  A struct column will need its field entries to be cell arrays.
```

#### compiler.build.spark.data.ArrayType.genMATLABArray

```text
genMATLABArray - Preallocate data
```

#### compiler.build.spark.data.ArrayType.genPythonExampleFunction

```text
genPythonExampleFunction Example values helper function
 
  This function generates a function that will generate a
  helper value
  This must be overridden.
```

#### compiler.build.spark.data.ArrayType.getIndexString_

```text
getIndexString
 
  Returns something like (k) or {k}
```

#### compiler.build.spark.data.ArrayType.getMATLABColumnEntry

```text
getMATLABColumnEntry Return a column entry
 
  This function is used to get one entry, that is one columns
  entry for a particular row, indicated by index k.
  It will behave differently for a scalar and an array. Furthermore,
  string behaviour may have to be handled in a custom way.
```

#### compiler.build.spark.data.ArrayType.getMLPandasSeriesConverterCtor

```text
Generates the PandasSeriesConverter constructor to invoke in
  order to construct the appropriate PandasSeriesConverter MATLAB
  object.

Help for compiler.build.spark.data.ArrayType/getMLPandasSeriesConverterCtor is inherited from superclass compiler.build.spark.data.DataType
```

#### compiler.build.spark.data.ArrayType.getPyPandasSeriesConverterCtor

```text
Generates the PandasSeriesConverter constructor to invoke in
  order to construct the appropriate PandasSeriesConverter python
  object.

Help for compiler.build.spark.data.ArrayType/getPyPandasSeriesConverterCtor is inherited from superclass compiler.build.spark.data.DataType
```

#### compiler.build.spark.data.ArrayType.instantiateColExampleData

```text
instantiateColExampleData Instantiate example data from column
 
  The column, is in general something like an ID column
  (spark.range(N)), and in simple cases is a cast to a
  different type.
```

#### compiler.build.spark.data.ArrayType.instantiateMATLABExampleValue

```text
instantiateMATLABExampleValue Create example value for MATLAB
 
  This method is used to create example files with values
```

#### compiler.build.spark.data.ArrayType.instantiatePythonExampleValue

```text
instantiatePythonExampleValue Create example value for Python
 
  This method is used to create example files with values
  Many types can use the standard Python conversions (float(),
  str(), etc.), and types with special requirements must
  subclass this method.
```

#### compiler.build.spark.data.ArrayType.isLeaf

```text
isLeaf Returns true for a leaf in the tree
```

#### compiler.build.spark.data.ArrayType.preAllocateMATLABColumn

```text
preAllocateMATLABColumn Preallocate column data
 
  This may be a simple zeros column for numeric types, or a
  cell array for array types.
  The argument N_str is a string describing the size of the
  column
```

#### compiler.build.spark.data.ArrayType.val_IMML_to_IMPY

```text
val_IMML_to_IMPY Convert a value to python
  Converts from intermediate MATLAB (e.g. matlab.int64([]) to
  intermediate python, e.g. [1,2,3]
```

#### compiler.build.spark.data.ArrayType.val_IMML_to_ML

```text
val_IMML_to_ML Convert an intermediate MATLAB value to MATLAB
```

#### compiler.build.spark.data.ArrayType.val_IMPY_to_IMML

```text
val_IMPY_to_IMML Convert a value to intermediate MATLAB
  
  In the case of an array, there may be an existing conversion
  function, like matlab.int32, or a created one. It will be
  taken from the underlying array function.
```

#### compiler.build.spark.data.ArrayType.val_IMPY_to_Spark

```text
val_IMPY_to_Spark  Convert intermediate py to Spark
  Converts from intermediate Python (e.g.int) to
  Spark timestamp, e.g. datetime.dateime(123456789)
```

#### compiler.build.spark.data.ArrayType.val_MATLABTable

```text
val_MATLABTable Convert column value to MATLAB value
 
  This is a helper function, that may be needed in case the normal
  MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
  convert everything from python values to MATLAB
```

#### compiler.build.spark.data.ArrayType.val_ML_to_IMML

```text
val_IMML_to_ML Convert an intermediate MATLAB value to MATLAB
```

#### compiler.build.spark.data.ArrayType.val_Spark_to_IMPY

```text
val_Spark_to_IMPY Convert a value to intermediate MATLAB
```

### compiler.build.spark.data.AtomicType

Superclass: compiler.build.spark.data.DataType

```text
AtomicType Implementation for types in Compiler workflow
```

#### compiler.build.spark.data.AtomicType.AtomicType

```text
AtomicType Implementation for types in Compiler workflow

    Documentation for compiler.build.spark.data.AtomicType
```

### compiler.build.spark.data.BaseType

Superclasses: handle, matlab.mixin.Heterogeneous

```text
BaseType Implementation for types in Compiler workflow
```

#### compiler.build.spark.data.BaseType.BaseType

```text
BaseType Implementation for types in Compiler workflow

    Documentation for compiler.build.spark.data.BaseType
```

#### compiler.build.spark.data.BaseType.getFileParent

```text
compiler.build.spark.data.BaseType/getFileParent is a function.
    parent = getFileParent(obj)
```

### compiler.build.spark.data.BinaryType

Superclass: compiler.build.spark.data.AtomicType

```text
BinaryType Implementation for types in Compiler workflow
```

#### compiler.build.spark.data.BinaryType.BinaryType

```text
BinaryType Implementation for types in Compiler workflow

    Documentation for compiler.build.spark.data.BinaryType
```

#### compiler.build.spark.data.BinaryType.PandasSeriesType

```text
PandasSeriesType The series type to be used in Pandas
```

#### compiler.build.spark.data.BinaryType.col_IMML_to_IMPY

```text
col_IMML_to_IMPY Convert a column to python
  Converts from intermediate MATLAB (e.g. matlab.int64([]) to
  intermediate python, e.g. [1,2,3]
```

#### compiler.build.spark.data.BinaryType.col_MATLABTable

```text
col_MATLABTable Convert column to MATLAB Table
 
  This is a helper function, that may be needed in case the normal
  MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
  convert everything from python values to MATLAB
```

#### compiler.build.spark.data.BinaryType.genPythonExampleFunction

```text
genPythonExampleFunction Example values helper function
 
  This function generates a function that will generate a
  helper value
  This must be overridden.
```

#### compiler.build.spark.data.BinaryType.getMLPandasSeriesConverterCtor

```text
Generates the PandasSeriesConverter constructor to invoke in
  order to construct the appropriate PandasSeriesConverter MATLAB
  object.

Help for compiler.build.spark.data.BinaryType/getMLPandasSeriesConverterCtor is inherited from superclass compiler.build.spark.data.DataType
```

#### compiler.build.spark.data.BinaryType.getPyPandasSeriesConverterCtor

```text
Generates the PandasSeriesConverter constructor to invoke in
  order to construct the appropriate PandasSeriesConverter python
  object.

Help for compiler.build.spark.data.BinaryType/getPyPandasSeriesConverterCtor is inherited from superclass compiler.build.spark.data.DataType
```

#### compiler.build.spark.data.BinaryType.instantiatePythonExampleValue

```text
instantiatePythonExampleValue Create example value for Python
 
  This method is used to create example files with values
  Many types can use the standard Python conversions (float(),
  str(), etc.), and types with special requirements must
  subclass this method.
```

#### compiler.build.spark.data.BinaryType.val_IMML_to_IMPY

```text
val_IMML_to_IMPY Convert a value to python
  Converts from intermediate MATLAB (e.g. matlab.int64([]) to
  intermediate python, e.g. [1,2,3]
```

### compiler.build.spark.data.BooleanType

Superclass: compiler.build.spark.data.AtomicType

```text
BooleanType Implementation for types in Compiler workflow
```

#### compiler.build.spark.data.BooleanType.BooleanType

```text
BooleanType Implementation for types in Compiler workflow

    Documentation for compiler.build.spark.data.BooleanType
```

#### compiler.build.spark.data.BooleanType.PandasSeriesType

```text
PandasSeriesType The series type to be used in Pandas
```

#### compiler.build.spark.data.BooleanType.array_IMML_to_IMPY

```text
array_IMML_to_IMPY Ensure the results are an array
 
  A table with 1 row will be returned as scalars from MATLAB
  Runtime.
 
  Returns the name of a function. If the function name is
  empty, no conversion is necessary.
```

#### compiler.build.spark.data.BooleanType.col_IMML_to_IMPY

```text
col_IMML_to_IMPY Convert a column to python
  Converts from intermediate MATLAB (e.g. matlab.int64([]) to
  intermediate python, e.g. [1,2,3]
```

#### compiler.build.spark.data.BooleanType.col_IMPY_to_IMML

```text
col_IMPY_to_IMML  Convert Spark to intermediate py
```

#### compiler.build.spark.data.BooleanType.genMATLABArray

```text
genMATLABArray - Preallocate data
```

#### compiler.build.spark.data.BooleanType.genPythonExampleFunction

```text
genPythonExampleFunction Example values helper function
 
  This function generates a function that will generate a
  helper value
  This must be overridden.
```

#### compiler.build.spark.data.BooleanType.getMLPandasSeriesConverterCtor

```text
Generates the PandasSeriesConverter constructor to invoke in
  order to construct the appropriate PandasSeriesConverter MATLAB
  object.

Help for compiler.build.spark.data.BooleanType/getMLPandasSeriesConverterCtor is inherited from superclass compiler.build.spark.data.DataType
```

#### compiler.build.spark.data.BooleanType.getPyPandasSeriesConverterCtor

```text
Generates the PandasSeriesConverter constructor to invoke in
  order to construct the appropriate PandasSeriesConverter python
  object.

Help for compiler.build.spark.data.BooleanType/getPyPandasSeriesConverterCtor is inherited from superclass compiler.build.spark.data.DataType
```

#### compiler.build.spark.data.BooleanType.instantiatePythonExampleValue

```text
instantiatePythonExampleValue Create example value for Python
 
  This method is used to create example files with values
  Many types can use the standard Python conversions (float(),
  str(), etc.), and types with special requirements must
  subclass this method.
```

#### compiler.build.spark.data.BooleanType.val_IMPY_to_IMML

```text
val_IMPY_to_IMML Convert a value to intermediate MATLAB
```

#### compiler.build.spark.data.BooleanType.val_MATLABTable

```text
val_MATLABTable Convert column value to MATLAB value
 
  This is a helper function, that may be needed in case the normal
  MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
  convert everything from python values to MATLAB
```

### compiler.build.spark.data.ByteType

Superclass: compiler.build.spark.data.IntegralType

```text
ByteType Implementation for types in Compiler workflow
```

#### compiler.build.spark.data.ByteType.ByteType

```text
ByteType Implementation for types in Compiler workflow

    Documentation for compiler.build.spark.data.ByteType
```

### compiler.build.spark.data.DataType

Superclass: compiler.build.spark.data.BaseType

```text
DataType Implementation for types in Compiler workflow
```

#### compiler.build.spark.data.DataType.DataType

```text
DataType Implementation for types in Compiler workflow

    Documentation for compiler.build.spark.data.DataType
```

#### compiler.build.spark.data.DataType.IntermediaryMATLABType

```text
IntermediaryMATLABType
 
  The IntermediaryMATLABType is sometimes used to have as a
  distinction for the real type (e.g. datetime) as opposed to
  the intermediary type (int64 for datetime).
```

#### compiler.build.spark.data.DataType.IntermediaryPythonType

```text
IntermediaryPythonType
 
  The IntermediaryPythonType is something that is used to check
  for if output is an instance, e.g. int, or a list of ints. In
  most cases, the intermediary type is just the python type,
  but in some cases, there's an intermediary type, which is
  used in python, as a route to MATLAB.
  The Timestamp data type is an example of this, so this method
  must be overridden there.
```

#### compiler.build.spark.data.DataType.PandasSeriesType

```text
PandasSeriesType The series type to be used in Pandas
```

#### compiler.build.spark.data.DataType.UniqueTypeName

```text
UniqueTypeName - A unique name for conversion functions
  This name will simply be the MATLABType for simple types,
  and some convoluted name for complex types.
```

#### compiler.build.spark.data.DataType.addIteratorRow

```text
compiler.build.spark.data.DataType/addIteratorRow is a function.
    codeLines = addIteratorRow(obj, rowSrc)
```

#### compiler.build.spark.data.DataType.arrayElemConverter

```text
arrayElemConverter Convert one element in array
 
  Returns the name of a function. If the function name is
  empty, no conversion is necessary.
```

#### compiler.build.spark.data.DataType.array_IMML_to_IMPY

```text
array_IMML_to_IMPY Ensure the results are an array
 
  A table with 1 row will be returned as scalars from MATLAB
  Runtime.
 
  Returns the name of a function. If the function name is
  empty, no conversion is necessary.
```

#### compiler.build.spark.data.DataType.array_IMML_to_ML

```text
array_IMML_to_ML Make an array conversion
```

#### compiler.build.spark.data.DataType.array_IMPY_to_IMML

```text
array_IMPY_to_IMML Convert array value to intermediate MATLAB
```

#### compiler.build.spark.data.DataType.array_ML_to_IMML

```text
array_ML_to_IMML - Convert to intermediate MATLAB
```

#### compiler.build.spark.data.DataType.array_Spark_to_IMPY

```text
array_Spark_to_IMPY Convert an array from Spark to IMPY
 
  This is different from the val_Spark_to_IMPY, because the way
  values can be returned from Spark, e.g. a list or a
  numpy.ndarray.
 
  Returns the name of a function. If the function name is
  empty, no conversion is necessary.
```

#### compiler.build.spark.data.DataType.colIntermediateMATLABToPython

```text
compiler.build.spark.data.DataType/colIntermediateMATLABToPython is a function.
    funcName = colIntermediateMATLABToPython(obj)
```

#### compiler.build.spark.data.DataType.colName

```text
compiler.build.spark.data.DataType/colName is a function.
    str = colName(obj)
```

#### compiler.build.spark.data.DataType.colName_

```text
compiler.build.spark.data.DataType/colName_ is a function.
    cName = colName_(obj)
```

#### compiler.build.spark.data.DataType.col_IMML_to_IMPY

```text
col_IMML_to_IMPY Convert a column to python
  Converts from intermediate MATLAB (e.g. matlab.int64([]) to
  intermediate python, e.g. [1,2,3]
```

#### compiler.build.spark.data.DataType.col_IMML_to_ML

```text
col_IMML_to_ML Convert intermediate MATLAB column to MATLAB
  This column should be apt as an argument to the table constructor
```

#### compiler.build.spark.data.DataType.col_IMML_to_PandasSeries

```text
col_IMML_to_PandasSeries
  Generate a helper function, and add it to the API struct. If already
  present, don't generate it.
```

#### compiler.build.spark.data.DataType.col_IMPY_to_IMML

```text
col_IMPY_to_IMML  Convert Spark to intermediate py
```

#### compiler.build.spark.data.DataType.col_IMPY_to_Spark

```text
col_IMPY_to_Spark  Convert intermediate py to Spark
  Converts from intermediate Python (e.g.int) to
  Spark timestamp, e.g. datetime.dateime(123456789)
```

#### compiler.build.spark.data.DataType.col_MATLABTable

```text
col_MATLABTable Convert column to MATLAB Table
 
  This is a helper function, that may be needed in case the normal
  MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
  convert everything from python values to MATLAB
```

#### compiler.build.spark.data.DataType.col_ML_to_IMML

```text
col_ML_to_IMML Convert MATLAB column to intermediate value
```

#### compiler.build.spark.data.DataType.col_Spark_to_IMPY

```text
col_Spark_to_IMPY  Convert Spark to intermediate py
```

#### compiler.build.spark.data.DataType.colsIteratorInit

```text
compiler.build.spark.data.DataType/colsIteratorInit is a function.
    strs = colsIteratorInit(obj)
```

#### compiler.build.spark.data.DataType.convertIntermediateToMATLAB

```text
convertIntermediateToMATLAB Intermediate to MATLAB
 
  For some datatypes, an intermediate representation is
  necessary (e.g. timestamps). If no conversion is necessary,
  this just returns the same value
```

#### compiler.build.spark.data.DataType.convertMATLABToIntermediate

```text
convertMATLABToIntermediate Convert MATLAB values to interm.
 
  For some datatypes, an intermediate representation is
  necessary (e.g. timestamps). If no conversion is necessary,
  this just returns the same value
```

#### compiler.build.spark.data.DataType.convertPandaColumnFromIntermediate

```text
convertPandaColumnFromIntermediate Panda columns to intermediate
 
  For some datatypes, an intermediate representation is
  necessary (e.g. timestamps). If no conversion is necessary,
  this just returns the same value
 
  If the code out is not length zero, it will be added to the code.
```

#### compiler.build.spark.data.DataType.convertStructColumn

```text
convertStructColumn Helper for struct columns
 
  A struct column will need its field entries to be cell arrays.
```

#### compiler.build.spark.data.DataType.genIntermediateArrayToPython

```text
genIntermediateArrayToPython
  Generate a helper function, and add it to the API struct. If already
  present, don't generate it.
```

#### compiler.build.spark.data.DataType.genMATLABArray

```text
compiler.build.spark.data.DataType/genMATLABArray is a function.
    arrStr = genMATLABArray(obj, N)
```

#### compiler.build.spark.data.DataType.genPythonExampleFunction

```text
genPythonExampleFunction Example values helper function
 
  This function generates a function that will generate a
  helper value
  This must be overridden.
```

#### compiler.build.spark.data.DataType.getColumnIndex

```text
getColumnIndex Return the column index
  Returns column index, as well as if it's an input or an
  output. The column index here is the top-level, i.e. a table
  entry, or an array entry, will be mapped to the corresponding
  column above.
```

#### compiler.build.spark.data.DataType.getColumnObject

```text
getColumnObject Return column object
  The column object is the data on the top-level, i.e. the data
  directly in the file object.
```

#### compiler.build.spark.data.DataType.getIndexString

```text
getIndexString
 
  Returns something like (k) or {k}
```

#### compiler.build.spark.data.DataType.getIndexString_

```text
getIndexString_
 
  Returns something like (k) or {k}
```

#### compiler.build.spark.data.DataType.getMATLABColumnEntry

```text
getMATLABColumnEntry Return a column entry
 
  This function is used to get one entry, that is one columns
  entry for a particular row, indicated by index k.
  It will behave differently for a scalar and an array. Furthermore,
  string behaviour may have to be handled in a custom way.
```

#### compiler.build.spark.data.DataType.getMLPandasSeriesConverterCtor

```text
Generates the PandasSeriesConverter constructor to invoke in
  order to construct the appropriate PandasSeriesConverter MATLAB
  object.
```

#### compiler.build.spark.data.DataType.getParentColName

```text
getParentColName Helper function for column name
  This is needed, to ascertain if a function's parent is, for
  example, the key in a map. This has an influence in creating
  unique column names.
```

#### compiler.build.spark.data.DataType.getPyPandasSeriesConverterCtor

```text
Generates the PandasSeriesConverter constructor to invoke in
  order to construct the appropriate PandasSeriesConverter python
  object.
```

#### compiler.build.spark.data.DataType.hasDataTypeParent

```text
compiler.build.spark.data.DataType/hasDataTypeParent is a function.
    tf = hasDataTypeParent(obj)
```

#### compiler.build.spark.data.DataType.instantiateColExampleData

```text
instantiateColExampleData Instantiate example data from column
 
  The column, is in general something like an ID column
  (spark.range(N)), and in simple cases is a cast to a
  different type.
```

#### compiler.build.spark.data.DataType.instantiateMATLABExampleValue

```text
instantiateMATLABExampleValue Create example value for MATLAB
 
  This method is used to create example files with values
```

#### compiler.build.spark.data.DataType.instantiatePythonExampleValue

```text
instantiatePythonExampleValue Create example value for Python
 
  This method is used to create example files with values
  Many types can use the standard Python conversions (float(),
  str(), etc.), and types with special requirements must
  subclass this method.
```

#### compiler.build.spark.data.DataType.isColumn

```text
isColumn Check if an object is actually a column
  This is true if it's part of a table input (or output), and
  if it's part of the top-level structure. This is important,
  in certain conversions. A column with type array<something>
  should always return cell arrays in MATLAB, whereas an array
  element in a struct, in general, shouldnt.
```

#### compiler.build.spark.data.DataType.isExtraArgument

```text
isExtraArgument Check if this is an additional argument
 
  It can only be an extra argument if it's an input, it's index
  is larger than one, and the first argument is a table.
  This will be needed in conversion routines
```

#### compiler.build.spark.data.DataType.isLeaf

```text
isLeaf Returns true for a leaf in the tree
```

#### compiler.build.spark.data.DataType.isScalarData

```text
compiler.build.spark.data.DataType/isScalarData is a function.
    tf = isScalarData(obj)
```

#### compiler.build.spark.data.DataType.pandasSeriesToColumn

```text
compiler.build.spark.data.DataType/pandasSeriesToColumn is a function.
    codeOut = pandasSeriesToColumn(obj)
```

#### compiler.build.spark.data.DataType.preAllocateMATLABColumn

```text
preAllocateMATLABColumn Preallocate column data
 
  This may be a simple zeros column for numeric types, or a
  cell array for array types.
  The argument N_str is a string describing the size of the
  column
```

#### compiler.build.spark.data.DataType.table_IMML_to_ML

```text
table_IMML_to_ML Convert one column for a table.
  This function is necessary, to deal with the difficulties of
  handling struct columns, and deeper nesting. 
  In most cases, it will just revert to using the
  col_IMML_to_ML, except in the case of StructType
```

#### compiler.build.spark.data.DataType.val_IMML_to_IMPY

```text
val_IMML_to_IMPY Convert a value to python
  Converts from intermediate MATLAB (e.g. matlab.int64([]) to
  intermediate python, e.g. [1,2,3]
```

#### compiler.build.spark.data.DataType.val_IMML_to_ML

```text
val_IMML_to_ML Convert an intermediate MATLAB value to MATLAB
```

#### compiler.build.spark.data.DataType.val_IMPY_to_IMML

```text
val_IMPY_to_IMML Convert a value to intermediate MATLAB
```

#### compiler.build.spark.data.DataType.val_IMPY_to_Spark

```text
val_IMPY_to_Spark  Convert intermediate py to Spark
  Converts from intermediate Python (e.g.int) to
  Spark timestamp, e.g. datetime.dateime(123456789)
```

#### compiler.build.spark.data.DataType.val_MATLABTable

```text
val_MATLABTable Convert column value to MATLAB value
 
  This is a helper function, that may be needed in case the normal
  MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
  convert everything from python values to MATLAB
```

#### compiler.build.spark.data.DataType.val_ML_to_IMML

```text
val_ML_to_IMML Convert a value to intermediate MATLAB
```

#### compiler.build.spark.data.DataType.val_Spark_to_IMPY

```text
val_Spark_to_IMPY Convert a value to intermediate MATLAB
```

### compiler.build.spark.data.DateTimeStampType

Superclass: compiler.build.spark.data.AtomicType

```text
DateTimeStampType Implementation for types in Compiler workflow
 
  This is an abstract base class, common to both timestamps and durations.
  The reason is that the classes inheriting from this one shares some features,
  like their underlying intermediate representation.
```

#### compiler.build.spark.data.DateTimeStampType.DateTimeStampType

```text
DateTimeStampType Implementation for types in Compiler workflow
 
  This is an abstract base class, common to both timestamps and durations.
  The reason is that the classes inheriting from this one shares some features,
  like their underlying intermediate representation.

    Documentation for compiler.build.spark.data.DateTimeStampType
```

#### compiler.build.spark.data.DateTimeStampType.arrayElemConverter

```text
arrayElemConverter Convert one element in array
 
  Returns the name of a function. If the function name is
  empty, no conversion is necessary.
```

#### compiler.build.spark.data.DateTimeStampType.array_IMML_to_IMPY

```text
array_IMML_to_IMPY Ensure the results are an array
 
  A table with 1 row will be returned as scalars from MATLAB
  Runtime.
 
  Returns the name of a function. If the function name is
  empty, no conversion is necessary.
```

#### compiler.build.spark.data.DateTimeStampType.array_IMPY_to_IMML

```text
array_IMPY_to_IMML Convert array value to intermediate MATLAB
```

#### compiler.build.spark.data.DateTimeStampType.col_IMML_to_IMPY

```text
col_IMML_to_IMPY Convert a column to python
  Converts from intermediate MATLAB (e.g. matlab.int64([]) to
  intermediate python, e.g. [1,2,3]
```

#### compiler.build.spark.data.DateTimeStampType.col_IMPY_to_IMML

```text
col_IMPY_to_IMML  Convert Spark to intermediate py
```

#### compiler.build.spark.data.DateTimeStampType.val_IMPY_to_IMML

```text
val_IMPY_to_IMML Convert a value to intermediate MATLAB
```

### compiler.build.spark.data.DateType

Superclass: compiler.build.spark.data.DateTimeStampType

```text
DateType Implementation for types in Compiler workflow
```

#### compiler.build.spark.data.DateType.DateType

```text
DateType Implementation for types in Compiler workflow

    Documentation for compiler.build.spark.data.DateType
```

#### compiler.build.spark.data.DateType.IntermediaryMATLABType

```text
IntermediaryMATLABType
 
  The IntermediaryMATLABType is sometimes used to have as a
  distinction for the real type (e.g. datetime) as opposed to
  the intermediary type (int64 for datetime).
```

#### compiler.build.spark.data.DateType.PandasSeriesType

```text
PandasSeriesType The series type to be used in Pandas
```

#### compiler.build.spark.data.DateType.UniqueTypeName

```text
UniqueTypeName - A unique name for conversion functions
  This name will simply be the MATLABType for simple types,
  and some convoluted name for complex types.
```

#### compiler.build.spark.data.DateType.col_MATLABTable

```text
col_MATLABTable Convert column to MATLAB Table
 
  This is a helper function, that may be needed in case the normal
  MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
  convert everything from python values to MATLAB
```

#### compiler.build.spark.data.DateType.genPythonExampleFunction

```text
genPythonExampleFunction Example values helper function
 
  This function generates a function that will generate a
  helper value
  This must be overridden.
```

#### compiler.build.spark.data.DateType.getMLPandasSeriesConverterCtor

```text
Generates the PandasSeriesConverter constructor to invoke in
  order to construct the appropriate PandasSeriesConverter MATLAB
  object.

Help for compiler.build.spark.data.DateType/getMLPandasSeriesConverterCtor is inherited from superclass compiler.build.spark.data.DataType
```

#### compiler.build.spark.data.DateType.getPyPandasSeriesConverterCtor

```text
Generates the PandasSeriesConverter constructor to invoke in
  order to construct the appropriate PandasSeriesConverter python
  object.

Help for compiler.build.spark.data.DateType/getPyPandasSeriesConverterCtor is inherited from superclass compiler.build.spark.data.DataType
```

#### compiler.build.spark.data.DateType.instantiateColExampleData

```text
instantiateColExampleData Instantiate example data from column
 
  The column, is in general something like an ID column
  (spark.range(N)), and in simple cases is a cast to a
  different type.
```

#### compiler.build.spark.data.DateType.val_IMML_to_ML

```text
val_IMML_to_ML Convert a value from intermediate MATLAB
```

#### compiler.build.spark.data.DateType.val_IMPY_to_Spark

```text
val_IMPY_to_Spark  Convert intermediate py to Spark
  Converts from intermediate Python (e.g.int) to
  Spark timestamp, e.g. datetime.dateime(123456789)
```

#### compiler.build.spark.data.DateType.val_ML_to_IMML

```text
val_ML_to_IMML Convert a value to intermediate MATLAB
```

#### compiler.build.spark.data.DateType.val_Spark_to_IMPY

```text
val_Spark_to_IMPY Convert a value to intermediate MATLAB
```

### compiler.build.spark.data.DayTimeIntervalType

Superclass: compiler.build.spark.data.AnsiIntervalType

```text
DayTimeIntervalType Implementation for types in Compiler workflow
```

#### compiler.build.spark.data.DayTimeIntervalType.DayTimeIntervalType

```text
DayTimeIntervalType Implementation for types in Compiler workflow

    Documentation for compiler.build.spark.data.DayTimeIntervalType
```

#### compiler.build.spark.data.DayTimeIntervalType.IntermediaryMATLABType

```text
get.IntermediaryMATLABType
 
  The IntermediaryMATLABType is sometimes used to have as a
  distinction for the real type (e.g. datetime) as opposed to
  the intermediary type (int64 for datetime).
```

#### compiler.build.spark.data.DayTimeIntervalType.IntermediaryPythonType

```text
get.IntermediaryPythonType
 
  The IntermediaryPythonType is something that is used to check
  for if output is an instance, e.g. int, or a list of ints. In
  most cases, the intermediary type is just the python type,
  but in some cases, there's an intermediary type, which is
  used in python, as a route to MATLAB.
  The Timestamp data type is an example of this, so this method
  must be overridden there.
```

#### compiler.build.spark.data.DayTimeIntervalType.PandasSeriesType

```text
PandasSeriesType The series type to be used in Pandas
```

#### compiler.build.spark.data.DayTimeIntervalType.col_IMML_to_IMPY

```text
col_IMML_to_IMPY Convert a column to python
  Converts from intermediate MATLAB (e.g. matlab.int64([]) to
  intermediate python, e.g. [1,2,3]
```

#### compiler.build.spark.data.DayTimeIntervalType.col_IMPY_to_IMML

```text
col_IMPY_to_IMML  Convert Spark to intermediate py
```

#### compiler.build.spark.data.DayTimeIntervalType.colsIteratorInit

```text
compiler.build.spark.data.DayTimeIntervalType/colsIteratorInit is a function.
    strs = colsIteratorInit(obj)
```

#### compiler.build.spark.data.DayTimeIntervalType.convertMATLABToIntermediate

```text
convertMATLABToIntermediate Convert MATLAB values to interm.
 
  For some datatypes, an intermediate representation is
  necessary (e.g. timestamps). If no conversion is necessary,
  this just returns the same value
```

#### compiler.build.spark.data.DayTimeIntervalType.convertPandaColumnToIntermediate

```text
convertPandaColumnToIntermediate Panda columns to intermediate
 
  For some datatypes, an intermediate representation is
  necessary (e.g. timestamps). If no conversion is necessary,
  this just returns the same value
```

#### compiler.build.spark.data.DayTimeIntervalType.genPythonExampleFunction

```text
genPythonExampleFunction Example values helper function
 
  This function generates a function that will generate a
  helper value
  This must be overridden.
```

#### compiler.build.spark.data.DayTimeIntervalType.getMLPandasSeriesConverterCtor

```text
Generates the PandasSeriesConverter constructor to invoke in
  order to construct the appropriate PandasSeriesConverter MATLAB
  object.

Help for compiler.build.spark.data.DayTimeIntervalType/getMLPandasSeriesConverterCtor is inherited from superclass compiler.build.spark.data.DataType
```

#### compiler.build.spark.data.DayTimeIntervalType.getPyPandasSeriesConverterCtor

```text
Generates the PandasSeriesConverter constructor to invoke in
  order to construct the appropriate PandasSeriesConverter python
  object.

Help for compiler.build.spark.data.DayTimeIntervalType/getPyPandasSeriesConverterCtor is inherited from superclass compiler.build.spark.data.DataType
```

#### compiler.build.spark.data.DayTimeIntervalType.instantiateMATLABExampleValue

```text
instantiateMATLABExampleValue Create example value for MATLAB
 
  This method is used to create example files with values
```

#### compiler.build.spark.data.DayTimeIntervalType.instantiatePythonExampleValue

```text
instantiatePythonExampleValue Create example value for Python
 
  See compiler.build.spark.types.ArgType/instantiatePythonExampleValue
```

#### compiler.build.spark.data.DayTimeIntervalType.val_IMML_to_ML

```text
val_IMML_to_ML Convert a value to intermediate MATLAB
```

#### compiler.build.spark.data.DayTimeIntervalType.val_IMPY_to_IMML

```text
val_IMPY_to_IMML Convert a value from intermediate MATLAB
```

#### compiler.build.spark.data.DayTimeIntervalType.val_IMPY_to_Spark

```text
val_IMPY_to_Spark  Convert intermediate py to Spark
  Converts from intermediate Python (e.g.int) to
  Spark timestamp, e.g. datetime.dateime(123456789)
```

#### compiler.build.spark.data.DayTimeIntervalType.val_ML_to_IMML

```text
val_ML_to_IMML Convert a value to intermediate MATLAB
```

#### compiler.build.spark.data.DayTimeIntervalType.val_Spark_to_IMPY

```text
val_Spark_to_IMPY Convert a value to intermediate MATLAB
```

### compiler.build.spark.data.DecimalType

Superclass: compiler.build.spark.data.FractionalType

```text
DecimalType Implementation for types in Compiler workflow
```

#### compiler.build.spark.data.DecimalType.DecimalType

```text
DecimalType Implementation for types in Compiler workflow

    Documentation for compiler.build.spark.data.DecimalType
```

#### compiler.build.spark.data.DecimalType.PandasSeriesType

```text
PandasSeriesType The series type to be used in Pandas
```

#### compiler.build.spark.data.DecimalType.UniqueTypeName

```text
UniqueTypeName - A unique name for conversion functions
  This name will simply be the MATLABType for simple types,
  and some convoluted name for complex types.
```

#### compiler.build.spark.data.DecimalType.col_IMML_to_IMPY

```text
col_IMML_to_IMPY Convert a column to python
  Converts from intermediate MATLAB (e.g. matlab.int64([]) to
  intermediate python, e.g. [1,2,3]
```

#### compiler.build.spark.data.DecimalType.col_MATLABTable

```text
col_MATLABTable Convert column to MATLAB Table
 
  This is a helper function, that may be needed in case the normal
  MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
  convert everything from python values to MATLAB
```

#### compiler.build.spark.data.DecimalType.genPythonExampleFunction

```text
genPythonExampleFunction Example values helper function
 
  This function generates a function that will generate a
  helper value
  This must be overridden.
```

#### compiler.build.spark.data.DecimalType.getMLPandasSeriesConverterCtor

```text
Generates the PandasSeriesConverter constructor to invoke in
  order to construct the appropriate PandasSeriesConverter MATLAB
  object.

Help for compiler.build.spark.data.DecimalType/getMLPandasSeriesConverterCtor is inherited from superclass compiler.build.spark.data.DataType
```

#### compiler.build.spark.data.DecimalType.getPyPandasSeriesConverterCtor

```text
Generates the PandasSeriesConverter constructor to invoke in
  order to construct the appropriate PandasSeriesConverter python
  object.

Help for compiler.build.spark.data.DecimalType/getPyPandasSeriesConverterCtor is inherited from superclass compiler.build.spark.data.DataType
```

#### compiler.build.spark.data.DecimalType.val_IMPY_to_Spark

```text
val_IMPY_to_Spark  Convert intermediate py to Spark
  Converts from intermediate Python (e.g.int) to
  Spark timestamp, e.g. datetime.dateime(123456789)
```

#### compiler.build.spark.data.DecimalType.val_MATLABTable

```text
val_MATLABTable Convert column value to MATLAB value
 
  This is a helper function, that may be needed in case the normal
  MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
  convert everything from python values to MATLAB
```

#### compiler.build.spark.data.DecimalType.val_Spark_to_IMPY

```text
val_Spark_to_IMPY Convert a value to intermediate MATLAB
```

### compiler.build.spark.data.DoubleType

Superclass: compiler.build.spark.data.FractionalType

```text
DoubleType Implementation for types in Compiler workflow
```

#### compiler.build.spark.data.DoubleType.DoubleType

```text
DoubleType Implementation for types in Compiler workflow

    Documentation for compiler.build.spark.data.DoubleType
```

#### compiler.build.spark.data.DoubleType.val_MATLABTable

```text
val_MATLABTable Convert column value to MATLAB value
 
  This is a helper function, that may be needed in case the normal
  MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
  convert everything from python values to MATLAB
```

### compiler.build.spark.data.FloatType

Superclass: compiler.build.spark.data.FractionalType

```text
FloatType Implementation for types in Compiler workflow
```

#### compiler.build.spark.data.FloatType.FloatType

```text
FloatType Implementation for types in Compiler workflow

    Documentation for compiler.build.spark.data.FloatType
```

#### compiler.build.spark.data.FloatType.val_MATLABTable

```text
val_MATLABTable Convert column value to MATLAB value
 
  This is a helper function, that may be needed in case the normal
  MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
  convert everything from python values to MATLAB
```

### compiler.build.spark.data.FractionalType

Superclass: compiler.build.spark.data.NumericType

```text
FractionalType Implementation for types in Compiler workflow
```

#### compiler.build.spark.data.FractionalType.FractionalType

```text
FractionalType Implementation for types in Compiler workflow

    Documentation for compiler.build.spark.data.FractionalType
```

#### compiler.build.spark.data.FractionalType.genPythonExampleFunction

```text
genPythonExampleFunction Example values helper function
 
  This function generates a function that will generate a
  helper value
  This must be overridden.
```

### compiler.build.spark.data.IntegerType

Superclass: compiler.build.spark.data.IntegralType

```text
IntegerType Implementation for types in Compiler workflow
```

#### compiler.build.spark.data.IntegerType.IntegerType

```text
IntegerType Implementation for types in Compiler workflow

    Documentation for compiler.build.spark.data.IntegerType
```

### compiler.build.spark.data.IntegralType

Superclass: compiler.build.spark.data.NumericType

```text
IntegralType Implementation for types in Compiler workflow
```

#### compiler.build.spark.data.IntegralType.IntegralType

```text
IntegralType Implementation for types in Compiler workflow

    Documentation for compiler.build.spark.data.IntegralType
```

#### compiler.build.spark.data.IntegralType.genPythonExampleFunction

```text
genPythonExampleFunction Example values helper function
 
  This function generates a function that will generate a
  helper value
  This must be overridden.
```

#### compiler.build.spark.data.IntegralType.val_MATLABTable

```text
val_MATLABTable Convert column value to MATLAB value
 
  This is a helper function, that may be needed in case the normal
  MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
  convert everything from python values to MATLAB
```

### compiler.build.spark.data.LongType

Superclass: compiler.build.spark.data.IntegralType

```text
LongType Implementation for types in Compiler workflow
```

#### compiler.build.spark.data.LongType.LongType

```text
LongType Implementation for types in Compiler workflow

    Documentation for compiler.build.spark.data.LongType
```

### compiler.build.spark.data.MapType

Superclass: compiler.build.spark.data.DataType

```text
MapType Implementation for types in Compiler workflow
```

#### compiler.build.spark.data.MapType.MapType

```text
MapType Implementation for types in Compiler workflow

    Documentation for compiler.build.spark.data.MapType
```

#### compiler.build.spark.data.MapType.PandasSeriesType

```text
PandasSeriesType The series type to be used in Pandas
```

#### compiler.build.spark.data.MapType.UniqueTypeName

```text
UniqueTypeName - A unique name for conversion functions
  This name will simply be the MATLABType for simple types,
  and some convoluted name for complex types.
```

#### compiler.build.spark.data.MapType.col_IMML_to_IMPY

```text
col_IMML_to_IMPY Convert a column to python
  Converts from intermediate MATLAB (e.g. matlab.int64([]) to
  intermediate python, e.g. [1,2,3]
```

#### compiler.build.spark.data.MapType.col_IMML_to_ML

```text
col_IMML_to_ML Convert intermediate MATLAB column to MATLAB
  This column should be apt as an argument to the table constructor
```

#### compiler.build.spark.data.MapType.col_IMPY_to_IMML

```text
col_IMPY_to_IMML  Convert Spark to intermediate py
```

#### compiler.build.spark.data.MapType.col_MATLABTable

```text
col_MATLABTable Convert column to MATLAB Table
 
  This is a helper function, that may be needed in case the normal
  MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
  convert everything from python values to MATLAB
```

#### compiler.build.spark.data.MapType.col_ML_to_IMML

```text
col_ML_to_IMML Convert MATLAB column to intermediate value
```

#### compiler.build.spark.data.MapType.col_Spark_to_IMPY

```text
col_Spark_to_IMPY  Convert Spark to intermediate py
```

#### compiler.build.spark.data.MapType.genMATLABArray

```text
genMATLABArray - Preallocate data
```

#### compiler.build.spark.data.MapType.genPythonExampleFunction

```text
genPythonExampleFunction Example values helper function
 
  This function generates a function that will generate a
  helper value
  This must be overridden.
```

#### compiler.build.spark.data.MapType.getIndexString_

```text
getIndexString
 
  Returns something like (k) or {k}
```

#### compiler.build.spark.data.MapType.getMLPandasSeriesConverterCtor

```text
Generates the PandasSeriesConverter constructor to invoke in
  order to construct the appropriate PandasSeriesConverter MATLAB
  object.

Help for compiler.build.spark.data.MapType/getMLPandasSeriesConverterCtor is inherited from superclass compiler.build.spark.data.DataType
```

#### compiler.build.spark.data.MapType.getPyPandasSeriesConverterCtor

```text
Generates the PandasSeriesConverter constructor to invoke in
  order to construct the appropriate PandasSeriesConverter python
  object.

Help for compiler.build.spark.data.MapType/getPyPandasSeriesConverterCtor is inherited from superclass compiler.build.spark.data.DataType
```

#### compiler.build.spark.data.MapType.instantiatePythonExampleValue

```text
instantiatePythonExampleValue Create example value for Python
 
  This method is used to create example files with values
  Many types can use the standard Python conversions (float(),
  str(), etc.), and types with special requirements must
  subclass this method.
```

#### compiler.build.spark.data.MapType.isLeaf

```text
isLeaf Returns true for a leaf in the tree
```

#### compiler.build.spark.data.MapType.preAllocateMATLABColumn

```text
preAllocateMATLABColumn Preallocate column data
 
  This may be a simple zeros column for numeric types, or a
  cell array for array types.
  The argument N_str is a string describing the size of the
  column
```

#### compiler.build.spark.data.MapType.val_IMML_to_IMPY

```text
val_IMML_to_IMPY Convert a value to python
  Converts from intermediate MATLAB (e.g. matlab.int64([]) to
  intermediate python, e.g. [1,2,3]
```

#### compiler.build.spark.data.MapType.val_IMML_to_ML

```text
val_IMML_to_ML Convert an intermediate MATLAB value to MATLAB
```

#### compiler.build.spark.data.MapType.val_IMPY_to_IMML

```text
val_IMPY_to_IMML Convert a value to intermediate MATLAB
 
  In the case of an array, there may be an existing conversion
  function, like matlab.int32, or a created one. It will be
  taken from the underlying array function.
```

#### compiler.build.spark.data.MapType.val_IMPY_to_Spark

```text
val_IMPY_to_Spark  Convert intermediate py to Spark
  Converts from intermediate Python (e.g.int) to
  Spark timestamp, e.g. datetime.dateime(123456789)
```

#### compiler.build.spark.data.MapType.val_MATLABTable

```text
val_MATLABTable Convert column value to MATLAB value
 
  This is a helper function, that may be needed in case the normal
  MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
  convert everything from python values to MATLAB
```

#### compiler.build.spark.data.MapType.val_ML_to_IMML

```text
val_IMML_to_ML Convert an intermediate MATLAB value to MATLAB
```

#### compiler.build.spark.data.MapType.val_Spark_to_IMPY

```text
val_Spark_to_IMPY Convert a value to intermediate MATLAB
```

### compiler.build.spark.data.NumericType

Superclass: compiler.build.spark.data.AtomicType

```text
NumericType Implementation for types in Compiler workflow
```

#### compiler.build.spark.data.NumericType.NumericType

```text
NumericType Implementation for types in Compiler workflow

    Documentation for compiler.build.spark.data.NumericType
```

#### compiler.build.spark.data.NumericType.array_IMML_to_IMPY

```text
array_IMML_to_IMPY Ensure the results are an array
 
  A table with 1 row will be returned as scalars from MATLAB
  Runtime.
 
  Returns the name of a function. If the function name is
  empty, no conversion is necessary.
```

#### compiler.build.spark.data.NumericType.array_IMPY_to_IMML

```text
array_IMPY_to_IMML Convert array value to intermediate MATLAB
```

#### compiler.build.spark.data.NumericType.col_IMML_to_IMPY

```text
col_IMML_to_IMPY Convert a column to python
  Converts from intermediate MATLAB (e.g. matlab.int64([]) to
  intermediate python, e.g. [1,2,3]
```

#### compiler.build.spark.data.NumericType.col_IMPY_to_IMML

```text
col_IMPY_to_IMML  Convert Spark to intermediate py
```

#### compiler.build.spark.data.NumericType.convertStructColumn

```text
convertStructColumn Helper for struct columns
 
  A struct column will need its field entries to be cell arrays.
```

#### compiler.build.spark.data.NumericType.genMATLABArray

```text
genMATLABArray - Preallocate data
```

#### compiler.build.spark.data.NumericType.getMLPandasSeriesConverterCtor

```text
Generates the PandasSeriesConverter constructor to invoke in
  order to construct the appropriate PandasSeriesConverter MATLAB
  object.

Help for compiler.build.spark.data.NumericType/getMLPandasSeriesConverterCtor is inherited from superclass compiler.build.spark.data.DataType
```

#### compiler.build.spark.data.NumericType.getPyPandasSeriesConverterCtor

```text
Generates the PandasSeriesConverter constructor to invoke in
  order to construct the appropriate PandasSeriesConverter python
  object.

Help for compiler.build.spark.data.NumericType/getPyPandasSeriesConverterCtor is inherited from superclass compiler.build.spark.data.DataType
```

#### compiler.build.spark.data.NumericType.pandasSeriesToColumn

```text
compiler.build.spark.data.NumericType/pandasSeriesToColumn is a function.
    codeOut = pandasSeriesToColumn(obj)
```

#### compiler.build.spark.data.NumericType.val_IMML_to_ML

```text
val_IMML_to_ML Convert an intermediate MATLAB value to MATLAB
```

#### compiler.build.spark.data.NumericType.val_IMPY_to_IMML

```text
val_IMPY_to_IMML Convert a value to intermediate MATLAB
```

### compiler.build.spark.data.ShortType

Superclass: compiler.build.spark.data.IntegralType

```text
ShortType Implementation for types in Compiler workflow
```

#### compiler.build.spark.data.ShortType.ShortType

```text
ShortType Implementation for types in Compiler workflow

    Documentation for compiler.build.spark.data.ShortType
```

### compiler.build.spark.data.StringType

Superclass: compiler.build.spark.data.AtomicType

```text
StringType Implementation for types in Compiler workflow
  
  This class deals with Strings and the conversion between MATLAB, Spark
  and Python.
```

#### compiler.build.spark.data.StringType.StringType

```text
StringType Implementation for types in Compiler workflow
  
  This class deals with Strings and the conversion between MATLAB, Spark
  and Python.

    Documentation for compiler.build.spark.data.StringType
```

#### compiler.build.spark.data.StringType.arrayElemConverter

```text
arrayElemConverter Convert one element in array
 
  Returns the name of a function. If the function name is
  empty, no conversion is necessary.
```

#### compiler.build.spark.data.StringType.array_IMML_to_IMPY

```text
array_IMML_to_IMPY Ensure the results are an array
 
  A table with 1 row will be returned as scalars from MATLAB
  Runtime.
 
  Returns the name of a function. If the function name is
  empty, no conversion is necessary.
```

#### compiler.build.spark.data.StringType.array_IMML_to_ML

```text
array_IMML_to_ML Make an array conversion
```

#### compiler.build.spark.data.StringType.col_IMML_to_IMPY

```text
col_IMML_to_IMPY Convert to python
  Converts from intermediate MATLAB (e.g. matlab.int64([]) to
  intermediate python, e.g. [1,2,3]
```

#### compiler.build.spark.data.StringType.col_IMML_to_ML

```text
col_IMML_to_ML Convert intermediate MATLAB column to MATLAB
  This column should be apt as an argument to the table constructor
```

#### compiler.build.spark.data.StringType.col_MATLABTable

```text
col_MATLABTable Convert column to MATLAB Table
 
  This is a helper function, that may be needed in case the normal
  MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
  convert everything from python values to MATLAB
```

#### compiler.build.spark.data.StringType.convertIntermediateToMATLAB

```text
convertIntermediateToMATLAB Intermediate to MATLAB
 
  For some datatypes, an intermediate representation is
  necessary (e.g. timestamps). If no conversion is necessary,
  this just returns the same value
  TODO: Look this up warning("SPARKAPI:not_yet_implemented", "Verify this with old style. - %s", mfilename("fullpath"));
```

#### compiler.build.spark.data.StringType.convertMATLABToIntermediate

```text
convertMATLABToIntermediate Convert MATLAB values to interm.
 
  For some datatypes, an intermediate representation is
  necessary (e.g. timestamps). If no conversion is necessary,
  this just returns the same value
```

#### compiler.build.spark.data.StringType.convertStructColumn

```text
convertStructColumn Helper for struct columns
 
  A struct column will need its field entries to be cell arrays.
```

#### compiler.build.spark.data.StringType.genMATLABArray

```text
genMATLABArray - Preallocate data
```

#### compiler.build.spark.data.StringType.genPythonExampleFunction

```text
genPythonExampleFunction Example values helper function
 
  This function generates a function that will generate a
  helper value
  This must be overridden.
```

#### compiler.build.spark.data.StringType.getMATLABColumnEntry

```text
getMATLABColumnEntry Return a column entry
 
  This function is used to get one entry, that is one columns
  entry for a particular row, indicated by index k.
  It will behave differently for a scalar and an array. Furthermore,
  string behaviour may have to be handled in a custom way.
```

#### compiler.build.spark.data.StringType.getMLPandasSeriesConverterCtor

```text
Generates the PandasSeriesConverter constructor to invoke in
  order to construct the appropriate PandasSeriesConverter MATLAB
  object.

Help for compiler.build.spark.data.StringType/getMLPandasSeriesConverterCtor is inherited from superclass compiler.build.spark.data.DataType
```

#### compiler.build.spark.data.StringType.getPyPandasSeriesConverterCtor

```text
Generates the PandasSeriesConverter constructor to invoke in
  order to construct the appropriate PandasSeriesConverter python
  object.

Help for compiler.build.spark.data.StringType/getPyPandasSeriesConverterCtor is inherited from superclass compiler.build.spark.data.DataType
```

#### compiler.build.spark.data.StringType.instantiateMATLABExampleValue

```text
instantiateMATLABExampleValue Create example value for MATLAB
 
  This method is used to create example files with values
```

#### compiler.build.spark.data.StringType.instantiatePythonExampleValue

```text
instantiatePythonExampleValue Create example value for Python
 
  See compiler.build.spark.types.ArgType/instantiatePythonExampleValue
```

#### compiler.build.spark.data.StringType.preAllocateMATLABColumn

```text
preAllocateMATLABColumn Preallocate column data
 
  This may be a simple zeros column for numeric types, or a
  cell array for array types.
  The argument N_str is a string describing the size of the
  column
```

#### compiler.build.spark.data.StringType.val_IMML_to_ML

```text
val_IMML_to_ML Convert an intermediate MATLAB value to MATLAB
```

#### compiler.build.spark.data.StringType.val_MATLABTable

```text
val_MATLABTable Convert column value to MATLAB value
 
  This is a helper function, that may be needed in case the normal
  MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
  convert everything from python values to MATLAB
```

### compiler.build.spark.data.StructField

Superclass: compiler.build.spark.data.DataType

```text
StructField Implementation for types in Compiler workflow
```

#### compiler.build.spark.data.StructField.StructField

```text
StructField Implementation for types in Compiler workflow

    Documentation for compiler.build.spark.data.StructField
```

#### compiler.build.spark.data.StructField.colName_

```text
A StructField always has a Parent
```

#### compiler.build.spark.data.StructField.getMLPandasSeriesConverterCtor

```text
Generates the PandasSeriesConverter constructor to invoke in
  order to construct the appropriate PandasSeriesConverter MATLAB
  object.

Help for compiler.build.spark.data.StructField/getMLPandasSeriesConverterCtor is inherited from superclass compiler.build.spark.data.DataType
```

#### compiler.build.spark.data.StructField.getPyPandasSeriesConverterCtor

```text
Generates the PandasSeriesConverter constructor to invoke in
  order to construct the appropriate PandasSeriesConverter python
  object.

Help for compiler.build.spark.data.StructField/getPyPandasSeriesConverterCtor is inherited from superclass compiler.build.spark.data.DataType
```

#### compiler.build.spark.data.StructField.isLeaf

```text
isLeaf Returns true for a leaf in the tree
```

### compiler.build.spark.data.StructType

Superclass: compiler.build.spark.data.DataType

```text
StructType Implementation for types in Compiler workflow
```

#### compiler.build.spark.data.StructType.NumFields

```text
compiler.build.spark.data.StructType/NumFields is a function.
    N = NumFields(obj)
```

#### compiler.build.spark.data.StructType.PandasSeriesType

```text
PandasSeriesType The series type to be used in Pandas
```

#### compiler.build.spark.data.StructType.StructType

```text
StructType Implementation for types in Compiler workflow

    Documentation for compiler.build.spark.data.StructType
```

#### compiler.build.spark.data.StructType.UniqueTypeName

```text
UniqueTypeName - A unique name for conversion functions
  This name will simply be the MATLABType for simple types,
  and some convoluted name for complex types.
```

#### compiler.build.spark.data.StructType.addIteratorRow

```text
compiler.build.spark.data.StructType/addIteratorRow is a function.
    codeLines = addIteratorRow(obj, rowSrc)
```

#### compiler.build.spark.data.StructType.array_ML_to_IMML

```text
array_ML_to_IMML - Convert to intermediate MATLAB
```

#### compiler.build.spark.data.StructType.col_IMML_to_IMPY

```text
col_IMML_to_IMPY Convert to python
  Converts from intermediate MATLAB (e.g. matlab.int64([]) to
  intermediate python, e.g. [1,2,3]
```

#### compiler.build.spark.data.StructType.col_IMML_to_ML

```text
col_IMML_to_ML Convert intermediate MATLAB column to MATLAB
  This column should be apt as an argument to the table constructor
```

#### compiler.build.spark.data.StructType.col_IMPY_to_IMML

```text
col_Spark_to_IMPY  Convert Spark to intermediate py
```

#### compiler.build.spark.data.StructType.col_MATLABTable

```text
col_MATLABTable Convert column to MATLAB Table
 
  This is a helper function, that may be needed in case the normal
  MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
  convert everything from python values to MATLAB
```

#### compiler.build.spark.data.StructType.col_ML_to_IMML

```text
col_ML_to_IMML Convert MATLAB column to intermediate value
```

#### compiler.build.spark.data.StructType.col_Spark_to_IMPY

```text
col_Spark_to_IMPY  Convert Spark to intermediate py
```

#### compiler.build.spark.data.StructType.colsIteratorInit

```text
compiler.build.spark.data.StructType/colsIteratorInit is a function.
    strs = colsIteratorInit(obj)
```

#### compiler.build.spark.data.StructType.convertMATLABToIntermediate

```text
convertMATLABToIntermediate Convert MATLAB values to interm.
 
  For some datatypes, an intermediate representation is
  necessary (e.g. timestamps). If no conversion is necessary,
  this just returns the same value
```

#### compiler.build.spark.data.StructType.convertPandaColumnToIntermediate

```text
convertPandaColumnToIntermediate Panda columns to intermediate
 
  For some datatypes, an intermediate representation is
  necessary (e.g. timestamps). If no conversion is necessary,
  this just returns the same value
```

#### compiler.build.spark.data.StructType.convertStructColumn

```text
convertStructColumn Helper for struct columns
 
  A struct column will need its field entries to be cell arrays.
```

#### compiler.build.spark.data.StructType.genPythonExampleFunction

```text
genPythonExampleFunction Example values helper function
 
  This function generates a function that will generate a
  helper value
  This must be overridden.
```

#### compiler.build.spark.data.StructType.getMLPandasSeriesConverterCtor

```text
Generates the PandasSeriesConverter constructor to invoke in
  order to construct the appropriate PandasSeriesConverter MATLAB
  object.

Help for compiler.build.spark.data.StructType/getMLPandasSeriesConverterCtor is inherited from superclass compiler.build.spark.data.DataType
```

#### compiler.build.spark.data.StructType.getPyPandasSeriesConverterCtor

```text
Generates the PandasSeriesConverter constructor to invoke in
  order to construct the appropriate PandasSeriesConverter python
  object.

Help for compiler.build.spark.data.StructType/getPyPandasSeriesConverterCtor is inherited from superclass compiler.build.spark.data.DataType
```

#### compiler.build.spark.data.StructType.instantiateMATLABExampleValue

```text
instantiateMATLABExampleValue Create example value for MATLAB
 
  This method is used to create example files with values
```

#### compiler.build.spark.data.StructType.instantiatePythonExampleValue

```text
instantiatePythonExampleValue Create example value for Python
 
  This method is used to create example files with values
  Many types can use the standard Python conversions (float(),
  str(), etc.), and types with special requirements must
  subclass this method.
```

#### compiler.build.spark.data.StructType.isLeaf

```text
isLeaf Returns true for a leaf in the tree
```

#### compiler.build.spark.data.StructType.table_IMML_to_ML

```text
table_IMML_to_ML Convert one column for a table.
  This function is necessary, to deal with the difficulties of
  handling struct columns, and deeper nesting.
  In most cases, it will just revert to using the
  col_IMML_to_ML, except in the case of StructType
```

#### compiler.build.spark.data.StructType.val_IMML_to_IMPY

```text
val_IMML_to_IMPY  Convert intermediate MATLAB to Pytthon
```

#### compiler.build.spark.data.StructType.val_IMML_to_ML

```text
val_IMML_to_ML Convert an intermediate MATLAB value to MATLAB
```

#### compiler.build.spark.data.StructType.val_IMPY_to_IMML

```text
val_IMPY_to_IMML Convert a value to intermediate MATLAB
```

#### compiler.build.spark.data.StructType.val_IMPY_to_Spark

```text
val_IMPY_to_Spark  Convert intermediate py to Spark
  Converts from intermediate Python (e.g.int) to
  Spark timestamp, e.g. datetime.dateime(123456789)
```

#### compiler.build.spark.data.StructType.val_MATLABTable

```text
val_MATLABTable Convert column value to MATLAB value
 
  This is a helper function, that may be needed in case the normal
  MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
  convert everything from python values to MATLAB
```

#### compiler.build.spark.data.StructType.val_ML_to_IMML

```text
val_ML_to_IMML Convert a value to intermediate MATLAB
```

#### compiler.build.spark.data.StructType.val_Spark_to_IMPY

```text
val_Spark_to_IMPY Convert a value to intermediate MATLAB
```

### compiler.build.spark.data.TimestampNTZType

Superclass: compiler.build.spark.data.DateTimeStampType

```text
TimestampNTZType Implementation for types in Compiler workflow
```

#### compiler.build.spark.data.TimestampNTZType.IntermediaryMATLABType

```text
get.IntermediaryMATLABType
 
  The IntermediaryMATLABType is sometimes used to have as a
  distinction for the real type (e.g. datetime) as opposed to
  the intermediary type (int64 for datetime).
```

#### compiler.build.spark.data.TimestampNTZType.IntermediaryPythonType

```text
get.IntermediaryPythonType
 
  The IntermediaryPythonType is something that is used to check
  for if output is an instance, e.g. int, or a list of ints. In
  most cases, the intermediary type is just the python type,
  but in some cases, there's an intermediary type, which is
  used in python, as a route to MATLAB.
  The Timestamp data type is an example of this, so this method
  must be overridden there.
```

#### compiler.build.spark.data.TimestampNTZType.PandasSeriesType

```text
PandasSeriesType The series type to be used in Pandas
```

#### compiler.build.spark.data.TimestampNTZType.TimestampNTZType

```text
TimestampNTZType Implementation for types in Compiler workflow

    Documentation for compiler.build.spark.data.TimestampNTZType
```

#### compiler.build.spark.data.TimestampNTZType.array_Spark_to_IMPY

```text
array_Spark_to_IMPY Convert an array from Spark to IMPY
 
  This is different from the val_Spark_to_IMPY, because the way
  values can be returned from Spark, e.g. a list or a
  numpy.ndarray.
 
  Returns the name of a function. If the function name is
  empty, no conversion is necessary.
```

#### compiler.build.spark.data.TimestampNTZType.col_IMPY_to_IMML

```text
col_IMPY_to_IMML  Convert Spark to intermediate py
```

#### compiler.build.spark.data.TimestampNTZType.col_MATLABTable

```text
col_MATLABTable Convert column to MATLAB Table
 
  This is a helper function, that may be needed in case the normal
  MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
  convert everything from python values to MATLAB
```

#### compiler.build.spark.data.TimestampNTZType.convertIntermediateToMATLAB

```text
convertIntermediateToMATLAB Intermediate to MATLAB
 
  For some datatypes, an intermediate representation is
  necessary (e.g. timestamps). If no conversion is necessary,
  this just returns the same value
```

#### compiler.build.spark.data.TimestampNTZType.convertMATLABToIntermediate

```text
convertMATLABToIntermediate Convert MATLAB values to interm.
 
  For some datatypes, an intermediate representation is
  necessary (e.g. timestamps). If no conversion is necessary,
  this just returns the same value
```

#### compiler.build.spark.data.TimestampNTZType.genMATLABArray

```text
compiler.build.spark.data.TimestampNTZType/genMATLABArray is a function.
    arrStr = genMATLABArray(obj, N)
```

#### compiler.build.spark.data.TimestampNTZType.genPythonExampleFunction

```text
genPythonExampleFunction Example values helper function
 
  This function generates a function that will generate a
  helper value
  This must be overridden.
```

#### compiler.build.spark.data.TimestampNTZType.getMLPandasSeriesConverterCtor

```text
Generates the PandasSeriesConverter constructor to invoke in
  order to construct the appropriate PandasSeriesConverter MATLAB
  object.

Help for compiler.build.spark.data.TimestampNTZType/getMLPandasSeriesConverterCtor is inherited from superclass compiler.build.spark.data.DataType
```

#### compiler.build.spark.data.TimestampNTZType.getPyPandasSeriesConverterCtor

```text
Generates the PandasSeriesConverter constructor to invoke in
  order to construct the appropriate PandasSeriesConverter python
  object.

Help for compiler.build.spark.data.TimestampNTZType/getPyPandasSeriesConverterCtor is inherited from superclass compiler.build.spark.data.DataType
```

#### compiler.build.spark.data.TimestampNTZType.instantiateColExampleData

```text
instantiateColExampleData Instantiate example data from column
 
  The column, is in general something like an ID column
  (spark.range(N)), and in simple cases is a cast to a
  different type.
```

#### compiler.build.spark.data.TimestampNTZType.instantiateMATLABExampleValue

```text
instantiateMATLABExampleValue Create example value for MATLAB
 
  This method is used to create example files with values
```

#### compiler.build.spark.data.TimestampNTZType.instantiatePythonExampleValue

```text
instantiatePythonExampleValue Create example value for Python
 
  See compiler.build.spark.types.ArgType/instantiatePythonExampleValue
```

#### compiler.build.spark.data.TimestampNTZType.preAllocateMATLABColumn

```text
preAllocateMATLABColumn Preallocate column data
 
  This may be a simple zeros column for numeric types, or a
  cell array for array types.
  The argument N_str is a string describing the size of the
  column
```

#### compiler.build.spark.data.TimestampNTZType.val_IMML_to_ML

```text
val_IMML_to_ML Convert a value from intermediate MATLAB
```

#### compiler.build.spark.data.TimestampNTZType.val_IMPY_to_IMML

```text
val_IMPY_to_IMML Convert a value to intermediate MATLAB
```

#### compiler.build.spark.data.TimestampNTZType.val_IMPY_to_Spark

```text
val_IMPY_to_Spark  Convert intermediate py to Spark
  Converts from intermediate Python (e.g.int) to
  Spark timestamp, e.g. datetime.dateime(123456789)
```

#### compiler.build.spark.data.TimestampNTZType.val_MATLABTable

```text
val_MATLABTable Convert column value to MATLAB value
 
  This is a helper function, that may be needed in case the normal
  MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
  convert everything from python values to MATLAB
```

#### compiler.build.spark.data.TimestampNTZType.val_ML_to_IMML

```text
val_ML_to_IMML Convert a value to intermediate MATLAB
```

#### compiler.build.spark.data.TimestampNTZType.val_Spark_to_IMPY

```text
val_Spark_to_IMPY Convert a value to intermediate MATLAB
```

### compiler.build.spark.data.TimestampType

Superclass: compiler.build.spark.data.DateTimeStampType

```text
TimestampType Implementation for types in Compiler workflow
```

#### compiler.build.spark.data.TimestampType.IntermediaryMATLABType

```text
get.IntermediaryMATLABType
 
  The IntermediaryMATLABType is sometimes used to have as a
  distinction for the real type (e.g. datetime) as opposed to
  the intermediary type (int64 for datetime).
```

#### compiler.build.spark.data.TimestampType.IntermediaryPythonType

```text
get.IntermediaryPythonType
 
  The IntermediaryPythonType is something that is used to check
  for if output is an instance, e.g. int, or a list of ints. In
  most cases, the intermediary type is just the python type,
  but in some cases, there's an intermediary type, which is
  used in python, as a route to MATLAB.
  The Timestamp data type is an example of this, so this method
  must be overridden there.
```

#### compiler.build.spark.data.TimestampType.PandasSeriesType

```text
PandasSeriesType The series type to be used in Pandas
```

#### compiler.build.spark.data.TimestampType.TimestampType

```text
TimestampType Implementation for types in Compiler workflow

    Documentation for compiler.build.spark.data.TimestampType
```

#### compiler.build.spark.data.TimestampType.array_Spark_to_IMPY

```text
array_Spark_to_IMPY Convert an array from Spark to IMPY
 
  This is different from the val_Spark_to_IMPY, because the way
  values can be returned from Spark, e.g. a list or a
  numpy.ndarray.
 
  Returns the name of a function. If the function name is
  empty, no conversion is necessary.
```

#### compiler.build.spark.data.TimestampType.col_MATLABTable

```text
col_MATLABTable Convert column to MATLAB Table
 
  This is a helper function, that may be needed in case the normal
  MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
  convert everything from python values to MATLAB
```

#### compiler.build.spark.data.TimestampType.convertIntermediateToMATLAB

```text
convertIntermediateToMATLAB Intermediate to MATLAB
 
  For some datatypes, an intermediate representation is
  necessary (e.g. timestamps). If no conversion is necessary,
  this just returns the same value
```

#### compiler.build.spark.data.TimestampType.convertMATLABToIntermediate

```text
convertMATLABToIntermediate Convert MATLAB values to interm.
 
  For some datatypes, an intermediate representation is
  necessary (e.g. timestamps). If no conversion is necessary,
  this just returns the same value
```

#### compiler.build.spark.data.TimestampType.genMATLABArray

```text
compiler.build.spark.data.TimestampType/genMATLABArray is a function.
    arrStr = genMATLABArray(obj, N)
```

#### compiler.build.spark.data.TimestampType.genPythonExampleFunction

```text
genPythonExampleFunction Example values helper function
 
  This function generates a function that will generate a
  helper value
  This must be overridden.
```

#### compiler.build.spark.data.TimestampType.getMLPandasSeriesConverterCtor

```text
Generates the PandasSeriesConverter constructor to invoke in
  order to construct the appropriate PandasSeriesConverter MATLAB
  object.

Help for compiler.build.spark.data.TimestampType/getMLPandasSeriesConverterCtor is inherited from superclass compiler.build.spark.data.DataType
```

#### compiler.build.spark.data.TimestampType.getPyPandasSeriesConverterCtor

```text
Generates the PandasSeriesConverter constructor to invoke in
  order to construct the appropriate PandasSeriesConverter python
  object.

Help for compiler.build.spark.data.TimestampType/getPyPandasSeriesConverterCtor is inherited from superclass compiler.build.spark.data.DataType
```

#### compiler.build.spark.data.TimestampType.instantiateColExampleData

```text
instantiateColExampleData Instantiate example data from column
 
  The column, is in general something like an ID column
  (spark.range(N)), and in simple cases is a cast to a
  different type.
```

#### compiler.build.spark.data.TimestampType.instantiateMATLABExampleValue

```text
instantiateMATLABExampleValue Create example value for MATLAB
 
  This method is used to create example files with values
```

#### compiler.build.spark.data.TimestampType.instantiatePythonExampleValue

```text
instantiatePythonExampleValue Create example value for Python
 
  See compiler.build.spark.types.ArgType/instantiatePythonExampleValue
```

#### compiler.build.spark.data.TimestampType.preAllocateMATLABColumn

```text
preAllocateMATLABColumn Preallocate column data
 
  This may be a simple zeros column for numeric types, or a
  cell array for array types.
  The argument N_str is a string describing the size of the
  column
```

#### compiler.build.spark.data.TimestampType.val_IMML_to_ML

```text
val_IMML_to_ML Convert a value from intermediate MATLAB
```

#### compiler.build.spark.data.TimestampType.val_IMPY_to_Spark

```text
val_IMPY_to_Spark  Convert intermediate py to Spark
  Converts from intermediate Python (e.g.int) to
  Spark timestamp, e.g. datetime.dateime(123456789)
```

#### compiler.build.spark.data.TimestampType.val_MATLABTable

```text
val_MATLABTable Convert column value to MATLAB value
 
  This is a helper function, that may be needed in case the normal
  MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
  convert everything from python values to MATLAB
```

#### compiler.build.spark.data.TimestampType.val_ML_to_IMML

```text
val_ML_to_IMML Convert a value to intermediate MATLAB
```

#### compiler.build.spark.data.TimestampType.val_Spark_to_IMPY

```text
val_Spark_to_IMPY Convert a value to intermediate MATLAB
```

### compiler.build.spark.data.fromSchema

```text
fromSchema Create Data from Schema
```

### compiler.build.spark.internal

### compiler.build.spark.internal.calcDigest

```text
calcDigest Internal function for calculating digest of string
```

### compiler.build.spark.internal.getArgNames

```text
getArgNames Return arg names of a function
 
  This function is only used internally, and the methods use here are
  only for internal use and liable to change.
```

### compiler.build.spark.internal.getFcnFileName

```text
getFcnFileName Get information from a function/file
 
  This is a helper function to disambiguate parts of a
  function/filename/functionHandle. 
  In particular, it will help with user functions that take the name of
  a function, or its file name. It can sometimes be unclear, as when
  calling the compiler, if the function name or the file name should be
  used. This takes one of both, and returns all information in a
  consistent structure.
```

### compiler.build.spark.internal.getJSONName

```text
getJSONName Get the JSON name for a helper file
```

### compiler.build.spark.internal.getSchemaName

```text
getSchemaName Get the Schema name for a file/function
```

### compiler.build.spark.internal.hasMWStringArray

```text
hasMWStringArray Returns true if release support MWStringArray
 
  This is an internal function, and not part of the API.
```

### compiler.build.spark.internal.rowOutputsToTable

```text
rowOutputsToTable Internal helper function.
 
  This is an internal function, and not part of the API.
```

### compiler.build.spark.internal.shortenIdentifier

```text
shortenIdentifier Shorten identifier if necessary
```

### compiler.build.spark.internal.tableDebugInfo

```text
tableDebugInfo Output some table info for debugging/metrics
 
  Outputs some info on a table, mainly to see size.
 
  T is the table
  infoStr some info for better understanding context
```

### compiler.build.spark.internal.tableToColumnInputs

```text
tableToColumnInputs Internal helper function.
 
  This is an internal function, and not part of the API.
```

### compiler.build.spark.internal.tableToRowInputs

```text
tableToRowInputs Internal helper function.
 
  This is an internal function, and not part of the API.
```

### compiler.build.spark.schema

### compiler.build.spark.schema.mathworks

### compiler.build.spark.schema.mathworks.CommonBase

Superclass: handle

```text
CommonBase - Abstract helper class
 
  This class serves as a common base for DataType and StructField. There are common operations
  and properties (Parent), that makes this useful.
```

#### compiler.build.spark.schema.mathworks.CommonBase.CommonBase

```text
CommonBase - Abstract helper class
 
  This class serves as a common base for DataType and StructField. There are common operations
  and properties (Parent), that makes this useful.

    Documentation for compiler.build.spark.schema.mathworks.CommonBase
```

#### compiler.build.spark.schema.mathworks.CommonBase.classFromType

```text
compiler.build.spark.schema.mathworks.CommonBase.classFromType is a function.
    clazz = compiler.build.spark.schema.mathworks.CommonBase.classFromType(val)
```

#### compiler.build.spark.schema.mathworks.CommonBase.fromVal

```text
fromVal Initialize an object from JSON/struct
 
  In the most basic cases, like IntegerTypes, this does
  nothing.
```

#### compiler.build.spark.schema.mathworks.CommonBase.instanceFromVal

```text
compiler.build.spark.schema.mathworks.CommonBase.instanceFromVal is a function.
    obj = compiler.build.spark.schema.mathworks.CommonBase.instanceFromVal(val)
```

#### compiler.build.spark.schema.mathworks.CommonBase.json

```text
compiler.build.spark.schema.mathworks.CommonBase/json is a function.
    str = json(obj, options)
```

#### compiler.build.spark.schema.mathworks.CommonBase.load

```text
load - variables from file into workspace

    <strong>Syntax</strong>
      load(filename)
      load(filename,variables)
      load(filename,"-ascii")
      load(filename,"-mat")
      load(filename,"-mat",variables)

      S = load(___)

      load filename

    <strong>Input Arguments</strong>
      <a href="matlab:web /usr/local/MATLAB/R2026a/help/matlab/ref/load.html#btm0etn-1-filename">filename</a> - Name of file
        "matlab.mat" (default) | string scalar | character vector
      <a href="matlab:web /usr/local/MATLAB/R2026a/help/matlab/ref/load.html#btm0etn-1-variables">variables</a> - Names of variables to load
        string scalar | character vector

    <strong>Examples</strong>
      <a href="matlab:openExample('matlab/LoadAllVariablesFromMATFileExample')">Load All Variables from MAT File</a>
      <a href="matlab:openExample('matlab/LoadSpecificVariableFromMATFileExample')">Load Specific Variable from MAT File</a>
      <a href="matlab:openExample('matlab/UseRegularExpressionsToLoadSpecificVariablesExample')">Use Regular Expressions to Load Specific Variables</a>
      <a href="matlab:openExample('matlab/LoadListofVariablesintoStructureArrayExample')">Load List of Variables into Structure Array</a>
      <a href="matlab:openExample('matlab/LoadASCIIFileExample')">Load ASCII File</a>

    <strong>See also</strong> <a href="matlab:help clear -displayBanner">clear</a>, <a href="matlab:help importdata -displayBanner">importdata</a>, <a href="matlab:help matfile -displayBanner">matfile</a>, <a href="matlab:help regexp -displayBanner">regexp</a>, <a href="matlab:help save -displayBanner">save</a>, <a href="matlab:help whos -displayBanner">whos</a>, <a href="matlab:help('Import Tool', '-displayBanner')">Import Tool</a>

    Introduced in MATLAB before R2006a
    <a href="matlab:doc load">Documentation for load</a>
```

#### compiler.build.spark.schema.mathworks.CommonBase.toStruct

```text
toStruct Create struct object suitable for JSON conversion
  Default implementation for atomic types is a string of the type
```

### compiler.build.spark.schema.mathworks.CompilerType

Superclass: compiler.build.spark.schema.mathworks.NonSparkType

```text
Copyright 2024 The MathWorks, Inc.
```

#### compiler.build.spark.schema.mathworks.CompilerType.CompilerType

```text
Copyright 2024 The MathWorks, Inc.

    Documentation for compiler.build.spark.schema.mathworks.CompilerType
```

#### compiler.build.spark.schema.mathworks.CompilerType.addInput

```text
compiler.build.spark.schema.mathworks.CompilerType/addInput is a function.
    addInput(obj, name, type, isTable)
```

#### compiler.build.spark.schema.mathworks.CompilerType.addOutput

```text
compiler.build.spark.schema.mathworks.CompilerType/addOutput is a function.
    addOutput(obj, name, type, isTable)
```

#### compiler.build.spark.schema.mathworks.CompilerType.checkTypeCompliance

```text
compiler.build.spark.schema.mathworks.CompilerType/checkTypeCompliance is a function.
    checkTypeCompliance(CT)
```

#### compiler.build.spark.schema.mathworks.CompilerType.fromVal

```text
fromVal Initialize an object from JSON/struct
 
  In the most basic cases, like IntegerTypes, this does
  nothing.

Help for compiler.build.spark.schema.mathworks.CompilerType/fromVal is inherited from superclass compiler.build.spark.schema.mathworks.CommonBase
```

#### compiler.build.spark.schema.mathworks.CompilerType.init

```text
compiler.build.spark.schema.mathworks.CompilerType/init is a function.
    init(obj)
```

#### compiler.build.spark.schema.mathworks.CompilerType.toStruct

```text
toStruct Create struct object suitable for JSON conversion
  Default implementation for atomic types is a string of the type
```

### compiler.build.spark.schema.mathworks.DHMSInterval

Superclass: uint32

```text
DHMSInterval Interval enumerations
  
  Used by DayTimeIntervalType schema type
```

```text
Enumeration values:
  DAY
  HOUR
  MINUTE
  SECOND

```

#### compiler.build.spark.schema.mathworks.DHMSInterval.DHMSInterval

```text
DHMSInterval Interval enumerations
  
  Used by DayTimeIntervalType schema type

    Documentation for compiler.build.spark.schema.mathworks.DHMSInterval
```

### compiler.build.spark.schema.mathworks.IOType

Superclass: compiler.build.spark.schema.mathworks.NonSparkType

```text
IOType part of the Schema definitions
 
  Due to the fact that certain classes, not part of the Spark schemas, are 
  needed to define certain aspects (file/function, inputs/outputs). this
  class was created.
  This class represents an Input or an Output
```

#### compiler.build.spark.schema.mathworks.IOType.IOType

```text
IOType part of the Schema definitions
 
  Due to the fact that certain classes, not part of the Spark schemas, are 
  needed to define certain aspects (file/function, inputs/outputs). this
  class was created.
  This class represents an Input or an Output

    Documentation for compiler.build.spark.schema.mathworks.IOType
```

#### compiler.build.spark.schema.mathworks.IOType.fromVal

```text
fromVal Initialize an object from JSON/struct
 
  In the most basic cases, like IntegerTypes, this does
  nothing.

Help for compiler.build.spark.schema.mathworks.IOType/fromVal is inherited from superclass compiler.build.spark.schema.mathworks.CommonBase
```

#### compiler.build.spark.schema.mathworks.IOType.init3_4

```text
compiler.build.spark.schema.mathworks.IOType/init3_4 is a function.
    init3_4(obj, name, direction, type_, isTable)
```

#### compiler.build.spark.schema.mathworks.IOType.pythonInitCode

```text
pythonInitCode Return python init code
  This will be something like LongType() for atomic types. For
  compound types, this method must be overridden.
 
  This is usually existent only for DataType classes and its
  children. This is used as a helper for cases where scalar
  inputs are being used.
 
  It should be called directly with an IOType array
```

#### compiler.build.spark.schema.mathworks.IOType.toStruct

```text
toStruct Create struct object suitable for JSON conversion
  Default implementation for atomic types is a string of the type

Help for compiler.build.spark.schema.mathworks.IOType/toStruct is inherited from superclass compiler.build.spark.schema.mathworks.CommonBase
```

### compiler.build.spark.schema.mathworks.NonSparkType

Superclass: compiler.build.spark.schema.mathworks.CommonBase

```text
NonSparkType Abstract class, part of the Schema definitions
 
  Due to the fact that certain classes, not part of the Spark schemas, are 
  needed to define certain aspects (file/function, inputs/outputs). this
  class was created.
```

#### compiler.build.spark.schema.mathworks.NonSparkType.NonSparkType

```text
NonSparkType Abstract class, part of the Schema definitions
 
  Due to the fact that certain classes, not part of the Spark schemas, are 
  needed to define certain aspects (file/function, inputs/outputs). this
  class was created.

    Documentation for compiler.build.spark.schema.mathworks.NonSparkType
```

### compiler.build.spark.schema.mathworks.generateFunctionSchema

```text
generateFunctionSchema Generate schema file for a function
 
  This function creates a schema file that provides the SparkBuilder
  with additional information when compiling functions that should run
  on Spark clusters.
 
  Required arguments:
        funcName : The name of the function or the file
              IN : A cell array of arguments for the function
 
  Optional argument:
             OUT : A cell array of return values for the function
 
  Optional named argument:
         verbose : Logical flag to enable verbose output, default: false
 
 
  By default automatically create a .schema file in the same location as the
  function, but with the ending ".schema" instead of ".m".
 
  The function returns a string with the path of schema file.
  This is generally not required.
 
  Examples:
    % Importing the function, to make examples shorter
    import compiler.build.spark.schema.mathworks.generateFunctionSchema
 
    % A function that takes 3 scalar double values, and returns two
    % double scalars:
    generateFunctionSchema('simplecalc', {3, 4, 5}, {1, 2});
 
    % The same schema can be generated by simply omitting the output
    % values. In this case, the function will simply call the actual
    % function with the input values provided, and use the results of this
    % as the OUT argument.
    generateFunctionSchema('simplecalc', {3, 4, 5});
 
    % A function that takes a table and a scalar, and returns another table
    generateFunctionSchema('gaussianFilter', {T_in, 4});
```

### compiler.build.spark.schema.AnsiIntervalType

Superclass: compiler.build.spark.schema.AtomicType

```text
AnsiIntervalType Spark schema types
```

#### compiler.build.spark.schema.AnsiIntervalType.AnsiIntervalType

```text
AnsiIntervalType Spark schema types

    Documentation for compiler.build.spark.schema.AnsiIntervalType
```

### compiler.build.spark.schema.ArrayType

Superclass: compiler.build.spark.schema.DataType

```text
ArrayType Structure class for Spark schema types
```

#### compiler.build.spark.schema.ArrayType.ArrayType

```text
ArrayType Structure class for Spark schema types

    Documentation for compiler.build.spark.schema.ArrayType
```

#### compiler.build.spark.schema.ArrayType.fromVal

```text
fromVal Initialize an object from JSON/struct
 
  In the most basic cases, like IntegerTypes, this does
  nothing.

Help for compiler.build.spark.schema.ArrayType/fromVal is inherited from superclass compiler.build.spark.schema.mathworks.CommonBase
```

#### compiler.build.spark.schema.ArrayType.getPythonImports

```text
getPythonImports Return imports for types
```

#### compiler.build.spark.schema.ArrayType.pythonInitCode

```text
pythonInitCode Return python init code
  This will be something like LongType() for atomic types. For
  compound types, this method must be overridden.
```

#### compiler.build.spark.schema.ArrayType.pythonSchemaType

```text
pythonSchemaType Return schema type
  Base case is just the type name. Override if necessary
```

#### compiler.build.spark.schema.ArrayType.toStruct

```text
toStruct Create struct object suitable for JSON conversion
  Default implementation for atomic types is a string of the type
```

### compiler.build.spark.schema.AtomicType

Superclass: compiler.build.spark.schema.DataType

```text
AtomicType Spark schema types
```

#### compiler.build.spark.schema.AtomicType.AtomicType

```text
AtomicType Spark schema types

    Documentation for compiler.build.spark.schema.AtomicType
```

### compiler.build.spark.schema.BinaryType

Superclass: compiler.build.spark.schema.AtomicType

```text
BinaryType Spark schema types
```

#### compiler.build.spark.schema.BinaryType.BinaryType

```text
BinaryType Spark schema types

    Documentation for compiler.build.spark.schema.BinaryType
```

### compiler.build.spark.schema.BooleanType

Superclass: compiler.build.spark.schema.AtomicType

```text
BooleanType Spark schema types
```

#### compiler.build.spark.schema.BooleanType.BooleanType

```text
BooleanType Spark schema types

    Documentation for compiler.build.spark.schema.BooleanType
```

### compiler.build.spark.schema.ByteType

Superclass: compiler.build.spark.schema.IntegralType

```text
ByteType Spark schema types
```

#### compiler.build.spark.schema.ByteType.ByteType

```text
ByteType Spark schema types

    Documentation for compiler.build.spark.schema.ByteType
```

### compiler.build.spark.schema.DataType

Superclasses: compiler.build.spark.schema.mathworks.CommonBase, matlab.mixin.Heterogeneous

```text
DataType Abstract base class for Spark schema types
```

#### compiler.build.spark.schema.DataType.DataType

```text
DataType Abstract base class for Spark schema types

    Documentation for compiler.build.spark.schema.DataType
```

#### compiler.build.spark.schema.DataType.arrayToSchema_col

```text
compiler.build.spark.schema.DataType.arrayToSchema_col is a function.
    S = compiler.build.spark.schema.DataType.arrayToSchema_col(ARR)
```

#### compiler.build.spark.schema.DataType.createSchema

```text
schema Create a Spark Schema from other input
 
  The input could be a python object (pyspark.sql.types.*) or a JSON
  file (*.schema). Other options may be added.
```

#### compiler.build.spark.schema.DataType.getClassTS

```text
getClassTS Return class, but handle timestamps/date
  explicitly
```

#### compiler.build.spark.schema.DataType.getPythonImports

```text
getPythonImports Return imports for types
```

#### compiler.build.spark.schema.DataType.getSparkType

```text
Return the SparkType, that can be used in e.g. UDF definitions
  Can be deduced in many cases. Exceptions should be overridden in
  their classes.
```

#### compiler.build.spark.schema.DataType.matlabClassToSchema

```text
compiler.build.spark.schema.DataType.matlabClassToSchema is a function.
    S = compiler.build.spark.schema.DataType.matlabClassToSchema(val, clazz)
```

#### compiler.build.spark.schema.DataType.matlabClassToSchema_col

```text
compiler.build.spark.schema.DataType.matlabClassToSchema_col is a function.
    S = compiler.build.spark.schema.DataType.matlabClassToSchema_col(val, clazz, options)
```

#### compiler.build.spark.schema.DataType.matlabValueToSchema

```text
compiler.build.spark.schema.DataType.matlabValueToSchema is a function.
    S = compiler.build.spark.schema.DataType.matlabValueToSchema(T)
```

#### compiler.build.spark.schema.DataType.pyTF

```text
compiler.build.spark.schema.DataType/pyTF is a function.
    tf = pyTF(~, val)
```

#### compiler.build.spark.schema.DataType.pyTypeToSchema

```text
compiler.build.spark.schema.DataType.pyTypeToSchema is a function.
    S = compiler.build.spark.schema.DataType.pyTypeToSchema(T)
```

#### compiler.build.spark.schema.DataType.pythonInitCode

```text
pythonInitCode Return python init code
  This will be something like LongType() for atomic types. For
  compound types, this method must be overridden.
```

#### compiler.build.spark.schema.DataType.pythonSchemaType

```text
pythonSchemaType Return schema type
  Base case is just the type name. Override if necessary
```

#### compiler.build.spark.schema.DataType.pythonType

```text
compiler.build.spark.schema.DataType/pythonType is a function.
    PT = pythonType(obj)
```

#### compiler.build.spark.schema.DataType.structToSchema

```text
compiler.build.spark.schema.DataType.structToSchema is a function.
    S = compiler.build.spark.schema.DataType.structToSchema(ST)
```

#### compiler.build.spark.schema.DataType.structToSchema_col

```text
compiler.build.spark.schema.DataType.structToSchema_col is a function.
    S = compiler.build.spark.schema.DataType.structToSchema_col(ST)
```

#### compiler.build.spark.schema.DataType.tableColumnToSchema

```text
compiler.build.spark.schema.DataType.tableColumnToSchema is a function.
    S = compiler.build.spark.schema.DataType.tableColumnToSchema(TC)
```

#### compiler.build.spark.schema.DataType.tableColumnToSchema_old

```text
compiler.build.spark.schema.DataType.tableColumnToSchema_old is a function.
    S = compiler.build.spark.schema.DataType.tableColumnToSchema_old(TC)
```

#### compiler.build.spark.schema.DataType.tableToSchema

```text
compiler.build.spark.schema.DataType.tableToSchema is a function.
    S = compiler.build.spark.schema.DataType.tableToSchema(T)
```

### compiler.build.spark.schema.DateType

Superclass: compiler.build.spark.schema.AtomicType

```text
DateType Spark schema types
```

#### compiler.build.spark.schema.DateType.DateType

```text
DateType Spark schema types

    Documentation for compiler.build.spark.schema.DateType
```

### compiler.build.spark.schema.DayTimeIntervalType

Superclass: compiler.build.spark.schema.AnsiIntervalType

```text
DayTimeIntervalType Spark schema types
```

#### compiler.build.spark.schema.DayTimeIntervalType.DayTimeIntervalType

```text
DayTimeIntervalType Spark schema types

    Documentation for compiler.build.spark.schema.DayTimeIntervalType
```

#### compiler.build.spark.schema.DayTimeIntervalType.pythonInitCode

```text
pythonInitCode Return python init code
  This will be something like LongType() for atomic types. For
  compound types, this method must be overridden.
```

#### compiler.build.spark.schema.DayTimeIntervalType.pythonSchemaType

```text
pythonSchemaType Return schema type
  Base case is just the type name. Override if necessary
  str = sprintf("%s %s to %s", obj.type, intervalToString(obj.startField), intervalToString(obj.endField));
```

#### compiler.build.spark.schema.DayTimeIntervalType.toStruct

```text
toStruct Create struct object suitable for JSON conversion
  Default implementation for atomic types is a string of the type
```

### compiler.build.spark.schema.DecimalType

Superclass: compiler.build.spark.schema.FractionalType

```text
DecimalType Spark schema types
```

#### compiler.build.spark.schema.DecimalType.DecimalType

```text
DecimalType Spark schema types

    Documentation for compiler.build.spark.schema.DecimalType
```

#### compiler.build.spark.schema.DecimalType.pythonInitCode

```text
pythonInitCode Return python init code
  This will be something like LongType() for atomic types. For
  compound types, this method must be overridden.
```

#### compiler.build.spark.schema.DecimalType.pythonSchemaType

```text
pythonSchemaType Return schema type
  Base case is just the type name. Override if necessary
```

#### compiler.build.spark.schema.DecimalType.toStruct

```text
toStruct Create struct object suitable for JSON conversion
  Default implementation for atomic types is a string of the type
```

### compiler.build.spark.schema.DoubleType

Superclass: compiler.build.spark.schema.FractionalType

```text
DoubleType Spark schema types
```

#### compiler.build.spark.schema.DoubleType.DoubleType

```text
DoubleType Spark schema types

    Documentation for compiler.build.spark.schema.DoubleType
```

### compiler.build.spark.schema.FloatType

Superclass: compiler.build.spark.schema.FractionalType

```text
FloatType Spark schema types
```

#### compiler.build.spark.schema.FloatType.FloatType

```text
FloatType Spark schema types

    Documentation for compiler.build.spark.schema.FloatType
```

### compiler.build.spark.schema.FractionalType

Superclass: compiler.build.spark.schema.NumericType

```text
FractionalType Spark schema types
```

#### compiler.build.spark.schema.FractionalType.FractionalType

```text
FractionalType Spark schema types

    Documentation for compiler.build.spark.schema.FractionalType
```

### compiler.build.spark.schema.IntegerType

Superclass: compiler.build.spark.schema.IntegralType

```text
IntegerType Spark schema types
```

#### compiler.build.spark.schema.IntegerType.IntegerType

```text
IntegerType Spark schema types

    Documentation for compiler.build.spark.schema.IntegerType
```

### compiler.build.spark.schema.IntegralType

Superclass: compiler.build.spark.schema.NumericType

```text
IntegralType Spark schema types
```

#### compiler.build.spark.schema.IntegralType.IntegralType

```text
IntegralType Spark schema types

    Documentation for compiler.build.spark.schema.IntegralType
```

### compiler.build.spark.schema.LongType

Superclass: compiler.build.spark.schema.IntegralType

```text
LongType Spark schema types
```

#### compiler.build.spark.schema.LongType.LongType

```text
LongType Spark schema types

    Documentation for compiler.build.spark.schema.LongType
```

#### compiler.build.spark.schema.LongType.pythonSchemaType

```text
pythonSchemaType Return schema type
  Base case is just the type name. Override if necessary
```

### compiler.build.spark.schema.MapType

Superclass: compiler.build.spark.schema.DataType

```text
MapType Map class for Spark schema types
```

#### compiler.build.spark.schema.MapType.MapType

```text
MapType Map class for Spark schema types

    Documentation for compiler.build.spark.schema.MapType
```

#### compiler.build.spark.schema.MapType.fromVal

```text
fromVal Initialize an object from JSON/struct
 
  In the most basic cases, like IntegerTypes, this does
  nothing.

Help for compiler.build.spark.schema.MapType/fromVal is inherited from superclass compiler.build.spark.schema.mathworks.CommonBase
```

#### compiler.build.spark.schema.MapType.getPythonImports

```text
getPythonImports Return imports for types
```

#### compiler.build.spark.schema.MapType.pythonInitCode

```text
pythonInitCode Return python init code
  This will be something like LongType() for atomic types. For
  compound types, this method must be overridden.
```

#### compiler.build.spark.schema.MapType.pythonSchemaType

```text
pythonSchemaType Return schema type
  Base case is just the type name. Override if necessary
```

#### compiler.build.spark.schema.MapType.toStruct

```text
toStruct Create struct object suitable for JSON conversion
  Default implementation for atomic types is a string of the type
```

### compiler.build.spark.schema.NumericType

Superclass: compiler.build.spark.schema.AtomicType

```text
NumericType Spark schema types
```

#### compiler.build.spark.schema.NumericType.NumericType

```text
NumericType Spark schema types

    Documentation for compiler.build.spark.schema.NumericType
```

### compiler.build.spark.schema.ShortType

Superclass: compiler.build.spark.schema.IntegralType

```text
ShortType Spark schema types
```

#### compiler.build.spark.schema.ShortType.ShortType

```text
ShortType Spark schema types

    Documentation for compiler.build.spark.schema.ShortType
```

### compiler.build.spark.schema.StringType

Superclass: compiler.build.spark.schema.AtomicType

```text
StringType Spark schema types
```

#### compiler.build.spark.schema.StringType.StringType

```text
StringType Spark schema types

    Documentation for compiler.build.spark.schema.StringType
```

### compiler.build.spark.schema.StructField

Superclass: compiler.build.spark.schema.DataType

```text
StructField Spark schema types
```

#### compiler.build.spark.schema.StructField.StructField

```text
StructField Spark schema types

    Documentation for compiler.build.spark.schema.StructField
```

#### compiler.build.spark.schema.StructField.initSeparateFields

```text
compiler.build.spark.schema.StructField/initSeparateFields is a function.
    initSeparateFields(obj, name, datatype, nullable, options)
```

#### compiler.build.spark.schema.StructField.initStructField

```text
compiler.build.spark.schema.StructField/initStructField is a function.
    initStructField(obj, PF)
```

#### compiler.build.spark.schema.StructField.pythonInitCode

```text
pythonInitCode Return python init code
  This will be something like LongType() for atomic types. For
  compound types, this method must be overridden.
```

#### compiler.build.spark.schema.StructField.toStruct

```text
toStruct Create struct object suitable for JSON conversion
  Default implementation for atomic types is a string of the type
```

### compiler.build.spark.schema.StructType

Superclass: compiler.build.spark.schema.DataType

```text
StructType Structure class for Spark schema types
```

#### compiler.build.spark.schema.StructType.StructType

```text
StructType Structure class for Spark schema types

    Documentation for compiler.build.spark.schema.StructType
```

#### compiler.build.spark.schema.StructType.add

```text
compiler.build.spark.schema.StructType/add is a function.
    st = add(st, fieldName, datatype, options)
```

#### compiler.build.spark.schema.StructType.fromVal

```text
fromVal Initialize an object from JSON/struct
 
  In the most basic cases, like IntegerTypes, this does
  nothing.

Help for compiler.build.spark.schema.StructType/fromVal is inherited from superclass compiler.build.spark.schema.mathworks.CommonBase
```

#### compiler.build.spark.schema.StructType.pythonInitCode

```text
pythonInitCode Return python init code
  This will be something like LongType() for atomic types. For
  compound types, this method must be overridden.
```

#### compiler.build.spark.schema.StructType.pythonSchemaType

```text
pythonSchemaType Return schema type
  Base case is just the type name. Override if necessary
```

#### compiler.build.spark.schema.StructType.toStruct

```text
toStruct Create struct object suitable for JSON conversion
  Default implementation for atomic types is a string of the type
```

### compiler.build.spark.schema.TimestampNTZType

Superclass: compiler.build.spark.schema.AtomicType

```text
TimestampNTZType Spark schema types
```

#### compiler.build.spark.schema.TimestampNTZType.TimestampNTZType

```text
TimestampNTZType Spark schema types

    Documentation for compiler.build.spark.schema.TimestampNTZType
```

### compiler.build.spark.schema.TimestampType

Superclass: compiler.build.spark.schema.AtomicType

```text
TimestampType Spark schema types
```

#### compiler.build.spark.schema.TimestampType.TimestampType

```text
TimestampType Spark schema types

    Documentation for compiler.build.spark.schema.TimestampType
```

### compiler.build.spark.transformers

### compiler.build.spark.transformers.PandasTransformer

Superclass: compiler.build.spark.transformers.PythonTransformer

```text
compiler.build.spark.transformers.PandasTransformer is a class.
    obj = compiler.build.spark.transformers.PandasTransformer(varargin)
```

#### compiler.build.spark.transformers.PandasTransformer.PandasTransformer

```text
compiler.build.spark.transformers.PandasTransformer/PandasTransformer is a constructor.
    obj = PandasTransformer(varargin)

    Documentation for compiler.build.spark.transformers.PandasTransformer
```

#### compiler.build.spark.transformers.PandasTransformer.generate

```text
compiler.build.spark.transformers.PandasTransformer/generate is a function.
    generate(obj)
```

### compiler.build.spark.transformers.PythonTransformer

Superclass: compiler.build.spark.transformers.Transformer

```text
compiler.build.spark.transformers.PythonTransformer is a class.
    obj = compiler.build.spark.transformers.PythonTransformer(varargin)
```

#### compiler.build.spark.transformers.PythonTransformer.PythonTransformer

```text
compiler.build.spark.transformers.PythonTransformer/PythonTransformer is a constructor.
    obj = PythonTransformer(varargin)

    Documentation for compiler.build.spark.transformers.PythonTransformer
```

### compiler.build.spark.transformers.Transformer

Superclass: handle

```text
compiler.build.spark.transformers.Transformer is a class.
    obj = compiler.build.spark.transformers.Transformer(file)
```

#### compiler.build.spark.transformers.Transformer.Transformer

```text
compiler.build.spark.transformers.Transformer/Transformer is a constructor.
    obj = Transformer(file)

    Documentation for compiler.build.spark.transformers.Transformer
```

### compiler.build.spark.types

### compiler.build.spark.types.ArgType

Superclasses: handle, matlab.mixin.Heterogeneous

```text
ArgType Base class for argument types
 
  Subclasses are instances of specific data types, e.g. Double, Float,
  Boolean, etc. The names of the Subclasses will coincide with the Java
  type names.
  Compound types may be be subclassed too, or simlpy created by virtue
  of being an array.
```

#### compiler.build.spark.types.ArgType.ArgType

```text
ArgType Base class for argument types
 
  Subclasses are instances of specific data types, e.g. Double, Float,
  Boolean, etc. The names of the Subclasses will coincide with the Java
  type names.
  Compound types may be be subclassed too, or simlpy created by virtue
  of being an array.

    Documentation for compiler.build.spark.types.ArgType
```

#### compiler.build.spark.types.ArgType.castLongColumnToValue

```text
castLongColumnToValue Convert a long to a value of this type
  This function is used for creating example code.
  It will be subclassed in types with more complex conversions.
  It assumes that the input is a Spark Column with type long
```

#### compiler.build.spark.types.ArgType.convertExternalToIntermediate

```text
convertExternalToIntermediate To intermediate representation
 
  For some datatypes, an intermediate representation is
  necessary (e.g. timestamps). If no conversion is necessary,
  this just returns the same value
```

#### compiler.build.spark.types.ArgType.convertIntermediateColumnForRuntime

```text
convertIntermediateColumnForRuntime Convert columns
 
  A column in intermediate representation will be a list of values.
  This will be converted to a cell array in MATLAB. This is an
  unnecessary step, in case the contents of a column are scalars. In
  these cases, a conversion should be done.
```

#### compiler.build.spark.types.ArgType.convertIntermediateMWColumnToExternal

```text
convertIntermediateMWColumnToExternal Convert MW Column to external type
 
  Functions like x_mapPartitions will return the columns of a specific
  table. These columns must be converted to an array of rows for the
  external platform, which can then be changed to an iterator.
  This is a general solution, and if needed, subclasses will provide
  their own implementations.
```

#### compiler.build.spark.types.ArgType.convertIntermediateToExternal

```text
convertIntermediateToExternal To external representation
 
  For some datatypes, an conversion to external may be necessary. If no
  conversion is necessary, this just returns the same value.
```

#### compiler.build.spark.types.ArgType.convertIntermediateToMATLAB

```text
convertIntermediateToMATLAB Intermediate to MATLAB
  Implementation for @ArgType
 
  For some datatypes, an intermediate representation is
  necessary (e.g. timestamps). If no conversion is necessary,
  this just returns the same value
```

#### compiler.build.spark.types.ArgType.convertIntermediatelColumnToMATLAB

```text
convertIntermediatelColumnToMATLAB Intermediate to MATLAB
 
  For some datatypes, the intermediate representation must be converted
  to a different type in MATLAB. A typical example may be Timestamp
```

#### compiler.build.spark.types.ArgType.convertMATLABToIntermediate

```text
convertMATLABToIntermediate Convert MATLAB values to interm.
 
  For some datatypes, an intermediate representation is
  necessary (e.g. timestamps). If no conversion is necessary,
  this just returns the same value
```

#### compiler.build.spark.types.ArgType.convertMWToRetValue

```text
compiler.build.spark.types.ArgType/convertMWToRetValue is a function.
    obj = compiler.build.spark.types.ArgType
```

#### compiler.build.spark.types.ArgType.convertMWValueForPython

```text
convertMWValueForPython
 
  Some datatypes will need to be converted from a MATLAB value
  to the corresponding Python value.
  In general, the function will just return the srcData string.
  For certain datatypes, like timestamp (datetime.datetime in
  Python), the method will be overridden in the class file
  (Timestamp.m).
```

#### compiler.build.spark.types.ArgType.convertPandaColumnFromIntermediate

```text
convertPandaColumnToIntermediate Panda columns to intermediate
 
  For some datatypes, an intermediate representation is
  necessary (e.g. timestamps). If no conversion is necessary,
  this just returns the same value
  
  If the code out is not length zero, it will be added to the code.
```

#### compiler.build.spark.types.ArgType.convertPandaColumnToIntermediate

```text
convertPandaColumnToIntermediate Panda columns to intermediate
 
  For some datatypes, an intermediate representation is
  necessary (e.g. timestamps). If no conversion is necessary,
  this just returns the same value
```

#### compiler.build.spark.types.ArgType.convertPythonValueForMW

```text
convertPythonValueForMW
 
  Some datatypes will need to be converted to something that
  MATLAB can understand. In general, the function will just
  return the srcData string. For certain datatypes, like
  timestamp (datetime.datetime in Python), the method will be
  overridden in the class file (Timestamp.m).
```

#### compiler.build.spark.types.ArgType.createMWValueToJavaStatement

```text
createMWValueToJavaStatement Statement(s) to convert MW to Java
 
  The Java return values from the MATLAB runtime need to be
  converted to a non-MathWorks type. This may be done in one
  single line, but for certain datatypes, it may need several
  lines.
  For simple cases, it will use the convertMWToRetValue method,
  and for more complex conversions, this method may be
  overridden in other classes.
```

#### compiler.build.spark.types.ArgType.declareAndSetRowValue

```text
compiler.build.spark.types.ArgType/declareAndSetRowValue is a function.
    str = declareAndSetRowValue(obj, srcData, inArgName)
```

#### compiler.build.spark.types.ArgType.genInterColToPySeries

```text
genInterColToPySeries
  Generate a helper function, and add it to the API struct. If already
  present, don't generate it.
```

#### compiler.build.spark.types.ArgType.genIntermediateArrayToPython

```text
genIntermediateArrayToPython
  Generate a helper function, and add it to the API struct. If already
  present, don't generate it.
```

#### compiler.build.spark.types.ArgType.getBoxedJavaValue

```text
instantiateMWValue - Instantiate MW type Java object
  Arguments:
   src - a text string describing the variable to use
   castArgument [optional] - a boolean stating if explicit casting
   should be used, e.g. in case it is just an Object.
   Default value is false.
```

#### compiler.build.spark.types.ArgType.getBuildType

```text
getBuildType Return type of build, "java" or "python"
```

#### compiler.build.spark.types.ArgType.getColumnElemType

```text
getColumnElemType Type used for a column element
 
  Dependent on datatypes and size, the column may need to be transposed
  or not.
```

#### compiler.build.spark.types.ArgType.getComma

```text
getComma Return a comma unless last idx
```

#### compiler.build.spark.types.ArgType.getEncoderCreator

```text
compiler.build.spark.types.ArgType/getEncoderCreator is a function.
    enc = getEncoderCreator(obj)
```

#### compiler.build.spark.types.ArgType.getEncoderInstantiation

```text
compiler.build.spark.types.ArgType/getEncoderInstantiation is a function.
    obj = compiler.build.spark.types.ArgType
```

#### compiler.build.spark.types.ArgType.getEncoderType

```text
compiler.build.spark.types.ArgType/getEncoderType is a function.
    obj = compiler.build.spark.types.ArgType
```

#### compiler.build.spark.types.ArgType.getFileParent

```text
compiler.build.spark.types.ArgType/getFileParent is a function.
    parent = getFileParent(obj)
```

#### compiler.build.spark.types.ArgType.getFuncArgType

```text
compiler.build.spark.types.ArgType/getFuncArgType is a function.
    argType = getFuncArgType(obj)
```

#### compiler.build.spark.types.ArgType.getFuncArgTypes

```text
compiler.build.spark.types.ArgType/getFuncArgTypes is a function.
    types = getFuncArgTypes(obj)
```

#### compiler.build.spark.types.ArgType.getJavaType

```text
compiler.build.spark.types.ArgType/getJavaType is a function.
    T = getJavaType(obj)
```

#### compiler.build.spark.types.ArgType.getMATLABHelperInputConversion

```text
getMATLABHelperInputConversion Convert from different types
  If this function returns an empty string, no conversion is
  necessary. If the string is non-empty, it is used for the
  conversion. 
  In general, no conversion will be necessary, but if it is
  necessary, that class (e.g. Timestamp) should overload
  this method.
```

#### compiler.build.spark.types.ArgType.getMATLABHelperOutputConversion

```text
getMATLABHelperOutputConversion Convert from different types
  If this function returns an empty string, no conversion is
  necessary. If the string is non-empty, it is used for the
  conversion. 
  In general, no conversion will be necessary, but if it is
  necessary, that class (e.g. Timestamp) should overload
  this method.
```

#### compiler.build.spark.types.ArgType.getMATLABInputColumn

```text
getMATLABInputColumn Return string with MATLAB column
```

#### compiler.build.spark.types.ArgType.getMWArgType

```text
compiler.build.spark.types.ArgType/getMWArgType is a function.
    mwType = getMWArgType(obj)
```

#### compiler.build.spark.types.ArgType.getMWResultType

```text
getMWResultType  Get the result type
 
  This returns the type, as a call to a compiled Jar would return the
  type. In general, it's the
```

#### compiler.build.spark.types.ArgType.getPrimitiveJavaType

```text
compiler.build.spark.types.ArgType/getPrimitiveJavaType is a function.
    primitiveName = getPrimitiveJavaType(obj)
```

#### compiler.build.spark.types.ArgType.getReturnType

```text
compiler.build.spark.types.ArgType/getReturnType is a function.
    retType = getReturnType(obj)
```

#### compiler.build.spark.types.ArgType.getReturnTypes

```text
compiler.build.spark.types.ArgType/getReturnTypes is a function.
    types = getReturnTypes(obj)
```

#### compiler.build.spark.types.ArgType.getRowInputValue

```text
compiler.build.spark.types.ArgType/getRowInputValue is a function.
    str = getRowInputValue(obj, src, argName)
```

#### compiler.build.spark.types.ArgType.getSparkTypeConstructor

```text
getSparkTypeConstructor Return UDF style constructor
  When defining a UDF, the return type can be indicated by a
  Spark type
```

#### compiler.build.spark.types.ArgType.getUDFFuncArgType

```text
compiler.build.spark.types.ArgType/getUDFFuncArgType is a function.
    argType = getUDFFuncArgType(obj)
```

#### compiler.build.spark.types.ArgType.getVectorLength

```text
compiler.build.spark.types.ArgType/getVectorLength is a function.
    L = getVectorLength(obj)
```

#### compiler.build.spark.types.ArgType.init

```text
compiler.build.spark.types.ArgType/init is a function.
    init(obj)
```

#### compiler.build.spark.types.ArgType.instantiate

```text
compiler.build.spark.types.ArgType.instantiate is a function.
    obj = compiler.build.spark.types.ArgType.instantiate(typeName, varargin)
```

#### compiler.build.spark.types.ArgType.instantiateMWValue

```text
instantiateMWValue - Instantiate MW type Java object
  Arguments:
   src - a text string describing the variable to use
   castArgument [optional] - a boolean stating explicit casting
   should be used, e.g. in case it is just an Object.
   Default value is false.
```

#### compiler.build.spark.types.ArgType.instantiatePythonExampleValue

```text
instantiatePythonExampleValue Create example value for Python
 
  This method is used to create example files with values
  Many types can use the standard Python conversions (float(),
  str(), etc.), and types with special requirements must
  subclass this method.
```

#### compiler.build.spark.types.ArgType.instantiateScalaExampleValue

```text
instantiateScalaExampleValue Create example value for Scala
 
  This method is used to create example files with values
  Many types can use the standard Scala way (toFloat,
  toBoolean, etc.), and types with special requirements must
  subclass this method.
```

#### compiler.build.spark.types.ArgType.isArray

```text
isArray Argument is an array
```

#### compiler.build.spark.types.ArgType.isJavaBuild

```text
isJavaBuild Return true if build type is Java
```

#### compiler.build.spark.types.ArgType.isPythonBuild

```text
isPythonBuild Return true if build type is Python
```

#### compiler.build.spark.types.ArgType.isScalarData

```text
compiler.build.spark.types.ArgType/isScalarData is a function.
    ret = isScalarData(obj)
```

#### compiler.build.spark.types.ArgType.pythonInputArgumentNeedsCasting

```text
compiler.build.spark.types.ArgType/pythonInputArgumentNeedsCasting is a function.
    ret = pythonInputArgumentNeedsCasting(obj)
```

#### compiler.build.spark.types.ArgType.pythonSchemaType

```text
pythonSchemaType Return python spark schema type
 
  This function will return a schema type, which in many cases
  coincide with the Java primitive type. In cases where this
  differes, a suitably overridden method will be used.
```

#### compiler.build.spark.types.ArgType.setParent

```text
compiler.build.spark.types.ArgType/setParent is a function.
    setParent(obj, parent)
```

### compiler.build.spark.types.Boolean

Superclass: compiler.build.spark.types.ArgType

```text
Boolean Class used for SparkBuilder datatype handling
```

#### compiler.build.spark.types.Boolean.Boolean

```text
Boolean Class used for SparkBuilder datatype handling

    Documentation for compiler.build.spark.types.Boolean
```

#### compiler.build.spark.types.Boolean.convertMWToRetValue

```text
compiler.build.spark.types.Boolean/convertMWToRetValue is a function.
    str = convertMWToRetValue(obj, srcData)
```

#### compiler.build.spark.types.Boolean.getEncoderInstantiation

```text
compiler.build.spark.types.Boolean/getEncoderInstantiation is a function.
    encInst = getEncoderInstantiation(obj)
```

#### compiler.build.spark.types.Boolean.getEncoderType

```text
compiler.build.spark.types.Boolean/getEncoderType is a function.
    encType = getEncoderType(obj)
```

#### compiler.build.spark.types.Boolean.instantiateScalaExampleValue

```text
instantiateScalaExampleValue Create example value for Scala
 
  See compiler.build.spark.types.ArgType/instantiateScalaExampleValue
```

### compiler.build.spark.types.Double

Superclass: compiler.build.spark.types.ArgType

```text
Double Class used for SparkBuilder datatype handling
```

#### compiler.build.spark.types.Double.Double

```text
Double Class used for SparkBuilder datatype handling

    Documentation for compiler.build.spark.types.Double
```

#### compiler.build.spark.types.Double.convertIntermediateToExternal

```text
convertIntermediateToExternal To external representation
 
  For some datatypes, an conversion to external may be necessary. If no
  conversion is necessary, this just returns the same value.
```

#### compiler.build.spark.types.Double.convertMWToRetValue

```text
compiler.build.spark.types.Double/convertMWToRetValue is a function.
    str = convertMWToRetValue(obj, srcData)
```

#### compiler.build.spark.types.Double.convertMWValueForPython

```text
convertMWValueForPython
 
  See compiler.build.spark.types.ArgType/convertMWValueForPython
```

#### compiler.build.spark.types.Double.getEncoderInstantiation

```text
compiler.build.spark.types.Double/getEncoderInstantiation is a function.
    encInst = getEncoderInstantiation(obj)
```

#### compiler.build.spark.types.Double.getEncoderType

```text
compiler.build.spark.types.Double/getEncoderType is a function.
    encType = getEncoderType(obj)
```

### compiler.build.spark.types.Float

Superclass: compiler.build.spark.types.ArgType

```text
Float Class used for SparkBuilder datatype handling
```

#### compiler.build.spark.types.Float.Float

```text
Float Class used for SparkBuilder datatype handling

    Documentation for compiler.build.spark.types.Float
```

#### compiler.build.spark.types.Float.convertIntermediateToMATLAB

```text
convertIntermediateToMATLAB Intermediate to MATLAB
  Implementation for @Float
 
  See also compiler.build.spark.types.ArgType/convertIntermediateToMATLAB
```

#### compiler.build.spark.types.Float.convertMWToRetValue

```text
compiler.build.spark.types.Float/convertMWToRetValue is a function.
    str = convertMWToRetValue(obj, srcData)
```

#### compiler.build.spark.types.Float.convertMWValueForPython

```text
convertMWValueForPython
 
  See compiler.build.spark.types.ArgType/convertMWValueForPython
```

#### compiler.build.spark.types.Float.getEncoderInstantiation

```text
compiler.build.spark.types.Float/getEncoderInstantiation is a function.
    encInst = getEncoderInstantiation(obj)
```

#### compiler.build.spark.types.Float.getEncoderType

```text
compiler.build.spark.types.Float/getEncoderType is a function.
    encType = getEncoderType(obj)
```

#### compiler.build.spark.types.Float.getMATLABHelperInputConversion

```text
getMATLABHelperInputConversion Convert from different types
 
  See compiler.build.spark.types.ArgType/getMATLABHelperInputConversion
```

### compiler.build.spark.types.Integer

Superclass: compiler.build.spark.types.ArgType

```text
Integer Class used for SparkBuilder datatype handling
```

#### compiler.build.spark.types.Integer.Integer

```text
Integer Class used for SparkBuilder datatype handling

    Documentation for compiler.build.spark.types.Integer
```

#### compiler.build.spark.types.Integer.castLongColumnToValue

```text
castLongColumnToValue Convert a long to a value of this type
  This function is used for creating example code.
  It will be subclassed in types with more complex conversions.
  It assumes that the input is a Spark Column with type long

Help for compiler.build.spark.types.Integer/castLongColumnToValue is inherited from superclass compiler.build.spark.types.ArgType
```

#### compiler.build.spark.types.Integer.convertIntermediateToMATLAB

```text
convertIntermediateToMATLAB Intermediate to MATLAB
  Implementation for @Integer
 
  See also compiler.build.spark.types.ArgType/convertIntermediateToMATLAB
```

#### compiler.build.spark.types.Integer.convertMWToRetValue

```text
compiler.build.spark.types.Integer/convertMWToRetValue is a function.
    str = convertMWToRetValue(obj, srcData)
```

#### compiler.build.spark.types.Integer.convertMWValueForPython

```text
convertMWValueForPython
 
  See compiler.build.spark.types.ArgType/convertMWValueForPython
```

#### compiler.build.spark.types.Integer.getEncoderInstantiation

```text
compiler.build.spark.types.Integer/getEncoderInstantiation is a function.
    encInst = getEncoderInstantiation(obj)
```

#### compiler.build.spark.types.Integer.getEncoderType

```text
compiler.build.spark.types.Integer/getEncoderType is a function.
    encType = getEncoderType(obj)
```

#### compiler.build.spark.types.Integer.getMATLABHelperInputConversion

```text
getMATLABHelperInputConversion Convert from different types
 
  See compiler.build.spark.types.ArgType/getMATLABHelperInputConversion
```

#### compiler.build.spark.types.Integer.instantiateScalaExampleValue

```text
instantiateScalaExampleValue Create example value for Scala
 
  See compiler.build.spark.types.ArgType/instantiateScalaExampleValue
```

### compiler.build.spark.types.Long

Superclass: compiler.build.spark.types.ArgType

```text
Long Class used for SparkBuilder datatype handling
```

#### compiler.build.spark.types.Long.Long

```text
Long Class used for SparkBuilder datatype handling

    Documentation for compiler.build.spark.types.Long
```

#### compiler.build.spark.types.Long.convertMWToRetValue

```text
compiler.build.spark.types.Long/convertMWToRetValue is a function.
    str = convertMWToRetValue(obj, srcData)
```

#### compiler.build.spark.types.Long.convertMWValueForPython

```text
convertMWValueForPython
 
  See compiler.build.spark.types.ArgType/convertMWValueForPython
```

#### compiler.build.spark.types.Long.getEncoderInstantiation

```text
compiler.build.spark.types.Long/getEncoderInstantiation is a function.
    encInst = getEncoderInstantiation(obj)
```

#### compiler.build.spark.types.Long.getEncoderType

```text
compiler.build.spark.types.Long/getEncoderType is a function.
    encType = getEncoderType(obj)
```

#### compiler.build.spark.types.Long.pythonSchemaType

```text
pythonSchemaType Return python spark schema type
 
  Special handling for Long.
  See compiler.build.spark.types.ArgType/pythonSchemaType
```

### compiler.build.spark.types.Short

Superclass: compiler.build.spark.types.ArgType

```text
Short Class used for SparkBuilder datatype handling
```

#### compiler.build.spark.types.Short.Short

```text
Short Class used for SparkBuilder datatype handling

    Documentation for compiler.build.spark.types.Short
```

#### compiler.build.spark.types.Short.convertIntermediateToMATLAB

```text
convertIntermediateToMATLAB Intermediate to MATLAB
  Implementation for @Short
 
  See also compiler.build.spark.types.ArgType/convertIntermediateToMATLAB
```

#### compiler.build.spark.types.Short.convertMWToRetValue

```text
compiler.build.spark.types.Short/convertMWToRetValue is a function.
    str = convertMWToRetValue(obj, srcData)
```

#### compiler.build.spark.types.Short.convertMWValueForPython

```text
convertMWValueForPython
 
  See compiler.build.spark.types.ArgType/convertMWValueForPython
```

#### compiler.build.spark.types.Short.getEncoderInstantiation

```text
compiler.build.spark.types.Short/getEncoderInstantiation is a function.
    encInst = getEncoderInstantiation(obj)
```

#### compiler.build.spark.types.Short.getEncoderType

```text
compiler.build.spark.types.Short/getEncoderType is a function.
    encType = getEncoderType(obj)
```

#### compiler.build.spark.types.Short.getMATLABHelperInputConversion

```text
getMATLABHelperInputConversion Convert from different types
 
  See compiler.build.spark.types.ArgType/getMATLABHelperInputConversion
```

### compiler.build.spark.types.String

Superclass: compiler.build.spark.types.ArgType

```text
String Class used for SparkBuilder datatype handling
```

#### compiler.build.spark.types.String.String

```text
String Class used for SparkBuilder datatype handling

    Documentation for compiler.build.spark.types.String
```

#### compiler.build.spark.types.String.castLongColumnToValue

```text
castLongColumnToValue Convert a long to a value of this type
  This function is used for creating example code.
  It will be subclassed in types with more complex conversions.
  It assumes that the input is a Spark Column with type long

Help for compiler.build.spark.types.String/castLongColumnToValue is inherited from superclass compiler.build.spark.types.ArgType
```

#### compiler.build.spark.types.String.convertExternalToIntermediate

```text
convertExternalToIntermediate To intermediate representation
 
  See compiler.build.spark.types.ArgType/convertExternalToIntermediate
```

#### compiler.build.spark.types.String.convertIntermediateColumnForRuntime

```text
convertIntermediateColumnForRuntime Convert columns
 
  See also compiler.build.spark.types.ArgType/convertIntermediateColumnForRuntime
```

#### compiler.build.spark.types.String.convertIntermediateMWColumnToExternal

```text
convertIntermediateMWColumnToExternal Convert MW Column to external type
 
  See compiler.build.spark.types.ArgType/convertIntermediateMWColumnToExternal
```

#### compiler.build.spark.types.String.convertIntermediateToMATLAB

```text
convertIntermediateToMATLAB Intermediate to MATLAB
  Implementation for @String
 
  See also compiler.build.spark.types.ArgType/convertIntermediateToMATLAB
```

#### compiler.build.spark.types.String.convertMATLABToIntermediate

```text
convertMATLABToIntermediate Convert MATLAB values to interm.
 
  For some datatypes, an intermediate representation is
  necessary (e.g. timestamps). If no conversion is necessary,
  this just returns the same value
```

#### compiler.build.spark.types.String.convertMWToRetValue

```text
compiler.build.spark.types.String/convertMWToRetValue is a function.
    str = convertMWToRetValue(obj, srcData)
```

#### compiler.build.spark.types.String.convertMWValueForPython

```text
convertMWValueForPython
 
  See compiler.build.spark.types.ArgType/convertMWValueForPython
```

#### compiler.build.spark.types.String.convertPythonValueForMW

```text
convertPythonValueForMW
 
  See compiler.build.spark.types.ArgType/convertPythonValueForMW
```

#### compiler.build.spark.types.String.createMWValueToJavaStatement

```text
createMWValueToJavaStatement Statement(s) to convert MW to Java
 
  See compiler.build.spark.types.ArgType/createMWValueToJavaStatement
```

#### compiler.build.spark.types.String.genInterColToPySeries

```text
genInterColToPySeries
  Generate a helper function, and add it to the API struct. If already
  present, don't generate it.
```

#### compiler.build.spark.types.String.getColumnElemType

```text
getColumnElemType Type used for a column element
 
  Dependent on datatypes and size, the column may need to be transposed
  or not.
```

#### compiler.build.spark.types.String.getEncoderInstantiation

```text
compiler.build.spark.types.String/getEncoderInstantiation is a function.
    encInst = getEncoderInstantiation(obj)
```

#### compiler.build.spark.types.String.getEncoderType

```text
compiler.build.spark.types.String/getEncoderType is a function.
    encType = getEncoderType(obj)
```

#### compiler.build.spark.types.String.getMATLABHelperInputConversion

```text
getMATLABHelperInputConversion Convert from different types
 
  See compiler.build.spark.types.ArgType/getMATLABHelperInputConversion
```

#### compiler.build.spark.types.String.getMATLABHelperOutputConversion

```text
getMATLABHelperOutputConversion Convert from different types
 
  See compiler.build.spark.types.ArgType/getMATLABHelperOutputConversion
```

#### compiler.build.spark.types.String.getMWResultType

```text
getMWResultType  Get the result type
 
  This returns the type, as a call to a compiled Jar would return the
  type. In general, it's the
```

#### compiler.build.spark.types.String.instantiatePythonExampleValue

```text
instantiatePythonExampleValue Create example value for Python
 
  See compiler.build.spark.types.ArgType/instantiatePythonExampleValue
```

### compiler.build.spark.types.Table

Superclass: compiler.build.spark.types.ArgType

```text
Table Class used for SparkBuilder datatype handling
```

#### compiler.build.spark.types.Table.Table

```text
obj@compiler.build.spark.types.ArgType(varargin{:});

    Documentation for compiler.build.spark.types.Table
```

#### compiler.build.spark.types.Table.convertMWToRetValue

```text
compiler.build.spark.types.Table/convertMWToRetValue is a function.
    str = convertMWToRetValue(obj, srcData)
```

#### compiler.build.spark.types.Table.getEncoderInstantiation

```text
compiler.build.spark.types.Table/getEncoderInstantiation is a function.
    encInst = getEncoderInstantiation(obj)
```

#### compiler.build.spark.types.Table.getEncoderType

```text
compiler.build.spark.types.Table/getEncoderType is a function.
    encType = getEncoderType(obj)
```

#### compiler.build.spark.types.Table.initTable

```text
compiler.build.spark.types.Table/initTable is a function.
    initTable(obj, args)
```

### compiler.build.spark.types.Timestamp

Superclass: compiler.build.spark.types.ArgType

```text
Double Class used for SparkBuilder datatype handling
```

#### compiler.build.spark.types.Timestamp.Timestamp

```text
Double Class used for SparkBuilder datatype handling

    Documentation for compiler.build.spark.types.Timestamp
```

#### compiler.build.spark.types.Timestamp.castLongColumnToValue

```text
castLongColumnToValue A helper function to create test data
 
  The number 1602306305 simply corresponds to the date
  2020-10-10T05:05:05, and was used to have something else than
  starting at 1970. It has no deeper meaning.
```

#### compiler.build.spark.types.Timestamp.convertExternalToIntermediate

```text
convertExternalToIntermediate To intermediate representation
 
  See compiler.build.spark.types.ArgType/convertExternalToIntermediate
```

#### compiler.build.spark.types.Timestamp.convertIntermediateColumnForRuntime

```text
convertIntermediateColumnForRuntime Convert columns
 
  See also compiler.build.spark.types.ArgType/convertIntermediateColumnForRuntime
```

#### compiler.build.spark.types.Timestamp.convertIntermediateMWColumnToExternal

```text
convertIntermediateMWColumnToExternal Convert MW Column to external type
 
  See compiler.build.spark.types.ArgType/convertIntermediateMWColumnToExternal
```

#### compiler.build.spark.types.Timestamp.convertIntermediateToMATLAB

```text
convertIntermediateToMATLAB Intermediate to MATLAB
  Implementation for @Timestamp
 
  See also compiler.build.spark.types.ArgType/convertIntermediateToMATLAB
```

#### compiler.build.spark.types.Timestamp.convertIntermediatelColumnToMATLAB

```text
convertIntermediatelColumnToMATLAB Intermediate to MATLAB
 
  See compiler.build.spark.types.ArgType/convertIntermediatelColumnToMATLAB
```

#### compiler.build.spark.types.Timestamp.convertMATLABToIntermediate

```text
convertMATLABToIntermediate Convert MATLAB values to interm.
 
  For some datatypes, an intermediate representation is
  necessary (e.g. timestamps). If no conversion is necessary,
  this just returns the same value
```

#### compiler.build.spark.types.Timestamp.convertMWToRetValue

```text
compiler.build.spark.types.Timestamp/convertMWToRetValue is a function.
    str = convertMWToRetValue(obj, srcData)
```

#### compiler.build.spark.types.Timestamp.convertMWValueForPython

```text
convertMWValueForPython
 
  Special handling for timestamps.
  See compiler.build.spark.types.ArgType/convertMWValueForPython
```

#### compiler.build.spark.types.Timestamp.convertPandaColumnFromIntermediate

```text
convertPandaColumnToIntermediate Panda columns to intermediate
 
  For some datatypes, an intermediate representation is
  necessary (e.g. timestamps). If no conversion is necessary,
  this just returns the same value
  
  If the code out is not length zero, it will be added to the code.
```

#### compiler.build.spark.types.Timestamp.convertPandaColumnToIntermediate

```text
convertPandaColumnToIntermediate Panda columns to intermediate
 
  For some datatypes, an intermediate representation is
  necessary (e.g. timestamps). If no conversion is necessary,
  this just returns the same value
```

#### compiler.build.spark.types.Timestamp.convertPythonValueForMW

```text
convertPythonValueForMW
 
  Special handling for timestamps.
  See compiler.build.spark.types.ArgType/convertPythonValueForMW
```

#### compiler.build.spark.types.Timestamp.genInterColToPySeries

```text
genInterColToPySeries
  Generate a helper function, and add it to the API struct. If already
  present, don't generate it.
```

#### compiler.build.spark.types.Timestamp.getColumnElemType

```text
getColumnElemType Type used for a column element
 
  Dependent on datatypes and size, the column may need to be transposed
  or not.
```

#### compiler.build.spark.types.Timestamp.getEncoderInstantiation

```text
compiler.build.spark.types.Timestamp/getEncoderInstantiation is a function.
    encInst = getEncoderInstantiation(obj)
```

#### compiler.build.spark.types.Timestamp.getEncoderType

```text
compiler.build.spark.types.Timestamp/getEncoderType is a function.
    encType = getEncoderType(obj)
```

#### compiler.build.spark.types.Timestamp.getMATLABHelperInputConversion

```text
getMATLABHelperInputConversion Convert from different types
 
  See compiler.build.spark.types.ArgType/getMATLABHelperInputConversion
```

#### compiler.build.spark.types.Timestamp.getMATLABHelperOutputConversion

```text
getMATLABHelperOutputConversion Convert from different types
  If this function returns an empty string, no conversion is
  necessary. If the string is non-empty, it is used for the
  conversion. 
  In general, no conversion will be necessary, but if it is
  necessary, that class (e.g. Timestamp) should overload
  this method.

Help for compiler.build.spark.types.Timestamp/getMATLABHelperOutputConversion is inherited from superclass compiler.build.spark.types.ArgType
```

#### compiler.build.spark.types.Timestamp.instantiatePythonExampleValue

```text
instantiatePythonExampleValue Create example value for Python
 
  See compiler.build.spark.types.ArgType/instantiatePythonExampleValue
```

#### compiler.build.spark.types.Timestamp.instantiateScalaExampleValue

```text
instantiateScalaExampleValue Create example value for Scala
 
  See compiler.build.spark.types.ArgType/instantiateScalaExampleValue
```

#### compiler.build.spark.types.Timestamp.pythonSchemaType

```text
pythonSchemaType Return python spark schema type
 
  Special handling for timestamps.
  See compiler.build.spark.types.ArgType/pythonSchemaType
```

### compiler.build.spark.types.generateFunctionSignature

```text
generateFunctionSignature Helper function to get function signature
 
  This function creates a JSON file that provides the SparkBuildercan
  with additional information when compiling functions that should run
  on Spark clusters.
 
  The function takes two or three arguments:
    funcName - The name of the function (without .m ending) this
               signature is for
    IN       - A cell array of arguments for the function
    OUT      - A cell array of return values for the function
 
  It will automatically create a JSON file in the same location as the
  function, but with the ending "_signature.json" instead of ".m".
  The function also returns the name of the JSON file, but this can
  mostly be ignored.
 
  Examples:
   % Importing the function, to make examples shorter
   import compiler.build.spark.types.generateFunctionSignature
 
  A function that takes 3 scalar double values, and returns two
  double scalars:
   generateFunctionSignature('simplecalc', {3, 4, 5}, {1, 2})
 
  The same signature can be generated by simply omitting the output
  values. In this case, the function will simply call the actual
  function with the input values provided, and use the results of this
  as the OUT argument.
   generateFunctionSignature('simplecalc', {3, 4, 5})
 
  A function that takes a table and a scalar, and returns another table
   generateFunctionSignature('gaussianFilter', {T_in, 4})
```

### compiler.build.spark.types.getFileArgumentInfo

```text
getFileArgumentInfo Try to retrieve argument info
```

### compiler.build.spark.types.getTypeEncoding

```text
getTypeEncoding Helper function to get type encoding
 
  This function creates a string, that can be used for type encoding in
  conjunction with the Compiler workflows for Apache Spark
 
  The function takes two arguments, each a cell array representing
  typical input and output arguments of the function for which the
  encoding is created.
  It can furthermore take two additional arguments providing names for
  the input and output arguments.
 
  Example:
  A function that takes 2 scalar double values, and returns another
  double scalar
  enc = getTypeEncoding({3, 4}, {5})
 
  A function that takes a table and a scalar, and returns another table
  enc = getTypeEncoding({T_in, 4}, {T_out})
```

### compiler.build.spark.CallContext

```text
CallContext What context is this called in, row or table
```

```text
Enumeration values:
  None
  Row
  TableDataFrame
  TablePandas

```

#### compiler.build.spark.CallContext.CallContext

```text
CallContext What context is this called in, row or table

    Documentation for compiler.build.spark.CallContext
```

### compiler.build.spark.File

Superclasses: handle, matlab.mixin.Heterogeneous

```text
File A class for describing files for Spark compiler
```

#### compiler.build.spark.File.File

```text
Constructor for File class

    Documentation for compiler.build.spark.File
```

#### compiler.build.spark.File.addMethodType

```text
addMethodType Add a MethodType to array
  This is done to keep account of what methods are generated,
  and what wrappers and helpers need to be generated.
 
  mt can be a string or an instance of MethodType
```

#### compiler.build.spark.File.createArgument

```text
compiler.build.spark.File/createArgument is a function.
    arg = createArgument(obj, varargin)
```

#### compiler.build.spark.File.determineMethodTypes

```text
determineMethodTypes Determine what methods must be created
 
  The methods will differ for different function signatures.
```

#### compiler.build.spark.File.fillEmptyNames

```text
fillEmptyNames Set names for arguments that weren't given any
```

#### compiler.build.spark.File.genMATLABHelperOutputConversions

```text
genMATLABHelperOutputConversions Generate conversion code
 
  Some datatypes, like datetime/java.sql.Timestamp, need special
  attention on the interface between Spark and MATLAB.
 
  This method should be generic enough to work with all function types.
  An additional argument, helperName, is provided, and used in case
  names for arguments need to be used.
  A third an optional argument is used if the results should directly
  be written into another StringWriter.
```

#### compiler.build.spark.File.generateArgNames

```text
compiler.build.spark.File/generateArgNames is a function.
    names = generateArgNames(obj, direction, base)
```

#### compiler.build.spark.File.generateNameList

```text
compiler.build.spark.File/generateNameList is a function.
    names = generateNameList(~, base, num)
```

#### compiler.build.spark.File.generatePythonInputArgs

```text
compiler.build.spark.File/generatePythonInputArgs is a function.
    [names, namesArray] = generatePythonInputArgs(obj, opts)
```

#### compiler.build.spark.File.generatePythonRowInputArgs

```text
formatStr = sprintf("%s[%%d]", varName);
```

#### compiler.build.spark.File.generatePythonRowIteratorArgs

```text
compiler.build.spark.File/generatePythonRowIteratorArgs is a function.
    str = generatePythonRowIteratorArgs(obj)
```

#### compiler.build.spark.File.getArgArray

```text
getArgArray Create array of arguments and their types
 
  [a,b,c] = f.getArgArray('in', 'arg')
  a =
    1x2 string array
      "arg1"    "arg2"
  b =
    1x2 string array
      "Double"    "Double"
  c =
      "Double arg1, Double arg2"
```

#### compiler.build.spark.File.getBuildType

```text
getBuildType Return type of build, "java" or "python"
```

#### compiler.build.spark.File.getEncoderCreator

```text
getEncoderCreator Encoder for output of map
```

#### compiler.build.spark.File.getEncoderStruct

```text
compiler.build.spark.File/getEncoderStruct is a function.
    entry = getEncoderStruct(obj)
```

#### compiler.build.spark.File.getHelperFcnName

```text
getHelperFcnName Return name of helper function (MATLAB)
```

#### compiler.build.spark.File.getInputElements

```text
getInputElements Return array of input elements
 
  This is a helper method that returns an array of input elements. It
  returns both the columns of a table *and* additional arguments, if any.
 
  It has two optional, named arguments, table and individual
  
  Only get the table elements, i.e. the columns of the table in the
  first argument.
    F.getInputElements(individual=false)
 
  Only get the additional/non-table arguments
    F.getInputElements(table=false)
 
  If used with out options, it returns all elements
    F.getInputElements()
 
  This last call is equal to calling
    F.getInputElements(individual=true, table=true)
```

#### compiler.build.spark.File.getOutSparkType

```text
compiler.build.spark.File/getOutSparkType is a function.
    [outType, outTypeDefinition] = getOutSparkType(obj)
```

#### compiler.build.spark.File.getOutputElements

```text
getOutputElements Return array of output elements
 
  This is a helper method that returns an array of output elements. It
  handles the choice between 'all outputs' and 'all columns'. The
  latter in case a table is the output type.
```

#### compiler.build.spark.File.getReturnType

```text
compiler.build.spark.File/getReturnType is a function.
    retType = getReturnType(obj)
```

#### compiler.build.spark.File.getUDFInfo

```text
compiler.build.spark.File/getUDFInfo is a function.
    [udfName, udfType, callTypes, UDF] = getUDFInfo(obj)
```

#### compiler.build.spark.File.getWrapperFcnName

```text
getWrapperFcnName Return name of helper function (Java or Python)
```

#### compiler.build.spark.File.hasInputArrays

```text
hasInputArrays Returns true if there are arrays in the input columns
```

#### compiler.build.spark.File.init

```text
compiler.build.spark.File/init is a function.
    init(obj)
```

#### compiler.build.spark.File.initWithCellArgs

```text
compiler.build.spark.File/initWithCellArgs is a function.
    initWithCellArgs(obj, inArgs, outArgs)
```

#### compiler.build.spark.File.needsOutputConversion

```text
needsOutputConversion Check if outputs need to be converted
 
  This is the case, e.g. with Timestamp data.
```

#### compiler.build.spark.File.setTableProperties

```text
setTableProperties Set table informations on object
 
  This function will check the types of the function.
  The following cases exist:
  1. No tables, neither in input or output. This is a 'Values'
     function.
  2. 1 input and 1 output, both tables. This is a 'Table' function.
  3. 2 or more inputs, and 1 output. The output is a table, and
     exactly 1 of the inputs, the fist argument is a table.
     This is a Table+ function.
 
  Any other input/output combination is not valid.
  
  More information can be found in
    Modules/matlab-spark-api/Documentation/SparkBuilderDataTypes.md
```

#### compiler.build.spark.File.ticTocHelper

```text
ticTocHelper Generate tic/toc print statements
```

#### compiler.build.spark.File.useDebug

```text
useDebug Are we using Debug?
```

#### compiler.build.spark.File.writeMethodComment

```text
compiler.build.spark.File/writeMethodComment is a function.
    writeMethodComment(obj, funcName, SW)
```

### compiler.build.spark.MethodType

```text
MethodType types of functions SparkBuilder and PythonSparkBuilder generate
```

```text
Enumeration values:
  inputNames
  outputNames
  rowIterator
  colsIterator
  inputsTransformer
  outputsTransformer
  plain
  row
  map
  mapPartitions
  mapPartitionsTable
  filter
  udf
  applyInPandas
  mapInPandas
  pandasSeries
  pandasToColumns
  columnsToPandas

```

#### compiler.build.spark.MethodType.MethodType

```text
MethodType types of functions SparkBuilder and PythonSparkBuilder generate

    Documentation for compiler.build.spark.MethodType
```

### compiler.build.spark.PythonFile

Superclass: compiler.build.spark.File

```text
PythonFile Helper class for Python code generation
 
  This class is used for generating MATLAB and Python code, as well as
  examples.
  The class caters to the _signature.json workflow (see corresponding
  documentation), which has been overhauled by the .schema workflow. 
  The former wll be deprecated in a later release.
```

#### compiler.build.spark.PythonFile.PythonFile

```text
PythonFile Helper class for Python code generation
 
  This class is used for generating MATLAB and Python code, as well as
  examples.
  The class caters to the _signature.json workflow (see corresponding
  documentation), which has been overhauled by the .schema workflow. 
  The former wll be deprecated in a later release.

    Documentation for compiler.build.spark.PythonFile
```

#### compiler.build.spark.PythonFile.applyInPandas_PythonMATLABHelper

```text
applyInPandas_PythonMATLABHelper Helper file for applyInPandas
```

#### compiler.build.spark.PythonFile.applyInPandas_PythonWrapper

```text
applyInPandas_PythonWrapper Generate applyInPandas function
```

#### compiler.build.spark.PythonFile.colsIterator_PythonWrapper

```text
colsIterator_PythonWrapper Generate colsIterator function
```

#### compiler.build.spark.PythonFile.columnsToPandas_PythonWrapper

```text
columnsToPandas_PythonWrapper Convert MATLAB columns to Pandas
```

#### compiler.build.spark.PythonFile.convertExternalToIntermediate

```text
convertExternalToIntermediate Internal conversions
```

#### compiler.build.spark.PythonFile.genMATLABHelperInputConversions

```text
genMATLABHelperInputConversions Generate conversion code
 
  Some datatypes, like datetime/java.sql.Timestamp, need special
  attention on the interface between Spark and MATLAB.
 
  This method should be generic enough to work with all function types.
  An additional argument, helperName, is provided, and used in case
  names for arguments need to be used.
  A third an optional argument is used if the results should directly
  be written into another StringWriter.
```

#### compiler.build.spark.PythonFile.generateExamples

```text
generateExamples Generate examples from File
```

#### compiler.build.spark.PythonFile.generateMATLABUDFHelper

```text
generateMATLABUDFHelper Generate UDF Helper function
```

#### compiler.build.spark.PythonFile.generatePythonPandasSchema

```text
compiler.build.spark.PythonFile/generatePythonPandasSchema is a function.
    schema = generatePythonPandasSchema(obj)
```

#### compiler.build.spark.PythonFile.generatePythonTableHelperArgs

```text
generatePythonTableHelperArgs Generate arguments in code
```

#### compiler.build.spark.PythonFile.generatePythonTableRestArgs

```text
generatePythonTableRestArgs Generate arguments in code
```

#### compiler.build.spark.PythonFile.getImports

```text
getImports Generate strings with imports
```

#### compiler.build.spark.PythonFile.getInputNameArray

```text
compiler.build.spark.PythonFile/getInputNameArray is a function.
    names = getInputNameArray(obj)
```

#### compiler.build.spark.PythonFile.getOutputNameArray

```text
compiler.build.spark.PythonFile/getOutputNameArray is a function.
    names = getOutputNameArray(obj)
```

#### compiler.build.spark.PythonFile.hasOutputArrays

```text
hasOutputArrays Returns true if there are arrays in the output columns
```

#### compiler.build.spark.PythonFile.initFromSchema

```text
compiler.build.spark.PythonFile/initFromSchema is a function.
    initFromSchema(obj)
```

#### compiler.build.spark.PythonFile.inputsTransformer_PythonWrapper

```text
inputsTransformer_PythonWrapper Generate inputs transformer function
```

#### compiler.build.spark.PythonFile.isJavaBuild

```text
isJavaBuild Return true if build type is Java
```

#### compiler.build.spark.PythonFile.isPythonBuild

```text
isPythonBuild Return true if build type is Python
```

#### compiler.build.spark.PythonFile.mapInPandas_PythonWrapper

```text
mapInPandas_PythonWrapper Generate mapInPandas function
```

#### compiler.build.spark.PythonFile.mapPartitionsTable_PythonMATLABHelper

```text
mapPartitionsTable_PythonMATLABHelper Generate helper file for mapPartitions
```

#### compiler.build.spark.PythonFile.mapPartitionsTable_PythonWrapper

```text
mapPartitionsTable_PythonWrapper Generate mapPartitionsTable function
```

#### compiler.build.spark.PythonFile.mapPartitions_PythonMATLABHelper

```text
mapPartitions_PythonMATLABHelper Generate helper file for mapPartitions
```

#### compiler.build.spark.PythonFile.mapPartitions_PythonWrapper

```text
mapPartitions_PythonWrapper Generate mapPartitions function
```

#### compiler.build.spark.PythonFile.map_PythonWrapper

```text
map_PythonWrapper Generate map function
```

#### compiler.build.spark.PythonFile.needsInputTransformer

```text
needsInputTransformer Returns true input transformer needed
```

#### compiler.build.spark.PythonFile.needsOutputTransformer

```text
needsOutputTransformer Returns true if output transformer needed
```

#### compiler.build.spark.PythonFile.outputConversion_PythonWrapper

```text
outputConversion_PythonWrapper Convert outputs if necessary
```

#### compiler.build.spark.PythonFile.outputNames_PythonWrapper

```text
outputNames_PythonWrapper Generate outputNames function/variable
```

#### compiler.build.spark.PythonFile.outputsTransformer_PythonWrapper

```text
outputsTransformer_PythonWrapper Generate outputs transformer function
```

#### compiler.build.spark.PythonFile.pandasSeries_PythonMATLABHelper

```text
pandasSeries_PythonMATLABHelper Generate helper file for Pandas series
```

#### compiler.build.spark.PythonFile.pandasSeries_PythonWrapper

```text
pandasSeries_PythonWrapper Generate pandasSeries function
```

#### compiler.build.spark.PythonFile.pandasToColumns_PythonWrapper

```text
pandasToColumns_PythonWrapper Generate colsIterator function
```

#### compiler.build.spark.PythonFile.plain_PythonMATLABHelper

```text
plain_PythonMATLABHelper Generate helper file for plain
```

#### compiler.build.spark.PythonFile.plain_PythonWrapper

```text
plain_PythonWrapper Generate plain function
```

#### compiler.build.spark.PythonFile.rowIterator_PythonWrapper

```text
rowIterator_PythonWrapper Generate rowIterator function
```

### compiler.build.spark.PythonFileV2

Superclass: compiler.build.spark.File

```text
PythonFileV2 Helper class for Python code generation
```

#### compiler.build.spark.PythonFileV2.PythonFileV2

```text
obj@compiler.build.spark.File(fileName, varargin{:});

    Documentation for compiler.build.spark.PythonFileV2
```

#### compiler.build.spark.PythonFileV2.applyInPandas_PythonMATLABHelper

```text
applyInPandas_PythonMATLABHelper Helper file for applyInPandas
```

#### compiler.build.spark.PythonFileV2.applyInPandas_PythonWrapper

```text
applyInPandas_PythonWrapper Generate applyInPandas function
```

#### compiler.build.spark.PythonFileV2.chooseGroupbyColumn

```text
chooseGroupbyColumn
  Helper function when generating examples
  Not meant for serious work, as grouping shouldn't be haphazardous
```

#### compiler.build.spark.PythonFileV2.colsIterator_PythonWrapper

```text
colsIterator_PythonWrapper Generate colsIterator function
```

#### compiler.build.spark.PythonFileV2.colsToRows_PythonWrapper

```text
colsToRows_PythonWrapper Generate rows iterators for result columns
 
  This method deals with results from mapPartitions functions.
```

#### compiler.build.spark.PythonFileV2.columnsToPandas_PythonWrapper

```text
columnsToPandas_PythonWrapper Convert MATLAB columns to Pandas
```

#### compiler.build.spark.PythonFileV2.determineMethodTypes

```text
determineMethodTypes Determine what methods must be created
 
  The methods will differ for different function signatures.
```

#### compiler.build.spark.PythonFileV2.genExampleInputs

```text
genExampleInputs Debug function
  This function generates inputs in MATLAB in column format,
  that can be used as input to the helper functions for
  testing.
```

#### compiler.build.spark.PythonFileV2.generateArtifactsExample

```text
generateArtifactsExample Generate example on using artifact from within MATLAB
```

#### compiler.build.spark.PythonFileV2.generateExamples

```text
generateExamples Generate examples from File
```

#### compiler.build.spark.PythonFileV2.generateMATLABUDFHelper

```text
generateMATLABUDFHelper Generate UDF Helper function
```

#### compiler.build.spark.PythonFileV2.generatePythonInputArgs

```text
generatePythonInputArgs Internal helper method
```

#### compiler.build.spark.PythonFileV2.generatePythonNotebookTask

```text
generatePythonNotebookTask Generate a notebook example
```

#### compiler.build.spark.PythonFileV2.generatePythonPandasSchema

```text
generatePythonPandasSchema Return schema and names
 
  This is used for different helper functions
```

#### compiler.build.spark.PythonFileV2.generatePythonTableHelperArgs

```text
generatePythonTableHelperArgs Generate arguments in code
```

#### compiler.build.spark.PythonFileV2.generatePythonTableRestArgs

```text
generatePythonTableRestArgs Generate arguments in code
```

#### compiler.build.spark.PythonFileV2.getImports

```text
getImports Generate strings with imports
```

#### compiler.build.spark.PythonFileV2.getInputElements

```text
getInputElements Return array of input elements
 
  This is a helper method that returns an array of input elements. It
  returns both the columns of a table *and* additional arguments, if any.
 
  It has two optional, named arguments, table and individual
  
  Only get the table elements, i.e. the columns of the table in the
  first argument.
    F.getInputElements(individual=false)
 
  Only get the additional/non-table arguments
    F.getInputElements(table=false)
 
  If used with out options, it returns all elements
    F.getInputElements()
 
  This last call is equal to calling
    F.getInputElements(individual=true, table=true)
 
  A third option, main, can be used to override the options table and
  individual. If main=true is used as an option, it will set the other
  options according to the value of TableInterface:
  
   TableInterface   true         false
  ------------------------------------------
    table           true         false
  individual        false        true
```

#### compiler.build.spark.PythonFileV2.getInputNames

```text
getInputNames Return array of input names
 
  This is a helper method that returns an array of input names. It
  returns both the column names of a table *and* additional argument
  namess, if any. 
 
  It has two optional, named arguments, table and individual
  
  Only get the table column names,
    F.getInputNames(individual=false)
 
  Only get the additional/non-table argument names
    F.getInputNames(table=false)
 
  If used with out options, it returns all element namess
    F.getInputNames()
 
  This last call is equal to calling
    F.getInputNames(individual=true, table=true)
 
  A third option, main, can be used to override the options table and
  individual. If main=true is used as an option, it will set the other
  options according to the value of TableInterface:
  
   TableInterface   true         false
  ------------------------------------------
    table           true         false
  individual        false        true
```

#### compiler.build.spark.PythonFileV2.getOutputElements

```text
getOutputElements Return array of output elements
 
  This is a helper method that returns an array of output elements. It
  handles the choice between 'all outputs' and 'all columns'. The
  latter in case a table is the output type.
```

#### compiler.build.spark.PythonFileV2.getOutputNames

```text
compiler.build.spark.PythonFileV2/getOutputNames is a function.
    names = getOutputNames(obj)
```

#### compiler.build.spark.PythonFileV2.hasOutputArrays

```text
hasOutputArrays Returns true if there are arrays in the output columns
```

#### compiler.build.spark.PythonFileV2.init

```text
compiler.build.spark.PythonFileV2/init is a function.
    init(obj)
```

#### compiler.build.spark.PythonFileV2.inputNames_PythonWrapper

```text
inputNames_PythonWrapper Generate inputNames function/variable
```

#### compiler.build.spark.PythonFileV2.ioSchemasAlign

```text
ioSchemasAlign Return true if in and out schema are equal
 
  This is used mainly for generating example code.
```

#### compiler.build.spark.PythonFileV2.mapInPandas_PythonWrapper

```text
mapInPandas_PythonWrapper Generate mapInPandas function
```

#### compiler.build.spark.PythonFileV2.mapPartitions_PythonMATLABHelper

```text
mapPartitions_PythonMATLABHelper Generate helper file for mapPartitions
```

#### compiler.build.spark.PythonFileV2.mapPartitions_PythonWrapper

```text
mapPartitions_PythonWrapper Generate mapPartitions function
```

#### compiler.build.spark.PythonFileV2.map_PythonWrapper

```text
map_PythonWrapper Generate map function
```

#### compiler.build.spark.PythonFileV2.outputNames_PythonWrapper

```text
outputNames_PythonWrapper Generate outputNames function/variable
```

#### compiler.build.spark.PythonFileV2.pandasSeries_PythonMATLABHelper

```text
pandasSeries_PythonMATLABHelper Generate helper file for Pandas series
```

#### compiler.build.spark.PythonFileV2.pandasSeries_PythonWrapper

```text
pandasSeries_PythonWrapper Generate pandasSeries function
```

#### compiler.build.spark.PythonFileV2.pandasToColumns_PythonWrapper

```text
pandasToColumns_PythonWrapper Generate colsIterator function
```

#### compiler.build.spark.PythonFileV2.plain_PythonMATLABHelper

```text
plain_PythonMATLABHelper Generate helper file for plain
```

#### compiler.build.spark.PythonFileV2.plain_PythonWrapper

```text
plain_PythonWrapper Generate plain function
```

### compiler.build.spark.PythonSparkBuilder

Superclass: handle

```text
PythonSparkBuilder Class for compiling MATLAB files for Spark
 
  This class is a wrapper for the build process in different
  SparkContexts. 
  The base, and most important use case, is for building Python
  libraries, with wrappers for making the code adhere to Spark APIs.
 
   Please refer to the documentation delivered in this package for
   usage examples.
```

#### compiler.build.spark.PythonSparkBuilder.PythonSparkBuilder

```text
PythonSparkBuilder Constructor
 
  See the help for compiler.build.spark.pythonPackage for an
  explanation on arguments to this constructor. In general, the
  pythonPackage function should be used instead of directly
  instantiating this object.

    Documentation for compiler.build.spark.PythonSparkBuilder
```

#### compiler.build.spark.PythonSparkBuilder.addArtifact

```text
addArtifact Add artifact and import python classes
 
  This is a helper method for the PythonSparkBuilder. It performs two
  important steps when using the addArtifact functionality of
  Spark-Connect. 
 
   1. It adds the artifact to the Spark Session
   2. It executes the necessary Python imports of the corresponding
      library. This will execute in the local MATLAB and is necessary for
      this workflow.
 
  If using this with the `plusPi` function in the `CompiledMATLAB`
  example (the plusPi function simply adds PI to a double column x).
  This can be found in this directory:
    databricksRoot('examples', 'DatabricksConnectWorkflow', 'CompiledMATLAB')
 
  PSB = buildLibrary();
  spark = getDatabricksSession();
  PSB.addArtifact(spark)
  
  R = spark.range(100);
  DF = R.withColumn("x", R.col("id").cast('double')).select('x');
  OUT = DF.groupBy("x").applyInPandas("plusPi_applyInPandas", schema="plusPi_output_schema");
  OUT.show(3, false);
  +-----------------+
  |pp               |
  +-----------------+
  |3.141592653589793|
  |4.141592653589793|
  |5.141592653589793|
  +-----------------+
  only showing top 3 rows
```

#### compiler.build.spark.PythonSparkBuilder.addFile

```text
compiler.build.spark.PythonSparkBuilder/addFile is a function.
    addFile(obj, file)
```

#### compiler.build.spark.PythonSparkBuilder.addHelperFilesToBuild

```text
addHelperFilesToBuild
```

#### compiler.build.spark.PythonSparkBuilder.build

```text
build Start the build of a PythonSparkBuilder object to produce a .whl file
 
  This method takes a number of optional arguments. In almost all cases
  the default values should be used.
 
  Optional arguments:
         clean: Remove previous build (default: true)
 
    genHelpers: Generate the partition helpers (default: true)
 
   genWrappers: Generate the wrapper file (default: true)
 
   createWheel: Create the wheel file (default: true)
 
    wheelCheck: Verify the wheel doesn't contain any non-Linux files
                (default: true if working with Databricks, false: otherwise)
```

#### compiler.build.spark.PythonSparkBuilder.clean

```text
clean Clean the build
```

#### compiler.build.spark.PythonSparkBuilder.clearMATLABWriter

```text
compiler.build.spark.PythonSparkBuilder/clearMATLABWriter is a function.
    clearMATLABWriter(obj)
```

#### compiler.build.spark.PythonSparkBuilder.clearPythonWriter

```text
compiler.build.spark.PythonSparkBuilder/clearPythonWriter is a function.
    clearPythonWriter(obj)
```

#### compiler.build.spark.PythonSparkBuilder.clearStringWriter

```text
compiler.build.spark.PythonSparkBuilder/clearStringWriter is a function.
    clearStringWriter(obj)
```

#### compiler.build.spark.PythonSparkBuilder.createWheel

```text
createWheel Create a wheel for the Python package
```

#### compiler.build.spark.PythonSparkBuilder.createZipArtifact

```text
createZipArtifact Create a zip-file that will work with zipimporter
```

#### compiler.build.spark.PythonSparkBuilder.determineMethodTypes

```text
determineMethodTypes Determine what methods must be created
 
  The methods will differ for different function signatures.
```

#### compiler.build.spark.PythonSparkBuilder.genPartitionHelpers

```text
genPartitionHelpers
```

#### compiler.build.spark.PythonSparkBuilder.genPythonSetup

```text
genPythonSetup Create new setup.py file for install/dist/etc.
```

#### compiler.build.spark.PythonSparkBuilder.generateExamples

```text
generateExamples Generate examples from PythonSparkBuilder
```

#### compiler.build.spark.PythonSparkBuilder.generateMATLABUDFHelpers

```text
generateMATLABUDFHelpers Generate UDF helpers
```

#### compiler.build.spark.PythonSparkBuilder.generatePythonExample

```text
generatePythonExample Generate a simple example to see how the
  methods are used
```

#### compiler.build.spark.PythonSparkBuilder.generateSparkShellHelper

```text
generateSparkShellHelper Generate a shell script for interactive test
```

#### compiler.build.spark.PythonSparkBuilder.generateWrapper

```text
generateWrapper Wrapper for easier handling of Python library
```

#### compiler.build.spark.PythonSparkBuilder.getAPIs

```text
getAPIs Retrieve APIs from File entries
 
  These APIs consist of the python helper functions generated.
  The output can be either flat (default), or structured. In the
  structured case, the APIs are organized by the file they were
  generated for.
```

#### compiler.build.spark.PythonSparkBuilder.getFileArguments

```text
compiler.build.spark.PythonSparkBuilder/getFileArguments is a function.
    [raw, args] = getFileArguments(~, file)
```

#### compiler.build.spark.PythonSparkBuilder.getImports

```text
getImports Return imports from files
```

#### compiler.build.spark.PythonSparkBuilder.getWheelFile

```text
getWheelFile Return name of wheel file
```

#### compiler.build.spark.PythonSparkBuilder.init

```text
compiler.build.spark.PythonSparkBuilder/init is a function.
    init(obj)
```

#### compiler.build.spark.PythonSparkBuilder.installWheelOnDatabricksCluster

```text
INSTALLWHEELONDATABRICKSCLUSTER Upload wheel to Databricks
 
  This method is only relevant when using the matlab-spark-api package
  in a Databricks context.
 
  This method can upload the wheel file either to a Volume, Workspace or DBFS.
  Libraries store on DBFS are not supported on Shared clusters,
  see: https://docs.databricks.com/en/libraries/index.html
 
  Upload to a volume:
    PSB.installWheelOnDatabricksCluster("/Volumes/mycatalog/myschema/myvolume/some/directory")
  
  Upload to DBFS:
    PSB.installWheelOnDatabricksCluster("dbfs:/some/directory")
 
  Upload to a Workspace:
    PSB.installWheelOnDatabricksCluster("/Users/user@example.com/some/directory")
  
  Optional arguments are available for choosing cluster and/or auth
  methods. The optional arguments are:
 
    clusterId   A cluster id
    authMethod  The authorization method to use
    profileName The profile to use
```

#### compiler.build.spark.PythonSparkBuilder.setCallCtx

```text
compiler.build.spark.PythonSparkBuilder/setCallCtx is a function.
    setCallCtx(obj, cc)
```

#### compiler.build.spark.PythonSparkBuilder.setMATLABWriter

```text
compiler.build.spark.PythonSparkBuilder/setMATLABWriter is a function.
    setMATLABWriter(obj, MW)
```

#### compiler.build.spark.PythonSparkBuilder.setPythonWriter

```text
compiler.build.spark.PythonSparkBuilder/setPythonWriter is a function.
    setPythonWriter(obj, PyW)
```

#### compiler.build.spark.PythonSparkBuilder.setScopedCallContext

```text
setScopedCallContext Set call context
  Returns a variable, which is a onCleanup object which resets
  the context afterwards
```

#### compiler.build.spark.PythonSparkBuilder.setStringWriter

```text
compiler.build.spark.PythonSparkBuilder/setStringWriter is a function.
    setStringWriter(obj, SW)
```

#### compiler.build.spark.PythonSparkBuilder.uploadExampleNotebooks

```text
uploadExampleNotebooks Upload example notebooks to Databricks
 
  uploadPath is a folder in the databricks Workspace, e.g.
 
   uploadPath = "/Users/user@example.com/myexamples"
 
  If the folder doesn´t exist, it will be created.
 
  The function will output information with links to the notebooks,
  unless this is explicitly turned off with the option showURLS=false
 
    
  PSB.uploadExampleNotebooks("/Users/user@example.com.com/myexamples")
  Import path: /Users/user@example.com.com/myexamples/plusPi_example
  Uploaded notebook plusPi_example
  Import path: /Users/user@example.com.com/myexamples/doMath_example
  Uploaded notebook doMath_example
  Import path: /Users/user@example.com.com/myexamples/addStringCol_example
  Uploaded notebook addStringCol_example
  Import path: /Users/user@example.com.com/myexamples/tblPlus_example
  Uploaded notebook tblPlus_example
  Import path: /Users/user@example.com.com/myexamples/myArr_example
  Uploaded notebook myArr_example
```

#### compiler.build.spark.PythonSparkBuilder.uploadWheelFile

```text
uploadWheelFile Upload the wheel file
 
  This method is currently only supported on Databricks. If the option
  wheelDestination was used during build, it doesn't need an argument
  for the destination. The destination should either be a Volume directory or
  a Workspace directory. This function will return true if the upload
  was successful, false otherwise.
 
  Call it like this:
    PSB.uploadWheelFile(destination="/Volumes/main/default/myvolume/MyWheels");
 
  or if wheelDestination was specified during build:
    PSB.uploadWheelFile();
 
       destination : A directory to upload to
 
        authMethod : A matlab.databricks.AuthMethod.
 
       profileName : A configuration file profileName value.
```

#### compiler.build.spark.PythonSparkBuilder.useMetrics

```text
useMetrics Helper method to decide if to use Metrics
```

### compiler.build.spark.TicTocHelper

Superclass: handle

```text
TicTocHelper Helper class for generating tic/toc measurements
```

#### compiler.build.spark.TicTocHelper.TicTocHelper

```text
TicTocHelper Helper class for generating tic/toc measurements

    Documentation for compiler.build.spark.TicTocHelper
```

#### compiler.build.spark.TicTocHelper.delete

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

#### compiler.build.spark.TicTocHelper.endMeasurement

```text
compiler.build.spark.TicTocHelper/endMeasurement is a function.
    endMeasurement(obj)
```

#### compiler.build.spark.TicTocHelper.initMeasurement

```text
compiler.build.spark.TicTocHelper/initMeasurement is a function.
    initMeasurement(obj)
```

### compiler.build.spark.pythonPackage

```text
compiler.build.spark.pythonPackage Spark builder for Python
 
   Please refer to the documentation delivered in this package for
   PythonSparkBuilder for usage examples.
 
  Arguments:
   buildOpts - A required argument of type compiler.build.PythonPackageOptions
 
   partialTables - An option that makes it possible to use a table as input,
       that lacks certain columns. The functions compiled must be
       written to handle missing columns.
       Default: false
 
  tryCatch (experimental) - This option encloses the calling of the
       compiled function in a try/catch statement, and ensures that a
       job will not fail because one section fails in the MATLAB
       function. If the MATLAB function fails, an empty table will be
       returned, and some messages will be written to stderr, which can
       be found in the cluster-logs if turned on. Please note that this
       is a sort of "silent error" and should be used with caution.
       Default: false
 
  tryCatchErrorColumn (experimental) - This option is only active
       together with the tryCatch option. It can be used to return the
       error message when the compiled MATLAB function fails in a
       certain column. The column must exist in the output table and
       be of type string.
 
  wheelDestination - A string for the directory where the wheel file
       should be uploaded. This feature is currently only supported on
       Databricks. It will create a %pip install line in the example
       python files/notebooks that are generated, and can be used with
       the uploadWheel method.
 
  debug - Internal development option. Undocumented.
```

------

**Copyright 2020-2026 The MathWorks Inc.**

[//]: # (Documentation generation settings: )
[//]: # (* Including class level help text )
[//]: # (* Including constructor help text )
[//]: # (* Excluding inherited methods )
[//]: # (* Excluding default MATLAB classes )
[//]: # (* Generated: 07-May-2026 09:56:23 )
