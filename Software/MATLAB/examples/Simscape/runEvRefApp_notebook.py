# Databricks notebook source
%pip install /Volumes/main/default/myvolume/MyWheels/sldemo_virtualvehicleref-23.2.0-py3-none-any.whl --force-reinstall

# COMMAND ----------

# MAGIC %restart_python

# COMMAND ----------

from pyspark.sql import SparkSession
from pyspark.sql.functions import concat,col,lit
from pyspark.sql.functions import udf
from pyspark.sql.types import *
from pyspark.testing import assertDataFrameEqual
import datetime


# COMMAND ----------

# Import special functions from wrapper
from sldemo.virtualvehicleref.wrapper import runEvRefApp_output_names
from sldemo.virtualvehicleref.wrapper import runEvRefApp_output_schema
from sldemo.virtualvehicleref.wrapper import runEvRefApp_mapPartitions
from sldemo.virtualvehicleref.wrapper import runEvRefApp_applyInPandas
from sldemo.virtualvehicleref.wrapper import runEvRefApp_mapInPandas


# COMMAND ----------

# Methods 
def C_data_F1_t__ex(num):
    return float(num)

def C_data_F2_xdot__ex(num):
    return float(num)

def C_data_F3_deviceID__ex(num):
    a = num//26
    b = num % 26
    return chr(a+65) + chr(b+65) + str(num)

def C_data__ex(num):
    return (
        C_data_F1_t__ex(num+1),
        C_data_F2_xdot__ex(num+2),
        C_data_F3_deviceID__ex(num+3),
    )


DATA = list()
NUM_ROWS = 1000

for di in range(NUM_ROWS):
    DATA.append(C_data__ex(di))

# Create a dataframe from the example data
dfSchema = StructType([StructField('t', DoubleType(), True), StructField('xdot', DoubleType(), True), StructField('deviceID', StringType(), True)])

DF = spark.createDataFrame(DATA, dfSchema)

print("### Show example data")
DF.printSchema()
DF.show(10, False)

# Create a database view of the data
DF.createOrReplaceTempView('temptest_runEvRefApp')


# COMMAND ----------

print(f'Partitions: {DF.rdd.getNumPartitions()}')

# COMMAND ----------

# Running the Simulink algorithm with mapInPandas
DF_mapInPandas = DF.mapInPandas(runEvRefApp_mapInPandas, schema=runEvRefApp_output_schema)

# COMMAND ----------

save_name = f'/Volumes/main/default/myvolume/MyOutputs/evapp_NR{NUM_ROWS}'
save_name

# COMMAND ----------

DF_mapInPandas.write.format('delta').mode('overwrite').save(save_name)

# COMMAND ----------

DF_Processed = spark.read.format('delta').load(save_name)

display(DF_Processed)
