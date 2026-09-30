# Databricks notebook source
# DBTITLE 1,Load road profile data 
# Customize the .whl path
%pip install /Volumes/main/default/myvolume/Examples/SimulinkSuspension3DoF/demo.suspn3dof_with_input-25.2.0-py3-none-any.whl --force-reinstall 
# Enable if updating already loaded .whl
# %restart_python

# COMMAND ----------

# DBTITLE 1,Load road profile data
# Customize the data path
DS = spark.read.format("parquet").load("/Volumes/main/default/myvolume/Examples/SimulinkSuspension3DoF/data/")

# COMMAND ----------

DS.count()

# COMMAND ----------

# DBTITLE 1,Group by profile & run simulations
from demo.suspn3dof_with_input.wrapper import runModel_spark_with_input_pandas, runModel_spark_with_input_output_schema
OUT = (
  DS
  .repartition(20, "ID")
  .groupBy("ID")
  .applyInPandas(runModel_spark_with_input_pandas(1400), runModel_spark_with_input_output_schema)
)


# COMMAND ----------

# DBTITLE 1,Create output data name suffixes
from datetime import datetime

now = datetime.now() # current date and time
suffix = '_' + now.strftime("%Y%m%d_%H%M%S")

# COMMAND ----------

# DBTITLE 1,Save output data in delta format
# Customize the output path
import time

outName = "/Volumes/main/default/myvolume/Examples/SimulinkSuspension3DoF/output" + suffix
print(outName)

start_time = time.time()

OUT.write.format("delta").save(outName)

elapsed_time = time.time() - start_time

# COMMAND ----------

# DBTITLE 1,Check the saved results
RESULTS = spark.read.format("delta").load(outName)

# COMMAND ----------

# DBTITLE 1,Display one of the results
Road7 = RESULTS.filter("ID LIKE 'Road7'")
display(Road7)
