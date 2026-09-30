# ODBC and Database Toolbox workflow

Before making an ODBC connection to Databricks&reg; it is first necessary to install
the ODBC driver. This package supports the Databricks ODBC driver v2.8.0 and greater.

## ODBC driver installation

Begin with the Databricks provided download and documentation: [https://www.databricks.com/spark/odbc-drivers-download](https://www.databricks.com/spark/odbc-drivers-download).

Work through the documentation [https://docs.databricks.com/integrations/jdbc-odbc-bi.html](https://docs.databricks.com/integrations/jdbc-odbc-bi.html) to install the driver and setup a DSN.

Setting the Thrift Transport type to `HTTP` enables the HTTP Path to be set in the
HTTP options. This value can be found in the Databricks Cluster Advanced options
properties under ODBC/JDBC. The host value refers to the Databricks server hostname
in the same properties. Username and password authentication is typically used with
the username set to `token` and the password set to the Databricks personal access token.

If correctly configured the *Test* results should return `Successfully connected to data source!`.

```{tip}
Apart from using a *ODBC* driver to connect to Databricks through Database Toolbox, it is also possible to connect through [Database Toolbox and a *JDBC* driver](JDBCWorkflow.md).
```

## Creating a connection

The package provides a higher-level class `databricks.ODBCConnection to simplify
creating a connection or alternatively a connection can be manually configured.

## Making a `databricks.ODBCConnection` based connection

ODBCConnection Creates a Database Toolbox&trade; connection object.

> Pending resolution of an apparent ODBC driver bug Oauth, particularly U2M,
> authentication, is not currently supported. It it expected that this issue
> will be resolved in a future release.

The primary role of this class is to construct the connection string used
by the Databricks ODBC driver. Essentially this string combines a large number
of configuration values. This is error prone to construct by hand.

The Connection object is stored in the ODBCConnection's Connection property.
By default the class will use the same authentication provider chain as
used by the REST API interfaces, see Documentation/Authentication.md.

The following optional named arguments can be used to override the values
obtained from settings & configuration files and defaults.

### Optional named argument types and defaults

| Name                   | Type    | Default   |
| ---------------------- | ------- | --------- |
| host                   | string  |           |
| dsnless                | string  |           |
| port                   | string  | "443"     |
| driver                 | string  |           |
| cluster                | databricks.Cluster/string |         |
| ssl                    | logical | true      |
| thriftTransport        | int32   | 2         |
| schema                 | string  | "default" |
| catalog                | string  |           |
| httpPath               | string  |           |
| authMethod             | matlab.databricks.AuthMethod | Settings file authMethod value |
| profileName            | string  | Settings file profileName value |
| passthroughAccessToken | string  |           |
| scope                  | string  |           |
| OauthService           | matlab.databricks.OauthService | matlab.databricks.OauthService.Databricks |
| logLevel               | string  |  "1"      |
| dsnlessAppend          | string  |           |
| verbose                | logical | true      |

### Optional named argument descriptions

| Name                      | Description                                    |
| ------------------------- | ---------------------------------------------- |
| dsnless                   | Overrides the complete connection string value |
| schema                    | Name of the database/schema to use             |
| catalog                   | Set the unity catalog catalog                  |
| httpPath                  | Overrides httpPath connection string value     |
| authMethod                | A non default authentication method            |
| profileName               | Profile name in the `.databrickscfg` file      |
| passthroughAccessToken    | Value for a token that is passed opaquely      |
| scope                     | Set the scope used with Oauth flows            |
| OauthService              | Specify an Oauth service provider              |
| defaultStringColumnLength | Truncation work around value for string lengths > 4000 |
| logLevel                  | Logging level, the default value is: "1"       |
| dsnlessAppend             | A value appended to the connection string      |
| verbose                   | Enable more or less feedback, default is true  |

Call the Connection's close method when the connection is no longer needed.
The object's close method will also call the connection's close method.

If a connection cannot be created an empty `database.odbc.connection` is returned
in the connection property. If an ODBC Driver Error is returned in the connection's
`Message` property it will be displayed but an error will not be raised directly.

Returning a connection generally takes a few seconds.

Example using default authentication file derived default connection details:

```matlab
   o = databricks.ODBCConnection(schema='myDatabaseName');
   conn = o.Connection;
   
   % Use Database Toolbox to read a table of data
   myData = sqlread(conn, 'myDatabaseTable');
```

## Making a manual connection

### Usage in Database Toolbox

To connect to the configured DSN/data source from Database Toolbox there are a
number of options, which options are available may depend on the MATLAB&reg; release.

### Programmatic Access

Since typically username and password are already stored in the DSN and, if possible,
including passwords in code should be avoided, the preferred way to programmatically
connect is using:

```matlab
conn = odbc('DSN=yourDSNName');
```

Where you replace `yourDSNName` with the name of the DSN configured earlier.

Refer to the documentation of the Database Toolbox to learn more about how to then further interact with the `conn` connection object: [https://www.mathworks.com/help/database/relational-databases.html](https://www.mathworks.com/help/database/relational-databases.html)

> MATLAB R2024a introduced a SQLConnectionOptions object to simplify working with ODBC connections: [https://www.mathworks.com/help/database/ug/database.options.odbc.sqlserver.sqlconnectionoptions.html](https://www.mathworks.com/help/database/ug/database.options.odbc.sqlserver.sqlconnectionoptions.html)

### Database Explorer

To connect to Databricks using [Database Explorer](https://www.mathworks.com/help/database/ug/databaseexplorer-app.html)
simply start the Database Explorer App and then under `Connect`, then `ODBC Data Sources`
select the DSN which was created earlier. This will then *always* prompt for username
and password which *must* be entered, even if the username/password were already set
inside the DSN. Typically the username is quite literally `token` and then as password
enter one of your Databricks Personal Access Tokens.

## References

* [https://www.databricks.com/spark/odbc-drivers-download](https://www.databricks.com/spark/odbc-drivers-download)
* [https://docs.databricks.com/en/integrations/odbc/authentication.html](https://docs.databricks.com/en/integrations/odbc/authentication.html)
* [https://docs.databricks.com/en/_extras/documents/Simba-Apache-Spark-ODBC-Connector-Install-and-Configuration-Guide.pdf](https://docs.databricks.com/en/_extras/documents/Simba-Apache-Spark-ODBC-Connector-Install-and-Configuration-Guide.pdf)
* [https://www.databricks.com/legal/jdbc-odbc-driver-license](https://www.databricks.com/legal/jdbc-odbc-driver-license)

[//]: #  (Copyright 2022-2025 The MathWorks, Inc.)
