# Secrets API

The Secrets API allows the management of secrets and secret scopes. Secret ACLs are
not currently supported by this interface. Note, secret values cannot be retrieved
using this API.

## Create a scope

Create a secret scope in which secrets are stored in Databricks&reg;-managed storage.
Scope names must be:

1. Unique within a workspace.
2. Consist of alphanumeric characters, dashes, underscores, and periods, and may not exceed 128 characters.

The names are readable by all users of a workspace. A workspace is limited to a
maximum of 100 scopes. Scopes are typically created with the `initial_manage_principal`
set to `users`, consult Databricks documentation for options which may vary with
Databricks plan type.

```matlab
scope = databricks.Scope;
scope.scope = 'myScope';
scope.initial_manage_principal = 'users';
scope.create
Created scope: myScope
```

## List scopes

To list all secret scopes available in the workspace:

```matlab
scope = databricks.Scope;
scopes = scope.list
scopes =
  2x2 table
      name       backend_type
    _________    ____________
    "scopeA"     "DATABRICKS"
    "myScope"    "DATABRICKS"
```

Scopes are returned as a MATLAB&reg; table. If no scopes are defined an empty table is
returned. All entries are returned as strings.

## Delete a scope

Delete a scope using the scope name as an argument to the delete method.

```matlab
scope = databricks.Scope;
scope.delete('myScope')
Deleted scope: myScope
```

## Put a secret

Put a secret in a scope which has been previously created. This method supports
vectorization. The key must consist of alphanumeric characters, dashes, underscores
and periods only and cannot exceed 128 characters. The maximum allowed secret value
size is 128KB. The maximum number of secrets in a given scope is 1000. The secret
value may be a character vector or byte array of type uint8. The `setValue()`
methods sets a Secret object secret value. This method permits the secret value
property of the Secret object to have attributes hidden and private to limit the
potential for accidental disclosure of the value e.g. via log files. Variables
holding the secret value should be cleared when no longer needed.

```matlab
secret = databricks.Secret;
secret.scope = 'myScope';
secret.key = 'myKey';
secret.setValue('mySecretValue');
secret.put
Put secret:  myScope : myKey
```

## List secrets

List the secret keys that are stored in a given scope. Results are returned in a
MATLAB table. Only metadata is returned. Secret values cannot be retrieved using
this API. Timestamps are returned as MATLAB datetime values in UTC. If no secrets
are defined an empty table is returned. Keys are returned as strings.

```matlab
secret = databricks.Secret;
secret.scope = 'myScope';
secret.list
ans =
  1x2 table
      key      last_updated_timestamp
    _______    ______________________
    "myKey"     18-May-2024 09:12:17
```

## Delete a secret

The scope and key pair to delete should be provided as arguments to the delete
method regardless of whether they are set in the underlying secret object.

```matlab
secret.delete('myScope','myKey')
Deleted secret: myScope : myKey
```

[//]: #  (Copyright 2020-2024 The MathWorks, Inc.)
