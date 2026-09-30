# Standalone JDBC database interface

The StandaloneJDBCConnection class is designed to provide standalone
functionality which can be used independently of the wider MATLAB&reg; Interface
for Databricks&reg; package.
This class has no external dependencies to the Databricks, making this
class simpler to integrate in certain scenarios where a Database Toolbox&trade; based
interface *only* is required, i.e. other interfaces such as the REST API or
Databricks Connect are not required. A JSON settings file is also
typically used. A template can be found in:
  `/Software/MATLAB/config/databricks_standalone_jdbc_settings.json`

> The standalone interface does not yet support the Databricks OSS JDBC driver,
> only the older Simba based driver.

Settings are applied with the following precedence:

  1) Arguments ot the constructor
  2) Values defined in databricks_standalone_jdbc_settings.json where present
  3) Defaults defined in configureDefaults where present

By design this class does not use the same configuration and settings files
as the wider MATLAB Interface for Databricks package.
Required values for which a default is not defined must be provided as
function arguments.

The expectation is that this file will be copied outside the context
of the Databricks package and so the MATLAB path is searched for the
location of the databricks_standalone_jdbc_settings.json file.
All fields in the JSON file are specified as scalar strings.

If using the wider package then the `databricks.JDBCConnection` class provides
similar functionality with deeper integration and so is then recommended.

The primary role of this class is to construct the connection URL used
by the Databricks JDBC driver. Essentially this URL combines a large number
of configuration values. This is somewhat error prone to construct by hand.

The Connection object is stored in the Connection property.

MATLAB R2022b or later and Database Toolbox are required.

The following optional named arguments can be used to override the values
obtained from the JSON file. Aside from a logical verbose flag arguments are
scalar strings as the package's dedicated classes and enumerations are
assumed not to be available.

| Name                    | Required |  Default            | Description                       |
| ----------------------- | -------- | ------------------- | --------------------------------- |
| settingsFile            |          | databricks_standalone_jdbc_settings.json | Non default must be set as a function argument |
|                         |          |                     | |
| host                    |   Yes    |                     | Workspace URL e.g. "https://adb-1234567890123456.1.azuredatabricks.net" |
| port                    |   Yes    | 443                 | Port used by the driver, specified as a string |
| orgId                   |   Yes    |                     | Workspace org_id e.g. "1234567890123456" |
| clusterId               |   Yes    |                     | Id of cluster or SQL Warehouse e.g. "0912-173539-zf4ob0md" |
| schema                  |   Yes    |                     | Name of the database/schema to use |
| catalog                 |   Yes    |                     | Name of the Unity Catalog catalog |
|                         |          |                     | |
| authMethod              |   Yes    | OauthU2M            | Authentication method, one of PAT, OauthU2M, OauthM2M |
| token                   |          |                     | Token if using authMethod PAT |
| clientId                |          |                     | Client Id if using OauthM2M |
| clientSecret            |          |                     | Client secret if using OauthM2M |
| passthroughAccessToken  |          |                     | Value for an access token that is passed opaquely |
| passthroughRefreshToken |          |                     | Value for a refresh token that is passed opaquely |
| enableTokenCache        |          | 1                    | 1 or 0, specified as a string, enable caching of Oauth Tokens |
| tokenCachePassPhrase    |          | InsecureTokenCachePassPhrase | Optional pass phrase to protect cached tokens |
|                         |          |                     | |
| scope                   |          |                     | Sets the scope used with Oauth flows |
| oauthService            |   Yes    | Databricks          | Oauth service provider one of Databricks, EntraID, Unspecified |
| oauth2ClientId          |          | databricks-sql-jdbc | Defaults to: databricks-sql-jdbc |
| vendor                  |          |                     | Set to azure or aws |
|                         |          |                     | |
| driverClass             |   Yes    | com.databricks.client.jdbc.Driver | JDBC driver class |
| jarFilePath             |   Yes    |                     | Path to the downloaded JDBC driver jar file |
|                         |          |                     | |
| connectionURL           |          |                     | Overrides the complete connection URL value |
| connectionURLAppend     |          |                     | Value appended to the connection URL, can be used to add further values to the connection URL |
| httpPath                |          |                     | Overrides the httpPath portion of the connection URL |
| ssl                     |          | 1                   | 1 or 0, specified as a string |
| thriftTransport         |          |                     | Thrift transport flag |
|                         |          |                     | |
| logLevel                |          | 0                   | Specified as a string |
| verbose                 |          | 1                   | Function argument only, specified as a logical |

