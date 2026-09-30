# Installing the Databricks JDBC driver

Using MATLAB® it is possible to connect to a variety of databases. The MathWorks
[Database Toolbox™](https://mathworks.com/products/database.html) is often used
to connect to databases in a user friendly manner using ODBC/JDBC connections.
The following describes how to connect to Databricks&reg; using Database Toolbox
and the Databricks JDBC drivers.

The package supports both Databricks JDBC drivers:

* Versions >= 2.7.3 and < 3.0.0 (the non-OSS Simba based driver).
* Versions 3.0.3 and newer (the OSS driver).

The JDBC driver must be downloaded from Databricks. The `jarFilePath` name-value
pair can be used when creating a connection to specify the path to the driver.

Links to the licenses for the Databricks drivers:

* JDBC (Simba) [https://www.databricks.com/legal/jdbc-odbc-driver-license](https://www.databricks.com/legal/jdbc-odbc-driver-license).
* JDBC (OSS) [https://github.com/databricks/databricks-jdbc/blob/main/LICENSE](https://github.com/databricks/databricks-jdbc/blob/main/LICENSE)
* ODBC [https://www.databricks.com/legal/jdbc-odbc-driver-license](https://www.databricks.com/legal/jdbc-odbc-driver-license).

## Downloading the Driver

The Databricks JDBC driver can be downloaded from:
[https://www.databricks.com/spark/jdbc-drivers-archive](https://www.databricks.com/spark/jdbc-drivers-archive)

The correct driver version depends on the Java version used by MATLAB:

| Java version  | Driver version required |
| ------------- | ----------------------- |
| Java 8        | 2.X                    |
| Java 11       | 2.X or 3.X             |
| Java 17+      | 3.X                    |

MATLAB's Java version can be checked using the `version -java` command.

Once downloaded, provide the path to the driver JAR file using the `jarFilePath`
argument:

```matlab
j = databricks.JDBCConnection(jarFilePath="/path/to/databricks-jdbc-2.8.0.jar");
```

## Driver Selection

When both a `jarFilePath` and a `useDriverType` argument are provided, both
are used. If only one is provided, the driver type is inferred from the JAR
file or the argument.

| Driver selected | Driver argument | Jar file Argument |
| --------------- | --------------- | ----------------- |
| Argument based  | OSS/Simba       | OSS/Simba         |
| OSS             | OSS             | Unset             |
| Simba           | Simba           | Unset             |
| OSS             | Unset           | OSS               |
| Simba           | Unset           | Simba             |

When a JDBC Connection is made using `databricks.JDBCConnection` the chosen driver
is added to the dynamic Java class path prior to the invocation of the driver.

## Java version configuration

The OSS driver requires that MATLAB uses a Java environment of v11 or greater,
and so is not compatible with MATLAB's included default Java environment.
MATLAB's Java version can be changed using the [`jenv`](https://www.mathworks.com/help/matlab/ref/jenv.html)
command. If the common `JAVA_HOME` environment variable is defined the `jenv(getenv("JAVA_HOME"))`
command can be convenient. Alternatively a specific path can be set e.g.: `jenv("/usr/local/jre")`.
The version can be reset using `jenv("factory")`. MATLAB must be restarted for a change to take effect.

For information on compatible versions see: [https://www.mathworks.com/support/requirements/openjdk.html](https://www.mathworks.com/support/requirements/openjdk.html).

> MATLAB R2022b cannot use a Java version > 8 and so must use the Databricks Simba driver.

If Java 16 is used the following configuration argument must be passed to Java
`--add-opens=java.base/java.nio=org.apache.arrow.memory.core ALL-UNNAMED`.
See: [https://github.com/databricks/databricks-jdbc](https://github.com/databricks/databricks-jdbc).
To configure MATLAB Java startup options see: [https://www.mathworks.com/help/matlab/matlab_env/java-opts-file.html](https://www.mathworks.com/help/matlab/matlab_env/java-opts-file.html).
It is recommended to avoid version 16 for this reason and that it is not formally qualified with MATLAB.

## Usage

The following documents detail how the various database centric interfaces can be used:

* [JDBC Connection based workflow](JDBCWorkflow.md)
* [ODBC Connection based workflow](ODBCWorkflow.md)
* [Standalone JDBC interface](StandaloneJDBCDatabaseInterface.md)
* [Standalone ODBC interface](StandaloneODBCDatabaseInterface.md)
* [Statement Execution](StatementExecution.md)

[//]: #  (Copyright 2020-2025 The MathWorks, Inc.)
