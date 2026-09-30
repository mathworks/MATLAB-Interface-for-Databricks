# Authentication

Authentication between MATLAB&reg; and Databricks&reg; can be accomplished through several
mechanisms using the Databricks Unified Authentication provider chain.
It supports the following authentication mechanisms:

* Chain - Evaluate methods in the following order until a working methods is found, this option is rarely necessary.
* OauthU2M - OAuth user-to-machine (U2M) authentication, (default).
* OauthM2M - OAuth machine-to-machine (M2M) authentication.
* PAT - Personal Access Token authentication.

Support for the unified authentication provider enables MATLAB and other Databricks
related tools to share authentication configuration details.

OauthU2M is used as the default authentication mechanism. Oauth mechanisms enable
capabilities such as short lived tokens and the use of service principals.
OauthM2M is more appropriate for use with software services and OauthU2M is used
for individual access.

PAT based authentication while simple to use may not be enabled in favour of OauthU2M.
The personal access token can be created either using the Databricks Workspace
UI or from MATLAB via the [Token API](TokenAPI.md), the latter requires that authentication
of some form is already in place.

## Configuration & Settings files

> If using MATLAB on Databricks typically the configuration and settings files are prepopulated.

### .databrickscfg file

Authentication configuration details are stored in `HomeDirectory/.databrickscfg`.
This file enables multiple profiles using *profile names*, typically a profile named
`[DEFAULT]` is used as the [default](#profile-selection).

> Setting the `DATABRICKS_CONFIG_FILE` environment variable allows an alternative file to be used.

Sample file structure:

```ini
[DEFAULT]
token = dap<REDACTED>2
host = https://adb-12345678.azuredatabricks.net
cluster_id = 0521-002819-eit9opfk
org_id = 123456789

[U2M]
host = https://adb-12345678.azuredatabricks.net

[M2M]
host = https://adb-12345678.azuredatabricks.net
client_id = <REDACTED>
client_secret = <REDACTED>
```

Commonly used profile fields:

| Authentication Method | Field Name | Required | Example |
| ----------------------| ---------- | -------- | ------- |
| PAT                   | host       | Yes      | https://adb-12345678.azuredatabricks.net |
|                       | token      | Yes      | dap-REDACTED-2 |
|                       | cluster_id | Optional | 0521-002819-eit9opfk |
|                       | org_id     | Optional | 123456789455407 |
| OauthU2M              | host       | Yes      | https://adb-12345678.azuredatabricks.net |
|                       | cluster_id | Optional | 0521-002819-eit9opfk |
|                       | org_id     | Optional | 123456789455407 |
| OauthM2M              | host       | Yes      | https://adb-12345678.azuredatabricks.net |
|                       | client_id  | Yes      | fa0-REDACTED-cd1 |
|                       | client_secret | Yes   | bc0-REDACTED-cd1 |
|                       | cluster_id | Optional | 0521-002819-eit9opfk |
|                       | org_id     | Optional | 123456789455407 |

If the following environment variables are set they take precedence over the
`.databrickscfg` file values.

| Environment Variable     | Profile field |
| ------------------------ | ------------- |
| DATABRICKS_HOST          | host          |
| DATABRICKS_TOKEN         | token         |
| DATABRICKS_USERNAME      | username      |
| DATABRICKS_PASSWORD      | password      |
| DATABRICKS_CLIENT_ID     | client_id     |
| DATABRICKS_CLIENT_SECRET | client_secret |
| DATABRICKS_ACCOUNT_ID    | account_id    |
| DATABRICKS_CLUSTER_ID    | cluster_id    |
| DATABRICKS_ORG_ID        | org_id        |

> The `DATABRICKS_AUTH_TYPE` environment variable is not yet supported, see:
> settings file based `authMethod` below.

The Databricks JDBC driver supports the following additional environment variables:

* `DATABRICKS_SERVER_HOSTNAME` this will be used in preference to `DATABRICKS_HOST` if also set.
* `DATABRICKS_HTTP_PATH`

> For JDBC & ODBC JWT assertions are not currently supported.

> Comments indicated with a ";"  character are used but currently may be automatically
> removed in certain circumstances and so are discouraged.

#### Account-level operations

For account-level operations the `host` value should typically be `https://accounts.cloud.databricks.com`
rather than a workspace URL of the form `https://dbc-a1b2345c-d6e7.cloud.databricks.com`.
The `account_id` value should also be specified and is only used when using an account host.
To locate the account ID see: [https://learn.microsoft.com/en-us/azure/databricks/admin/account-settings/#account-id](https://learn.microsoft.com/en-us/azure/databricks/admin/account-settings/#account-id).

#### org_id

The creation of a Databricks JDBC/ODBC connection URL requires an *ORG ID*
value. This is not used by REST interface or Databricks Connect authentication.
For more details see [ODBCWorkflow.md](ODBCWorkflow.md)
or [JDBCWorkflow.md](JDBCWorkflow.md).

#### Token cache

When using Oauth authentication the token is not stored in the profile.
The short lived access token is cached in a plain text file named:
`HomeDirectory/.databricksOauthTokenCache`. When the token expires,
it is automatically refreshed.

* An alternative cache file location can be specified using the `DATABRICKS_TOKEN_CACHE_FILE`
  environment variable.

* To disable the local caching of tokens set the `DISABLE_DATABRICKS_TOKEN_CACHE`
  environment variable to `true`. This will result in additional authentication requests.

* The setup process deletes any existing cached tokens.

#### Related settings

The settings file `databricks-settings.json` stored in the MATLAB `prefdir` has
the following related fields:

* `authMethod` - Set to Chain, PAT, OauthM2M or OauthU2M (default) to indicate the preferred authentication method.
* `profileName` - To indicate the preferred profile to use in the `.databrickscfg` file.
* `vendor` - Indicates which cloud platform is in use, required for cluster creation.

For more details on the settings file see: [Setup.md](Setup.md).

### Profile selection

A `.databrickscfg` file supports multiple profiles, which profile to use is selected
based on the following priority:

1. Many functions support an argument or optional argument typically called `profileName`.
2. The value of the `DATABRICKS_CONFIG_PROFILE` if set.
3. The `profileName` field in the [`databricks-settings.json`](Setup.md) file.
4. The profile named `DEFAULT` if present.
5. Otherwise The first profile in the file.

If a profile cannot be determined an empty `databricks.internal.configurationprofile.Profile`
object may result. Profile names are case sensitive.

### Oauth client_id

MATLAB uses the value "databricks-cli" as the Oauth `client_id` value, not to be
confused with the OauthM2M `client_id` field set in the `.databrickscfg`.
In general this is not a concern for end users but if required an organization can
register an alternative value and update the `databricks.internal.unifiedauthentication.Oauth`
class accordingly.

## Docker authentication

When using Databricks Container Services to create clusters using custom Docker&reg;
images access to those images requires authentication credentials for the docker
registry. The image `url` is always necessary, and typically a username and password
are also required. For example if using `createDatabricksCluster`:

```matlab
cl = createDatabricksCluster('myClusterName', 0, ...
    dockerURL="myrepo.io/matlab/databricks/runtime:r2025b-dbx17.3", ...
    dockerUsername= "someuser", ...
    dockerPassword= "secretpassword", ...
    sparkVersion="17.3.x-scala2.13");

% Or if using a publicly available image
cl = createDatabricksCluster('myClusterName', 0, ...
    dockerURL="myrepo.io/matlab/databricks/runtime:r2025b-dbx17.3", ...
    sparkVersion="17.3.x-scala2.13");
```

It is also possible to save this information in a JSON-file for easier use.

```matlab
cl = createDatabricksCluster('Test', 0, dockerAuthFile="dk_runtime_25b_17.3.json");
```

with the file `dk_runtime_25b_17.3.json` containing:

```json
{
  "url": "myrepo.io/matlab/databricks/runtime:r2025b-dbx17.3",
  "basic_auth": {
    "username": "someuser",
    "password": "secretpassword"
  },
  "spark_version": "17.3.x-scala2.13"
}
```

> **Note:** The `spark_version`, is not used for authentication, but is required
> to configure the cluster correctly and should correspond to the Databricks runtime
> version used when the docker image was built.

## References

* AWS&reg; - [https://docs.databricks.com/en/dev-tools/auth/index.html](https://docs.databricks.com/en/dev-tools/auth/index.html)
* Azure&reg; - [https://learn.microsoft.com/en-us/azure/databricks/dev-tools/auth/](https://learn.microsoft.com/en-us/azure/databricks/dev-tools/auth/)

[//]: #  (Copyright 2020-2026 The MathWorks, Inc.)
