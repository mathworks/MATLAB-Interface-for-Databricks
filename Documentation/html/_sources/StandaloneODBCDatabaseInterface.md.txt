
# Standalone ODBC database interface

The `StandaloneODBCConnection` class creates an ODBC based Database Toolbox&trade; connection
This class is designed to provide a standalone functionality which can be
used independently of the wider MATLAB&reg; Interface for Databricks&reg; package.
This class has no external dependencies to the Databricks, making this
class simpler to integrate in certain scenarios where a Database Toolbox based
interface only is required, i.e. other interfaces such as the REST API or
Databricks Connect are not required. A JSON configuration file is also
required. A template can be found in: `Software/MATLAB/config/databricks_standalone_odbc_settings.json`
This file sets certain required default values.
The source code can be found in `Software/MATLAB/Standalone/source`.

The expectation is that this file will be copied outside the context
of the Databricks package and so the MATLAB path is searched for the
location of the `databricks_standalone_odbc_settings.json` file.

If using the wider package then the databricks.ODBCConnection class provides
similar functionality with deeper integration and so is then recommended.

The primary role of this class is to construct the connection URL used
by the Databricks ODBC driver. Essentially this URL combines a large number
of configuration values. This is error prone to construct by hand.

The Connection object is stored in the Connection property.

MATLAB R2022b or later and Database Toolbox are required.

The following optional named arguments can be used to override the values
obtained from the JSON file. All optional arguments are of type string as
the package's dedicated classes and enumerations are assumed not to be
available.

| Name                      | Required |  JSON file default | Description                       |
| ------------------------- | -------- | ------------------ | --------------------------------- |
| settingsFile              |          | databricks_standalone_odbc_settings.json | Function argument only |
|                           |          |                    | |
| host                      |   Yes    |                    | Workspace URL e.g. "https://adb-1234567890123456.1.azuredatabricks.net" |
| port                      |   Yes    | 443                | Port used by the driver, specified as a string |
| orgId                     |   Yes    |                    | Workspace org_id e.g. "1234567890123456" |
| clusterId                 |   Yes    |                    | Id of cluster or SQL Warehouse e.g. "0912-173539-zf4ob0md" |
| schema                    |   Yes    |                    | Name of the database/schema to use |
| catalog                   |   Yes    |                    | Name of the Unity Catalog catalog |
|                           |          |                    | |
| authMethod                |   Yes    | OauthU2M           | Authentication method, one of PAT, OauthU2M, OauthM2M |
| token                     |          |                    | Token if using authMethod PAT |
| clientId                  |          |                    | Client Id if using OauthM2M |
| clientSecret              |          |                    | Client secret if using OauthM2M |
| passthroughAccessToken    |          |                    | Value for a token that is passed opaquely N1 |
| tokenCachePassPhrase      |          |                    | Optional pass phrase to protect cached tokens |
|                           |          |                    | |
| scope                     |          |                    | Sets the scope used with Oauth flows |
| oauthService              |   Yes    | Databricks         | Oauth service provider one of Databricks, EntraID, Unspecified |
| oauth2ClientId            |   Yes    | databricks-sql-connector | Used in OauthU2M mode |
|                           |          |                    | |
| dsnless                   |          |                    | Overrides the complete dsnless value |
| dsnlessAppend             |          |                    | Value appended to the dsnless, can be used to add further values to the dsnless |
| driver                    |          |                    | ODBC driver |
| httpPath                  |          |                    | Overrides the httpPath portion of the dsnless |
| ssl                       |          | 1                  | 1 or 0, specified as a string |
| thriftTransport           |          | 2                  | Thrift transport flag |
|                           |          |                    | |
| defaultStringColumnLength |          |                    | Truncation work around value for string lengths > 4000 |
|                           |          |                    | |
| logLevel                  |          | 0                  | Specified as a string |
| verbose                   |          | 1                  | Function argument only, specified as a logical |

* N1: token passthrough an access token obtained by some means is passed as a named
argument. Be aware that access tokens typically expire after a certain amount of
time, after which you must either refresh the token or obtain a new one from the
server.

This class uses the Databricks ODBC driver v2.8.0 and greater.
The driver's license can be found here: [https://www.databricks.com/legal/jdbc-odbc-driver-license](https://www.databricks.com/legal/jdbc-odbc-driver-license).

The class is not added to the MATLAB path by the package as it is intended to be
used in isolation and so should be added to the path manually or as part of a wider
code base.

This functionality is independent of the `Spark.sql()` functionality which
can also be used to execute SQL commands on Databricks.

Call the Connection's close method when the connection is no longer needed.
The object's close method will also call the connection's close method.

If a connection cannot be created an empty database.odbc.connection is returned
in the connection property. If a ODBC Driver Error is returned in the connection's
Message property it will be displayed but an error will not be raised directly.

defaultStringColumnLength Sets the maximum number of characters that can be
contained in STRING columns. By default, the columns metadata for Spark&trade; does
not specify a maximum length for STRING columns. In a future MATLAB release
this can be used to address string truncation for long strings > 4000
characters in length.

Examples:

```matlab
    % Can be moved to a namespace if desired
    % Not added to the path by the package
    o = StandaloneODBCConnection(schema='mySchemaName');
    conn = o.Connection;
    
    o = StandaloneODBCConnection;
    conn = o.Connection;
```

The dsnlessAppend argument can be used to add further values to the
connection string. It is appended to the constructed value.

If using token passthrough an access token obtained by some means is passed
as a named (passthroughAccessToken) argument. Be aware that access tokens
typically expire after a certain amount of time, after which you must
either refresh the token or obtain a new one from the server.

The `databricks_standalone_odbc_settings.json` provides default for the various fields that
are used to authenticate make the connection. Named arguments allows these values
to be overridden. The values set in the sample file are the required values

Sample `databricks_standalone_odbc_settings.json` file:

```json
{
    "host":"https://adb-1234567890123456.1.azuredatabricks.net",
    "port": "443",
    "orgId": "1234567890123456",
    "clusterId": "0912-173539-zf4ob0md",
    "schema": "myschema",
    "catalog": "mycatalog",

    "authMethod": "OauthU2M",
    "token":"",
    "clientId": "",
    "clientSecret": "",
    "passthroughAccessToken": "",
    "tokenCachePassPhrase": "",
    
    "scope": "",
    "oauthService": "Databricks",
    "oauth2ClientId":"databricks-sql-odbc",

    "dsnless": "",
    "driver": "",
    "dsnlessAppend": "",
    "httpPath": "",
    "ssl": "1",
    "thriftTransport": "2",
    
    "logLevel": "0",
    "verbose": "1"
}
```

See also:

* [https://www.databricks.com/spark/odbc-drivers-download](https://www.databricks.com/spark/odbc-drivers-download)
* [https://docs.databricks.com/en/integrations/odbc/authentication.html](https://docs.databricks.com/en/integrations/odbc/authentication.html)
* [https://docs.databricks.com/en/_extras/documents/Simba-Apache-Spark-ODBC-Connector-Install-and-Configuration-Guide.pdf](https://docs.databricks.com/en/_extras/documents/Simba-Apache-Spark-ODBC-Connector-Install-and-Configuration-Guide.pdf)
* [https://www.databricks.com/legal/jdbc-odbc-driver-license](https://www.databricks.com/legal/jdbc-odbc-driver-license)


[//]: #  (Copyright 2024-2025 The MathWorks, Inc.)
