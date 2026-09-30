# Databricks notebook source
# MAGIC %md
# MAGIC **Create the Table**

# COMMAND ----------

# MAGIC %sql
# MAGIC   CREATE TABLE main.default.air_quality (device_name STRING, temp INT, humidity LONG);

# COMMAND ----------

# MAGIC %md
# MAGIC **Grant permissions**

# COMMAND ----------

# MAGIC %sql
# MAGIC GRANT USE CATALOG ON CATALOG main TO `a<REDACTED>1`;
# MAGIC GRANT USE SCHEMA ON SCHEMA main.default TO `a<REDACTED>1`;
# MAGIC GRANT MODIFY, SELECT ON TABLE main.default.air_quality TO `a<REDACTED>1`;

# COMMAND ----------

# MAGIC %md
# MAGIC **Show the table**

# COMMAND ----------

display(spark.sql("SELECT * FROM main.default.air_quality LIMIT 100"))

# COMMAND ----------

# MAGIC %md
# MAGIC **Count the number of rows in the table**

# COMMAND ----------

df = spark.table("main.default.air_quality")
display(spark.createDataFrame([(df.count(),)], ["row_count"]))

# COMMAND ----------

# MAGIC %md
# MAGIC **Reset the table**

# COMMAND ----------

spark.sql("DELETE FROM main.default.air_quality")