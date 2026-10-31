// Databricks notebook source
// DBTITLE 1,Load the dataset
// File location and type
val file_location = "/MathWorks/unit-test/data/pumpdata.parquet"
val file_type = "parquet"

// The applied options are for CSV files. For other file types, these will be ignored.
val df = spark.read.format(file_type).load(file_location)
val numRows = df.count
df.show(5, false)

// COMMAND ----------

// DBTITLE 1,Find number of unique IDs
val numUniqueIDs = df.select("VehicleID").dropDuplicates().count().toInt

// COMMAND ----------

// DBTITLE 1,Repartitioning data by VehicleID
val dfp = df.repartition(numUniqueIDs, df.col("VehicleID"))
val numPartitions = dfp.rdd.getNumPartitions
val numRows = dfp.count

// COMMAND ----------

// DBTITLE 1,Initialize MATLAB library
import com.mathworks.demo.bobby.TablesWrapper
TablesWrapper.initEncoders(spark)

// COMMAND ----------

// DBTITLE 1,Run normalizeStuff function on tables from partitions
val dfpN = dfp.mapPartitions(TablesWrapper.normalizeStuff_mapPartitions(), TablesWrapper.normalizeStuff_encoder)
dfpN.count

// COMMAND ----------

// DBTITLE 1,Show results
dfpN.show(5, false)

// COMMAND ----------

// DBTITLE 1,Call mapPartitions on one vehicle
// Filter out one ID and calculate this
val NN = df.filter("VehicleID like 'DLQRT'").mapPartitions(TablesWrapper.normalizeStuff_mapPartitions(), TablesWrapper.normalizeStuff_encoder)
  .toDF("Time_sec", "VehicleID", "CmdCurrent", "EngineSpeed")
NN.show(5, false)

