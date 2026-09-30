# MATLAB Database interface for Databricks

This interface is a component of the larger "MATLAB&reg; interface for Databricks&reg;"
support package.
It provides a minimal standalone interface to simplify the creation of
JDBC and ODBC connections to Databricks using Database Toolbox&trade;.

To build the toolbox i.e. the `DatabricksDBInterface.mltbx` file, run the
`Software/MATLAB/Standalone/buildToolbox.m` function. The function will assemble
the required files in the `toolboxFolder`,
by default `Software/MATLAB/Standalone/build`,
and from there build the `.mltbx file`.

The toolbox can be used without needing the parent support package.

The toolbox uses an independent `configuration/credential` file.
Template files are provided:

* `Software/MATLAB/config/databricks_standalone_jdbc_settings.json.template`
* `Software/MATLAB/config/databricks_standalone_odbc_settings.json.template`

MATLAB R2023a or later is required to build the toolbox.
MATLAB R2022b or later is required to use the resulting toolbox.

See also:

* [Documentation/StandaloneJDBCDatabaseInterface.md](Documentation/StandaloneJDBCDatabaseInterface.md)
* [Documentation/StandaloneODBCDatabaseInterface.md](Documentation/StandaloneODBCDatabaseInterface.md)

[//]: #  (Copyright 2024 The MathWorks, Inc.)
