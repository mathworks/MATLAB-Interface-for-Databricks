# Unity Catalog API

To learn more about Unity Catalog in general, refer to its product page on the
Databricks&reg; website: [https://www.databricks.com/product/unity-catalog](https://www.databricks.com/product/unity-catalog)

## Data Access in MATLAB Interface *for Databricks*

* Data managed by Unity Catalog can be accessed when working through the [JDBC](JDBCWorkflow.md)
and [ODBC](ODBCWorkflow.md) and Database Toolbox&trade; workflows or Databricks Connect v2.

## Management in MATLAB Interface *for Databricks*

* Unity Catalog can be managed through the API, see below.
* Unity Catalog can also be managed by executing the correct manually written SQL
queries through [JDBC](JDBCWorkflow.md) and [ODBC](ODBCWorkflow.md) workflows.

The Unity Catalog Management interface in this package consists of one class `databricks.UnityCatalog`, which contains all API methods and a number of data structure classes in the `databricks.datastructures.unitycatalog` package.

The methods and data structure classes follow the methods and objects described in the Unity Catalog API 2.1 Specification as documented by Databricks:

<https://api-docs.databricks.com/rest/latest/unity-catalog-api-specification-2-1.html>

```{note}
The API on the Databricks end does not appear to behave *exactly* as documented by Databricks. Some of the `force` options of the `delete*` methods do not appear to have an actual effect. Also, updating shared objects does not appear to actually be possible through the `updateShare` operation therefore a separate `updateShareObjects` method has been implemented.
```

Some of the API methods return data structure classes as outputs, some take such data structure classes as inputs. The data structure classes do *not* have methods like `list`, `create` or `update` (the only method the data structure classes have is the static [`fromInputs`](#frominputs-method) helper method). Methods like `listCatalogs`, `createCatalog` and `updateCatalog` are part of the `databricks.UnityCatalog` class.

````{hint}
This is a slightly different architecture than the other Databricks REST API interfaces in the package.

For example in the [Clusters API](ClusterAPI.md), to get Cluster information:

```matlab
% First create a Cluster instance
cluster = databricks.Cluster();
% Then set the ID on this object
cluster.cluster_id = 'abc-def-ghi';
% Then refresh to get its details
cluster.refresh;

% Or to list the clusters, call list method of Cluster class
clusterList = databricks.Cluster.list();
```

But in the Unity Catalog API:

```matlab
% Create the Unity Catalog client instance
uc = databricks.UnityCatalog;

% Get catalog details by calling getCatalog on the client object with catalog
% name as input
catalog = uc.getCatalog('main');

% Or to list catalogs, call listCatalogs on the client object rather than list
% on some Catalog object
catalogList = uc.listCatalogs();
````

## UnityCatalog class

To work with the UnityCatalog class, create an instance:

```matlab
uc = databricks.UnityCatalog;
```

and call the desired methods:

```matlab
metastores = uc.listMetastores();
```

All methods contain help text which can be accessed through the `help` function, for example:

> If running MATLAB&reg; on Databricks use the `doc` command instead of `help`.

```matlabsession
>> help databricks.UnityCatalog.createCatalog
  createCatalog creates a new catalog.

  Example:

    result = uc.createCatalog(cataloginfo);

  Required Inputs:
    cataloginfo
        Description:
            settings/configuration for the new catalog
        Type:
            databricks.datastructures.unitycatalog.CatalogInfo
        Required Properties in the data structure which must be set:
            name
        Optional Properties in the data structure which can be set:
            comment
            ucproperties
            provider_name
            share_name

  Outputs:
    result
        Description:
            settings/configuration of the created catalog
        Type:
            databricks.datastructures.unitycatalog.CatalogInfo

  See Also: databricks.datastructures.unitycatalog.CatalogInfo
```

```{hint}
This can also be called on an object instance, e.g. `>> help uc.createCatalog`.
```

The help text shows exactly what inputs the methods expects and if the input is a data structure object which properties must and can be set. It also shows what output the method returns.

An overview of the methods is listed below. For further details on how to call each method exactly use the `help` function or refer to the full [API Reference](DatabricksAPI.md#databricksunitycatalog) in the documentation.

### Methods

```{eval-rst}
:createCatalog:                   Creates a new catalog.
:createExternalLocation:          Creates a new external location.
:createMetastore:                 Creates a new metastore.
:createMetastoreAssignment:       Creates meta store assignments.
:createProvider:                  Creates a delta sharing provider.
:createRecipient:                 Creates a new delta sharing recipient.
:createSchema:                    Creates a new schema.
:createShare:                     Creates new delta sharing share.
:createStorageCredential:         Creates a new storage credential.
:deleteCatalog:                   Deletes a catalog. 
:deleteExternalLocation:          Deletes an external location.
:deleteMetastore:                 Deletes a metastore.
:deleteMetastoreAssignment:       Deletes a metastore assignment.
:deleteProvider:                  Deletes a delta sharing provider.
:deleteRecipient:                 Deletes a delta sharing recipient.
:deleteSchema:                    Deletes a schema.
:deleteShare:                     Deletes delta sharing share.
:deleteStorageCredential:         Deletes a storage credential.
:deleteTable:                     Deletes a table.
:getArtifactAllowlists:           Gets the artifact allowlist of a certain artifact type.
:getCatalog:                      Gets catalog information.
:getExternalLocation:             Gets external location information.
:getMetastore:                    Gets metastore information.
:getMyGroups:                     Gets group membership information of the user.
:getMyInfo:                       Retrieves current user information as it relates to Unity Catalog.
:getPermissions:                  Gets permissions as set for a given object.
:getProvider:                     Gets delta sharing provider information.
:getRecipient:                    Gets delta sharing recipient information.
:getRecipientSharePermissions:    Gets permissions for the given delta.
:getSchema:                       Gets schema information.
:getShare:                        Gets delta sharing share information.
:getSharePermissions:             Gets permissions of specified delta sharing share.
:getStorageCredential:            Gets storage credential information.
:getTable:                        Gets table information.
:listCatalogs:                    Gets list of catalogs.
:listExternalLocations:           Gets list of external locations.
:listFiles:                       List files in an external URL. 
:listMetastores:                  Lists metastores.
:listProviders:                   Lists delta sharing providers.
:listProviderShares:              Lists delta sharing shares for a given provider.
:listRecipients:                  Lists delta sharing recipients.
:listSchemas:                     Lists schemas in a given catalog.
:listShares:                      Lists delta sharing shares.
:listStorageCredentials:          Lists storage credentials.
:listTables:                      Lists tables in a given catalog and schema.
:listTableSummaries:              Lists high level table information for tables in a given catalog.
:rotateRecipientToken:            Rotates the token for an external recipient.
:setArtifactAllowlist:            Set the artifact allowlist of a certain artifact type.
:updateCatalog:                   Updates catalog settings.
:updateExternalLocation:          Updates external location settings.
:updateMetastore:                 Updates metastore settings.
:updateMetastoreAssignment:       Updates metastore assignment on a given workspace.
:updatePermissions:               Updates permissions on a given object.
:updateProvider:                  Updates delta sharing provider settings.
:updateRecipient:                 Updates delta sharing recipient settings.
:updateSchema:                    Updates schema settings.
:updateShare:                     Updates delta sharing share settings.
:updateShareObjects:              Updates objects on a given delta sharing share.
:updateSharePermissions:          Updates permissions on a delta sharing share.
:updateStorageCredential:         Updates store credential settings.
```

```{note}
As can be seen, `listTables`, `getTable` and `deleteTable` methods exist but there is no `createTable` method. This is a limitation from the Databricks end. Use the Databricks Web Interface or SQL queries through the [JDBC and Database Toolbox workflows](JDBCWorkflow.md) for creating tables.
```

### Authentication and Authorization

The `UnityCatalog` class uses the same [authentication](Authentication.md) as all other API interfaces in the package meaning it can be configured through `databricks.json`, `.databricks-connect` or by setting the `Token` property.

Which methods can be called and/or what exactly certain methods will return, depends on the user's authorization. For example some methods can only be called by Databricks Account Administrators or Workspace Administrators. Also, some of the `list*` methods may only return the objects owned by the user when working as a normal user, and *all* objects when authorized as Account Administrator. For exact details, see the Unity Catalog API specification documentation as provided by Databricks:

<https://api-docs.databricks.com/rest/latest/unity-catalog-api-specification-2-1.html>

## Data Structure Classes

The data structure classes implemented in the `databricks.datastructures.unitycatalog` package are used to return information about Unity Catalog objects to the user when querying or listing object and/or allow the user to configure properties of Unity Catalog objects when creating or updating them.

When a data structure object is required as input to a `create*` or `update*` methods, some of the properties *must* be set, some may be *optional* and some may be ignored by a specific operation, for example:

```{code-block} matlabsession
---
emphasize-lines: 9-20
---
>> help databricks.UnityCatalog.createCatalog
  createCatalog creates a new catalog.

  Example:

    result = uc.createCatalog(cataloginfo);

  Required Inputs:
    cataloginfo
        Description:
            settings/configuration for the new catalog
        Type:
            databricks.datastructures.unitycatalog.CatalogInfo
        Required Properties in the data structure which must be set:
            name
        Optional Properties in the data structure which can be set:
            comment
            ucproperties
            provider_name
            share_name

  Outputs:
    result
        Description:
            settings/configuration of the created catalog
        Type:
            databricks.datastructures.unitycatalog.CatalogInfo

  See Also: databricks.datastructures.unitycatalog.CatalogInfo
```

Shows that when working with the `createCatalog` method a `databricks.datastructures.unitycatalog.CatalogInfo` data structure must be supplied as input. Its `name` property *must* be set and `comment`, `ucproperties`, `provider_name` and `share_name` are *optional*, other properties like `created_by` *cannot* be set by the user. To see all properties of the `CatalogInfo` class, use:

```matlabsession
>> help databricks.datastructures.unitycatalog.CatalogInfo
  CatalogInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.CatalogInfo Properties:
    name - of Catalog relative to parent metastore
    comment - User-supplied free-form text
    ucproperties - Extensible Catalog properties
    owner - Username/groupname of Catalog owner
    provider_name - For Delta Sharing Catalogs: the name of the delta sharing
       provider
    share_name - For Delta Sharing Catalogs: the name of the share under the share
       provider
    metastore_id - Unique identifier of the parent Metastore
    created_at - Date of Catalog creation
    created_by - Username of Catalog creator
    updated_at - Date of last update to Catalog
    updated_by - Username of user who last updated Catalog
```

For a full overview of all data structure classes, refer to the [API Reference](DatabricksAPI.md).

### Usage

In MATLAB to create a data structure instance, simply instantiate an object of the right class:

```matlab
catalog = databricks.datastructures.unitycatalog.CatalogInfo;
```

And then set the properties to the desired values, for example:

```matlab
catalog.name = "MyNewCatalog";
```

Data structures can also be nested, for example `databricks.datastructures.unitycatalog.StorageCredentialInfo` has a property `azure_service_principal` which is of type `databricks.datastructures.unitycatalog.AzureServicePrincipal`. The easiest way to fill-out properties of such nested properties is to work with subscripted assignment:

```matlabsession
% Create the outer object
>> sci = databricks.datastructures.unitycatalog.StorageCredentialInfo;
% Index into the property which holds another object and set one of its properties
>> sci.azure_service_principal(1).application_id = "72330b4c-f020-4736-a588-66168c2360de";
```

Note the `(1)` subscript which will first create the object instance, and it is then immediately possible to set one of its properties, `application_id` in this example, to some value.

Alternatively it is of course also possible to first create an instance of the nested data structure class and then assign it to the property in the outer object:

```matlab
% First create the nested object and set its properties
asp = databricks.datastructures.unitycatalog.AzureServicePrincipal;
asp.application_id = "72330b4c-f020-4736-a588-66168c2360de";
% Create the outer object
sci = databricks.datastructures.unitycatalog.StorageCredentialInfo;
% Assign the entire nested object to the property
sci.azure_service_principal = asp;
```

### fromInputs method

All data structures which may be used as inputs, have a static `fromInputs` method which allows immediately setting properties using Name-Value pairs upon construction. For example, the following one-liner can be used to immediately create a `CatalogInfo` instance with properties `name` and `comment` set to some values:

```matlab
catalog = databricks.datastructures.unitycatalog.CatalogInfo.fromInputs("name","MyNewCatalog","comment","My Comment");
```

And this can also be used in a nested way:

```matlab
% Importing the package is not required but allows writing shorter code
import databricks.datastructures.unitycatalog.*
% Use fromInputs in a nested way
sci = StorageCredentialInfo.fromInputs("azure_service_principal",...
    AzureServicePrincipal.fromInputs("application_id","72330b4c-f020-4736-a588-66168c2360de"));
```

## Example Usage

### Catalog example

This example shows how to list, create, update and delete catalogs. Working with other objects (e.g. schemas) will be very similar.

Import package for shorter code:

```matlabsession
>> import databricks.datastructures.unitycatalog.*
```

Create the client instance

```matlabsession
>> uc = databricks.UnityCatalog();
```

List all catalogs

```matlabsession
>> catalogs = uc.listCatalogs()

catalogs = 

  CatalogInfoList with properties:

    catalogs: [1×2 databricks.datastructures.unitycatalog.CatalogInfo]
```

Show the details of one the catalogs in the list

```matlabsession
>> catalogs.catalogs(1)

ans = 

  CatalogInfo with properties:

             name: "main"
          comment: "Main catalog (auto-created)"
     ucproperties: [0×0 JSONMapperMap]
            owner: "user@example.com"
    provider_name: [0×0 string]
       share_name: [0×0 string]
     metastore_id: "27a49677-ca3a-44f6-934f-090c7d14f232"
       created_at: 11-Jan-2023 15:52:37
       created_by: "user@example.com"
       updated_at: 11-Jan-2023 15:52:37
       updated_by: "user@example.com"
```

Create a new catalog

```matlabsession
>> newCatalogName = "myNewCatalog";
>> newCatalogInfo = uc.createCatalog(CatalogInfo.fromInputs("name",newCatalogName))

newCatalogInfo = 

  CatalogInfo with properties:

             name: "mynewcatalog"
          comment: [0×0 string]
     ucproperties: [0×0 JSONMapperMap]
            owner: "user@example.com"
    provider_name: [0×0 string]
       share_name: [0×0 string]
     metastore_id: "1472f26e-6c88-4d67-9712-d1000cd7e2e9"
       created_at: 26-Jan-2023 11:08:32
       created_by: "user@example.com"
       updated_at: 26-Jan-2023 11:08:32
       updated_by: "user@example.com"
```

Update the comment property of this catalog

```matlabsession
>> updatedCatalogInfo = uc.updateCatalog(newCatalogName, CatalogInfo.fromInputs("comment","My Comment"))

updatedCatalogInfo = 

  CatalogInfo with properties:

             name: "mynewcatalog"
          comment: "My Comment"
     ucproperties: [0×0 JSONMapperMap]
            owner: "user@example.com"
    provider_name: [0×0 string]
       share_name: [0×0 string]
     metastore_id: "1472f26e-6c88-4d67-9712-d1000cd7e2e9"
       created_at: 26-Jan-2023 11:08:32
       created_by: "user@example.com"
       updated_at: 26-Jan-2023 11:09:47
       updated_by: "user@example.com"
```

Delete the catalog. To be able to delete, first the catalog must be empty, so first actually delete the automatically created `default` schema

```matlabsession
>> uc.deleteSchema(newCatalogName + ".default");
```

and then delete the empty catalog

```matlabsession
>> uc.deleteCatalog(newCatalogName);
```

## Permissions example

The following example shows how to work with `updatePermissions`. To update permissions do not directly update some `permissions` property of some existing object. It is required to provide a list of *changes* to make to the existing permissions of an existing object. Specify *which permissions* to *add* or *remove* for *which principal*.

In the example below it is assumed a specific user `someuser@example.com` already has `SELECT` permissions on table `main.default.mytable`. First remove that specific permission, and instead add `SELECT` permissions for the user's whole group named `somegroup`.

```matlab
% Import the package for shorter code
import databricks.datastructures.unitycatalog.*
% Instantiate a PermissionsDiff
pd = PermissionsDiff;
% Add the changes
% Remove SELECT permissions for the specific user
pd.changes(1).principal = "someuser@example.com";
pd.changes(1).remove = "SELECT";
% Add SELECT permissions for the group
pd.changes(2).principal = "somegroup";
pd.changes(2).add = "SELECT";
% Call updatePermissions
uc.updatePermissions("table","main.default.mytable",pd);
```

## Artifact Allowlists

This feature is a public preview on the Databricks platfrom, The associated APIs may change without notice. In Databricks Runtime 13.3 and above it allows the addition libraries and init scripts to the allowlist in Unity Catalog so that users can use these artifacts on compute configured with shared access mode.

The relevant methods are:

* `setArtifactAllowlist` - Set the artifact allowlist of a certain artifact type.
* `getArtifactAllowlists` - Gets the artifact allowlist of a certain artifact type.

```matlabsession
>> uc = databricks.UnityCatalog;
>> matcher = databricks.datastructures.unitycatalog.ArtifactMatchers;
>> matcher.artifact = "/Volumes/main/default/myvolume/myDir/runtime_install_r2023b.sh";
>> matcher.match_type = "PREFIX_MATCH";
>> alr = databricks.datastructures.unitycatalog.AllowlistRequest;
>> alr.artifact_matchers = matcher
>> artifact_type = databricks.datastructures.unitycatalog.ArtifactType.INIT_SCRIPT;
>> setResult = uc.setArtifactAllowlist(artifact_type, alr)
setResult = 
  SetArtifactAllowlistResp with properties:

    artifact_matchers: [1×1 databricks.datastructures.unitycatalog.ArtifactMatchers]
         metastore_id: "3ce438d4-321c-49ec-9ac1-123123123123"
           created_by: "joe@example.com"
           created_at: 04-Dec-2023 13:50:23
```

List init script allow list:

```matlabsession
>> uc = databricks.UnityCatalog();
>> artifact_type = databricks.datastructures.unitycatalog.ArtifactType.INIT_SCRIPT
>> getResult = uc.getArtifactAllowlists(artifact_type)
getResult = 
  GetArtifactAllowlistsResp with properties:

    artifact_matchers: [1×1 databricks.datastructures.unitycatalog.ArtifactMatchers]
         metastore_id: "3ce438d4-321c-49ec-9ac1-123123123123"
           created_by: "joe@example.com"
           created_at: 04-Dec-2023 13:50:23
>>
```

For further information see: [https://docs.databricks.com/api/workspace/artifactallowlists](https://docs.databricks.com/api/workspace/artifactallowlists)

[//]: #  (Copyright 2023 The MathWorks, Inc.)
