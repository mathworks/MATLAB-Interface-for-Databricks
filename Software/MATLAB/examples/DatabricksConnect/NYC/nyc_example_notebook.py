# Databricks notebook source
dbutils.widgets.text('output_folder', '/tmp/something')

# COMMAND ----------

# MAGIC %pip install "/Volumes/main/default/myvolume/Scratch/demo_nyc-25.2.0-py3-none-any.whl"  --force-reinstall

# COMMAND ----------

output_folder = dbutils.widgets.get('output_folder')
print(output_folder)

# COMMAND ----------

# DBTITLE 1,Load data, as per the in MATLAB Databricks Connect example
nycSrc = '/databricks-datasets/nyctaxi/tables/nyctaxi_yellow'
DS = spark.read.format("delta").load(nycSrc)


# COMMAND ----------

# DBTITLE 1,Filter data, as per the in MATLAB Databricks Connect example
nyc = (
  DS 
  .select("passenger_count", "trip_distance", "fare_amount", "tip_amount") 
  .filter("fare_amount > 80.0 AND fare_amount < 100.0")
      )

# COMMAND ----------

# DBTITLE 1,Import some of the functions from the compiled MATLAB Compiler library
from demo.nyc.wrapper import nycAlgo_applyInPandas, nycAlgo_output_schema

# COMMAND ----------

# DBTITLE 1,Group the data, and run the nycAlgo MATLAB algorithm
OUT = (
  nyc
  .groupBy('passenger_count')
  .applyInPandas(nycAlgo_applyInPandas, nycAlgo_output_schema)
)

# COMMAND ----------

# DBTITLE 1,Display the results
OUT.write.format('parquet').save(output_folder).mode('overwrite')



# COMMAND ----------

OUT.show()
