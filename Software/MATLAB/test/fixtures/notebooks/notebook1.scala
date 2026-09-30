
// Notebook to try stuff out
val DS = spark.range(1000)
DS.count

// COMMAND ----------
val DS2 = DS.withColumn("did", DS("id").cast("double"))

// COMMAND ----------
display(DS2)

