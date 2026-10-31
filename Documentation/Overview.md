# Overview

This package provides an interface between MATLAB and Databricks&reg;. It can be used in two ways:

1. With conventional desktop MATLAB running locally or on a cloud hosted VM.
2. With MATLAB running directly on a Databricks cluster, accessed via a web browser.
   In this case the package is used in conjunction with MATLAB on Databricks
   Reference Architecture: [https://github.com/mathworks-ref-arch/matlab-on-databricks](https://github.com/mathworks-ref-arch/matlab-on-databricks).

In both cases the support of your Databricks admin team will be required.
To discuss the MATLAB or Databricks requirements and setup email: <databricks@mathworks.com>.

The packages supports a number of ways to work with Databricks:

## JDBC/ODBC and Database Toolbox workflow

This workflow uses the MathWorks [Database Toolbox™](https://mathworks.com/products/database.html)
to connect MATLAB to Databricks using the Databricks JDBC (recommended) or ODBC drivers.
This workflow is well suited to cases where the amount of data moved between MATLAB
and Databricks is limited. It does not require knowledge of Spark&trade;. For more details see:

* [JDBC Connection from MATLAB to Databricks](JDBCWorkflow.md)
* [ODBC Connection from MATLAB to Databricks](ODBCWorkflow.md)

## Databricks Connect workflow

This approach is particularly useful for development and testing. Databricks Connect
enables remote Spark API calls from MATLAB to a Databricks Cluster. It allows one
to exploit the strength of a Spark cluster in filtering and sorting large volumes
of data and then bring a dataset into MATLAB. The Databricks Connect libraries
used are Python&reg; based, Python 3.10, 3.11 or 3.12 is required. For details see:

* [Databricks Connect example](DBConnectWorkflow.md)

## MATLAB Compiler SDK workflow (Deployed)

In both of the ODBC/JDBC and Databricks Connect workflows the execution of the
MATLAB code remains *local*, i.e. on the desktop. For production work having a
desktop "in the loop" is not convenient or the need to transfer data to and from
the cluster will limit performance the MATLAB code is compiled to Python `.whl`
library using MATLAB&reg; Compiler SDK&trade;. This library is then copied to the cluster
where it can execute directly having access to data on the cluster via Spark.
For details see:

* [PythonSparkBuilder](matlab-spark-api/PythonSparkBuilder.md)
* [Job Workflow](JobWorkflow.md)

## REST API interfaces

Databricks offers various REST APIs for interacting with its services. A number of
these APIs are used to enable enable the previous workflows. These APIs can be
used directly from MATLAB. The package supports:

| API                                          | Description                                                   |
| -------------------------------------------- | ------------------------------------------------------------- |
| [Clusters](ClusterAPI.md)                    | Creating, starting, stopping and listing clusters from MATLAB |
| [Command Execution](CommandExecution.md)     | Execute arbitrary command on a cluster                        |
| [DBFS](DBFS.md)                              | Move small volumes of data to and from DBFS                   |
| [Files](Files.md)                            | Move larger volumes of data to and from Unity Catalog volumes |
| [Jobs](JobsAPI.md)                           | Creating jobs to run compiled MATLAB or notebooks             |
| [Libraries](LibraryAPI.md)                   | Install compiled MATLAB as a libraries on a cluster           |
| [Secrets](SecretsAPI.md)                     | Storing and retrieve secrets on Databricks                    |
| [SQL warehouses](SQLWarehousesAPI.md)        | Managing SQL warehouses for use with Database Toolbox         |
| [Statement Execution](StatementExecution.md) | Execute SQL via REST, i.e. without ODBC, JDBC or Spark        |
| [Tokens](TokenAPI.md)                        | Create and manage of personal access tokens                   |
| [Unity Catalog](UnityCatalogAPI.md)          | Manage Unity Catalog metastores, catalogs, tables & shares    |
| [Workspaces](WorkspacesAPI.md)               | Creating and manage notebooks and other workspace artifacts   |

[//]: #  (Copyright 2020-2026 The MathWorks, Inc.)
