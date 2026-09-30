# Databricks notebook source
# DBTITLE 1,Example dataset
# Note: you must put the file "diabetes_data.csv" on /Volumes for this example to work (see line 10).
# This needs to be done before running this notebook!  See README.md for more details.

# Example (.csv) data
# Customize the load path to your own /Volumes location
df_PatientData = spark.read.format("csv").option("inferSchema", "true").option("delimiter", ";").option("header", "true").load("/Volumes/main/default/myvolume/Examples/MachineLearning/diabetes_data.csv")

print("\nDataFrame representing sample patient data\n\n")
df_PatientData.show(3, False)

# COMMAND ----------

# DBTITLE 1,Import the compiled MATLAB Machine Learning Model (as a MATLAB library)
# The compiled MATLAB classifier was saved to /Volumes, customize the path:
%pip install /Volumes/main/default/myvolume/Examples/MachineLearning/example.trainedclassifier-24.2.0-py3-none-any.whl
from example.trainedclassifier.wrapper import predOutcomes_mapInPandas, predOutcomes_output_schema
# COMMAND ----------

# DBTITLE 1,Use the trained classifier to predict outcomes
df_PredictedVals = df_PatientData.mapInPandas(predOutcomes_mapInPandas, predOutcomes_output_schema)

df_PredictedVals.show(3, False)

# COMMAND ----------

# DBTITLE 1,Write results back to /Volumes for future use
# Here we show that you could write the results to parquet but other file formats can be used as needed
from datetime import datetime

now = datetime.now() # current date and time
date_time = now.strftime("%Y%m%d_%H%M%S")
# Customize the /Volumes location
fullSaveName = "/Volumes/main/default/myvolume/Examples/MachineLearning/ClassifierResults_" + date_time
df_PredictedVals.write.parquet(fullSaveName)

# COMMAND ----------

# DBTITLE 1,Return save location from the job
# This can be retrieved in MATLAB using jobRun.getOutput()

dbutils.notebook.exit(fullSaveName)
