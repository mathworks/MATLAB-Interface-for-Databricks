// Databricks notebook source
// dbutils.widgets.removeAll()
dbutils.widgets.text("massLow", "1400", "Low mass")
dbutils.widgets.text("massHigh", "1500", "High mass")
// dbutils.widgets.help

// COMMAND ----------

val lowMass = dbutils.widgets.get("massLow").toLong
val highMass = dbutils.widgets.get("massHigh").toLong

// COMMAND ----------

// DBTITLE 1,Create a timestamp to use with names
// Get timestamp for results folder
import java.time.format.DateTimeFormatter
import java.time.LocalDateTime
val date = LocalDateTime.now()
val timeStamp = date.format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"))
val dirName = "/dbfs/example/output/sl3dof_" + timeStamp
val dirFile = new java.io.File(dirName)
val dirCreated = dirFile.mkdir();


// COMMAND ----------

// DBTITLE 1,Create Dataset as input for mapping function
import org.apache.spark.sql.functions.{concat,lit}
val ds = spark.range(lowMass, highMass)
val baseName = dirName + "/mass_"
val ds2 = ds
  .withColumn("oname", concat(lit(baseName), ds.col("id").cast("String")))
  .withColumn("mass", ds.col("id").cast("Double"))

val inputs = ds2.select("oname", "mass")
inputs.show(5, false)
inputs.printSchema
inputs.count


// COMMAND ----------

// DBTITLE 1,Import MATLAB library and initizalie it
import com.mathworks.demo.sl3dof.Map3DOFWrapper
Map3DOFWrapper.initEncoders(spark)

// COMMAND ----------

// DBTITLE 1,Just call the function once
// Just checking that this works
// val outVal = Map3DOFWrapper.deployParameterTuning("/dbfs/example/output/3dof_manually", 1400.0)

// COMMAND ----------

// DBTITLE 1,Run simulations in Spark job
// Run the simulation for different parameters
val resultsFolder = "dbfs:/example/output/runtime_3dof_" + timeStamp
val t0 = System.currentTimeMillis
val outputs = inputs
  .mapPartitions(Map3DOFWrapper.deployParameterTuning_mapPartitions(), Map3DOFWrapper.deployParameterTuning_encoder)
  .withColumnRenamed("_1", "elapsedTime")
  .withColumnRenamed("_2", "outName")
  .withColumnRenamed("_3", "hostName")

outputs.write.format("parquet").option("overwrite", "true").save(resultsFolder)
val t1 = System.currentTimeMillis
val realTime = (t1-t0) / 1000.0

// COMMAND ----------

// DBTITLE 1,Load the results
val results = spark.read.format("parquet").load(resultsFolder)
results.show(5,false)
val numResults = results.count

// COMMAND ----------

// DBTITLE 1,Collect some statistics
import org.apache.spark.sql.functions._

val sumTime = results.agg(sum("elapsedTime")).first.getDouble(0)
val numFiles = inputs.count
val meanTime = sumTime / numResults

// COMMAND ----------

// DBTITLE 1,Verify host performance
// val realTime = 4.30*60.0 // Time taken from collect phase above
print(s"Speed improvement: ${sumTime/realTime}\n")
val hostGroup = results.groupBy("hostName")
val hostCount = hostGroup.count().withColumnRenamed("hostName", "host")
val hostTime = hostGroup.sum("elapsedTime").withColumnRenamed("sum(elapsedTime)", "sum")
val hostMean = hostGroup.mean("elapsedTime").withColumnRenamed("avg(elapsedTime)", "avg")
val J = hostCount.join( hostTime, hostCount("host") === hostTime("hostName"))
    .select("host", "count", "sum")
val J2 = J.join( hostMean, J("host") === hostMean("hostName"))
    .select("host", "count", "sum", "avg")
J2.show(false)


// COMMAND ----------

// DBTITLE 1,Read in full dataset
val dbfsDirName = dirName.replace("/dbfs", "dbfs:")
val MAT = spark.read.format("parquet").load(dbfsDirName)
MAT.count

// COMMAND ----------


