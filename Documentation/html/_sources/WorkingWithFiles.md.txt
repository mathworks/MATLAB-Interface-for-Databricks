# Working with files

There are a number of ways to work with file and file-like interfaces in Databricks&reg;.
This can be confusing but is well documented in the included API level documentation
and by Databricks.

* [Files](Files.md)
* [Workspaces](WorkspacesAPI.md)
* [Unity Catalog](UnityCatalogAPI.md)
* DBFS
  * [DBFS API](DBFS.md)
* [Standard/Shared clusters & storage](Isolation.md)

Furthermore the Spark&trade; API accessible via Databricks connect also enable file access.
MATLAB&reg; has built in support for working directly with cloud based object storage
i.e. in S3 or Azure&reg; Blob see: [https://docs.databricks.com/api/workspace/workspace](https://docs.databricks.com/api/workspace/workspace)

## Storage related FAQ issues

The following entries appear in this package's [FAQ](FAQ.md):

* Saving a .mat file to /dbfs fails
* Spark Submit fails to find jar on dbfs
* Azure Credential Passthrough name resolution in azPTAuth
* No FileSystem for scheme: abfss

### Databricks references

Overview (recommended)

* [https://docs.databricks.com/en/files/index.html](https://docs.databricks.com/en/files/index.html)

APIs

* [https://docs.databricks.com/api/workspace/workspace](https://docs.databricks.com/api/workspace/workspace)
* [https://docs.databricks.com/api/workspace/files](https://docs.databricks.com/api/workspace/files)
* [https://docs.databricks.com/api/workspace/dbfs](https://docs.databricks.com/api/workspace/dbfs)

[//]: #  (Copyright 2024 The MathWorks, Inc.)
