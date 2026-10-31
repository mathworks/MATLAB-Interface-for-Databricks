# Databricks notebook source
# DBTITLE 1,Create some variables
dbutils.widgets.text('ds_limit', '10000', 'The dataset limit')

# COMMAND ----------

# DBTITLE 1,Get the limit
ds_limit = int(dbutils.widgets.get('ds_limit'))

# COMMAND ----------

# DBTITLE 1,Create the range
R = spark.range(ds_limit)

# COMMAND ----------

# DBTITLE 1,Count it
count = R.count()
print(f'Count: {count}')