The following authentication arguments are required:

| Auth method | Authentication arguments |
| ----------- | ------------------------ |
| PAT         | token                    |
| OauthU2M    | None                     |
| OauthM2M    | clientId & clientSecret  |

If a `passthroughAccessToken` and optional `passthroughRefreshToken` are provided
They will be used directly as passthrough value for authentication and the
drivers authentication mechanisms will not be used. Be aware that access
tokens typically expire after a certain amount of time, after which you must
either refresh the token or obtain a new token(s).

This class requires the Databricks JDBC driver v2.7.3 or greater.
The driver must be downloaded from
[Databricks](https://www.databricks.com/spark/jdbc-drivers-archive). The `jarFilePath`
argument or JSON settings file can be used to specify the path to the driver. See
[Installing JDBC Driver](InstallingJDBCDriver.md) for download and Java version
compatibility details.
The driver's license can be found here:
      [https://www.databricks.com/legal/jdbc-odbc-driver-license](https://www.databricks.com/legal/jdbc-odbc-driver-license)

This function assumes that the driver file has been added to the MATLAB dynamic
Java&reg; class path, see the `javaaddpath()` command.

The class is not added to the MATLAB path by the package as it is intended to be
used in isolation and so should be added to the path manually or as part of a wider
code base.

This functionality is independent of the `Spark.sql()` functionality which
can also be used to execute SQL commands on Databricks.

Call the Connection's close method when the connection is no longer needed.
The object's close method will also call the connection's close method.

If a connection cannot be created an empty `database.jdbc.connection` is returned
in the connection property. If a JDBC Driver Error is returned in the connection's
Message property it will be displayed but an error will not be raised directly.

Example:

```matlab
% Can be moved to a namespace if desired
% Not added to the path by the package
j = StandaloneJDBCConnection(schema='myDatabaseName', ...);
conn = j.Connection;

j = StandaloneJDBCConnection; % Use default schema/database name from the settings file
resultTable = fetch(j.Connection, "SELECT * from myTableName")
```

Sample `databricks_standalone_jdbc_settings.json` file:

```json
{
    "host":"https://adb-1234567890123456.1.azuredatabricks.net",
    "port": "443",
    "orgId": "1234567890123456",
    "clusterId": "1234-123456-abcdefgh",
    "schema": "myschema",
    "catalog": "mycatalog",

    "authMethod": "OauthU2M",
    "token":"",
    "clientId": "",
    "clientSecret": "",
    "passthroughAccessToken": "",
    "passthroughRefreshToken": "",
    "enableTokenCache": "",
    "tokenCachePassPhrase": "",

    "scope": "",
    "oauthService": "Databricks",
    "oauth2ClientId": "databricks-sql-jdbc",
    "vendor": "",

    "driverClass": "com.databricks.client.jdbc.Driver",
    "jarFilePath": "/path/to/databricks-jdbc-2.8.0.jar",

    "connectionURL": "",
    "connectionURLAppend": "",
    "httpPath": "",
    "ssl": "1",
    "thriftTransport": "",

    "logLevel": "0",
    "verbose": "1"
}
```

Values set to "" are ignored.

If specifying a `jarFilePath` argument using a Windows&reg; path that contains "\" symbols.
In the JSON settings file escape any slashes with an additional slash as
required by JSON syntax, e.g.: `"jarFilePath": "c:\\mydir\\databricks-jdbc-2.8.0.jar",`

See also: [https://docs.databricks.com/en/_extras/documents/Databricks-JDBC-Driver-Install-and-Configuration-Guide.pdf](https://docs.databricks.com/en/_extras/documents/Databricks-JDBC-Driver-Install-and-Configuration-Guide.pdf)

[//]: #  (Copyright 2024-2025 The MathWorks, Inc.)
