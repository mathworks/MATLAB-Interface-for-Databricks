# SQL Warehouses API

A SQL warehouse is a managed computation resource that allows one to run SQL
commands on data objects within Databricks&reg; SQL, see the
[Databricks documentation](https://docs.databricks.com/en/compute/sql-warehouse/index.html)
for more information.

At the time of writing, SQL warehouses are only available on Databricks
Enterprise workspaces. Trying to use the feature on workspaces which do not
support it will lead to errors being thrown like:

```matlab
Error using databricks.SQLWarehouse.list
Failed to list SQL warehouses
  error_code: FEATURE_DISABLED
  message: DBSQL is not supported on workspace with Standard feature tier. Please contact Databricks support.
```

Even with no SQL warehouses available it may still be possible to connect to
Databricks using Database Toolbox&trade; and the Databricks JDBC driver by connecting
to specific clusters instead of a SQL warehouse, see [JDBCWorkflow.md](JDBCWorkflow.md).

The MATLAB&reg; Interface for Databricks package offers an interface to the
[SQL Warehouses REST API](https://docs.databricks.com/sql/api/sql-endpoints.html)
as well as an option to connect to these SQL warehouses using
[Database Toolbox](https://www.mathworks.com/products/database.html) and the
[Databricks JDBC driver](InstallingJDBCDriver.md) using the `connect` method.

Interaction with the REST API takes place through the `databricks.SQLWarehouse`
class in MATLAB. The class has the same properties as an warehouse in the REST
API, see the
[Databricks documentation on the Get operation](https://docs.databricks.com/sql/api/sql-endpoints.html#get)
for a full overview of the properties and their meaning.

## SQL warehouses REST API (version 2.0)

### List

To list all available SQL warehouses in the [configured](Setup.md)
Databricks workspace, call the static `list` method:

```matlab
warehouses = databricks.SQLWarehouse.list();
```

This will return an array of `databricks.SQLWarehouse` objects. If no warehouses have been
configured an empty `0x0` array of `databricks.SQLWarehouse` objects is returned.

### Create

Creating a SQL warehouse *requires* a number of options to be set and some
*optional* options can be configured as well, see the [Databricks
documentation](https://docs.databricks.com/sql/api/sql-endpoints.html#create)
for exact details and descriptions of these options.

```matlab
% Create an empty SQLWarehouse instance
warehouse = databricks.SQLWarehouse;
% Configure all required options - the actual values are just an example here
warehouse.name = "myNewInstance"
warehouse.cluster_size = "Small";
warehouse.min_num_clusters = 1;
warehouse.max_num_clusters = 2;
% Create the SQL warehouse on Databricks
warehouse.create();
```

If successful `warehouse`'s `id` property is updated with the id of the newly
created warehouse and is then [refreshed](#refresh) such that other properties
like `state` will also be updated (and the `state` would typically then be
`'STARTING'` for a newly created warehouse).

### Refresh

> *NOTE:* This method in the Databricks API is called `Get`. It's called
`refresh` here, to avoid confusion with the built-in MATLAB `get`/`set` methods.

Refresh can be used to update the properties of a SQLWarehouse obtained before
(e.g. through `list`), for example:

```matlab
%% Initial inspection of the warehouses
% List all warehouses
>> warehouses = databricks.SQLWarehouse.list();
% As an example select the second one
>> warehouse = warehouses(2);
% Check the state
>> warehouse.state

ans = 

  WarehouseState enumeration

    STARTING

%% At some later point in time, check whether the state is still the same
% First refresh
>> warehouse.refresh()
% And display the current state
>> warehouse.state

ans = 

  WarehouseState enumeration

    RUNNING
```

Or this can be used to query the information of an warehouse with some known ID,
for example:

```matlab
% Create a SQLWarehouse instance - all its properties will be empty
>> warehouse = databricks.SQLWarehouse;
% Specify a specific known ID - id is then set, but all other properties are still empty
>> warehouse.id = "qfufxboufejuuibuxbz";
% Call refresh - this queries the REST API and all other properties will be filled out
>> warehouse.refresh()
% Show the object
>> warehouse

    warehouse = 
      
        SQLWarehouse with properties:
      
                             id: "qfufxboufejuuibuxbz"
                           name: "myWarehouse"
                   cluster_size: "2X-Small"
                 auto_stop_mins: 10
           spot_instance_policy: COST_OPTIMIZED
                   num_clusters: 1
               min_num_clusters: 1
               max_num_clusters: 1
            num_active_sessions: 0
                          state: RUNNING
                   creator_name: "username@example.com"
                     creator_id: "3141592653589793"
                       jdbc_url: "jdbc:spark://adb-42424242424242.1.azuredatabricks.net:443/default;transportMode=http;ssl=1;AuthMech=3;httpPath=/sql/1.0/warehouses/qfufxboufejuuibuxbz;"
                    odbc_params: [1×1 databricks.datastructures.ODBCParams]
                           tags: [1×1 databricks.datastructures.WarehouseTags]
                         health: [1×1 databricks.datastructures.WarehouseHealth]
                  enable_photon: 1
      enable_serverless_compute: 0
                        channel: [1×1 databricks.datastructures.Channel]
```

`refresh` can also be used to refresh multiple warehouses at once, for example:

```matlab
% Get the list of warehouses, if there are more than one this will be an array
warehouses = databricks.SQLWarehouses.list()
% Update all of those warehouses in one call
warehouses.refresh();
```

### Edit

Edit can be used to change the settings of an existing cluster. See the [REST
API documentation](https://docs.databricks.com/sql/api/sql-endpoints.html#edit)
for more information about what can be changed exactly. To be able to use the
`edit` method, the `id` property *must* be set, as well as any settings that are
to be changed, for example:

```matlab
% Create an SQLWarehouse Instance
warehouse = databricks.SQLWarehouse;
% Specify which instance is to be updated
warehouse.id = "qfufxboufejuuibuxbz";
% Set a modified value
warehouse.name = "My New Name";
% Apply the edit
warehouse.edit();
```

It is for example also possible to first obtain an warehouse through `list`,
modify one or more properties and then apply the edit:

```matlab
% Get the list
warehouses = databricks.SQLWarehouse.list();
% Select the first warehouse
warehouse = warehouses(1);
% Modify two of its settings
warehouse.name = "My New Name";
warehouses.max_num_clusters = 42;
% Apply the edit
warehouse.edit();
```

The `edit` method can only be used on `databricks.SQLWarehouse` scalars and does
*not* work on arrays.

### Start

The `start` method starts existing but stopped SQL warehouses. This can again
operate on an existing `databricks.SQLWarehouse` instance obtained earlier:

```matlab
% List all warehouses
warehouses = databricks.SQLWarehouse.list();
% As an example select the second one
warehouse = warehouses(2);
```

or if a specific id is known, a `SQLWarehouse` instance can be created and its id
can then be set:

```matlab
% Create a SQLWarehouse instance 
warehouse = databricks.SQLWarehouse;
% And specify a specific id
warehouse.id = "qfufxboufejuuibuxbz";
```

Then call the `start` method to actually start the warehouse:

```matlab
warehouse.start();
```

This methods *can* be used on arrays of `databricks.SQLWarehouse` to start
multiple SQL warehouses in one call.

### Stop

Similar to starting SQL warehouses they can be stopped:

```matlab
warehouse.stop();
```

This methods *can* be used on arrays of `databricks.SQLWarehouse` to stop
multiple SQL warehouses in one call.

### Delete

> *NOTE:* This method is called delete in the Databricks API. It is called remove
here, to avoid confusion with the built-in MATLAB delete method. This works
similarly to start and stop, a previously obtained `databricks.SQLWarehouse` can
be used or a new instance with `id` set, can be used:

```matlab
warehouse.remove();
```

This methods *can* be used on arrays of `databricks.SQLWarehouse` to delete
multiple SQL warehouses in one call.

## Connecting to a SQL warehouse with Database Toolbox

To connect to a SQL warehouse using Database Toolbox, Database Toolbox
must be installed, this can be quickly checked using the `ver` command.
Furthermore, the Databricks JDBC driver must be downloaded from
[Databricks](https://www.databricks.com/spark/jdbc-drivers-archive). The `jarFilePath`
argument can be used to specify the path to the driver.
See [JDBC driver installation](InstallingJDBCDriver.md) for details.

Similar to most of the other operations listed above, to connect to a SQL
warehouse, one can first either list the warehouses and then "select" one:

```matlab
% List all warehouses
warehouses = databricks.SQLWarehouse.list();
% As an example select the second one
warehouse = warehouses(2);
```

or if a specific id is known up-front, create a `SQLWarehouse` instance and set
that id:

```matlab
% Create a SQLWarehouse instance 
warehouse = databricks.SQLWarehouse;
% And specify a specific id
warehouse.id = "qfufxboufejuuibuxbz";
```

And then to connect using Database Toolbox and the Databricks JDBC Driver,
simply call connect:

```matlab
conn = warehouse.connect()
```

This uses Database Toolbox' `database` function and the connection
object is the same kind of object as returned by `database`. As always in
Database Toolbox, check the `Message` field of the object to ensure the
connection was successful in which case `Message` will be empty, if there was an
error `Message` will contain the error message.

The `connect` method can only be used on `databricks.SQLWarehouse` scalars and
does not work on arrays.

Use `doc databricks.SQLWarehouse.connect` for further argument details.
The `connect` method uses a `databricks.JDBCConnection` or a `databricks.ODBCConnection`
object to create the returned connection, see: [JDBCWorkflow.md](JDBCWorkflow.md)
or [ODBCWorkflow.md](ODBCWorkflow.md) for additional details. A JDBC connection is
used by default, use the `mode` argument to select ODBC if preferred.

### Using a SQL Warehouse with Database Explorer

Create a warehouse as above but return the xDBCConnection result also.

```matlab
[conn, xDBCConnection] = warehouse.connect()
```

Save the connection as a source, by default the source name will be: `Databricks-<Warehouse Id>`.
By default a source is created when a connection is created but it is not saved
unless `saveSource` is called.

```matlab
xDBCConnection.saveSource()
```

Copy the connection's token to the clipboard for use in the GUI.

```matlab
j.copyToken()
```

Then in the Database Explorer app select the newly created data source. When the
username and password are requested enter "token" as the username and paste the
token value from the clipboard as the password. Once created the app will ask for the
catalog and schema to connect to before displaying a list of tables. One can then
proceed to explore the data and build up queries that can be easily imported into
MATLAB code.

> Currently JDBC is supported. Support for saving ODBC data sources will be enabled
> in a later release.

## Oauth authentication

### OauthU2M - JDBC Driver bug under investigation

Currently the Databricks JDBC driver v2.6.36 produces an incorrect scope value
in certain circumstances when using Oauth, thus preventing the return of a valid
redirect URL. This issue is under investigation with Databricks. While this
interface attempts to use the correct value despite this it may be necessary to
override the scope or other oauth argument fields until the issue is resolved.

Not that if the token value is overridden in Oauth flows the JDBC driver will not
refresh the token which will expire in 1 hour typically, and it must be refreshed
manually. Creating a new connection is the simplest approach, pending a resolution
of the driver issue.

[//]: #  (Copyright 2022-2024 The MathWorks, Inc.)
