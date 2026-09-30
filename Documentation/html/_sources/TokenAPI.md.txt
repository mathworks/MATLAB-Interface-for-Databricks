# Token API

*By default the token API is not enabled for non admin users.*

The Token API allows you to create, list and revoke tokens that can be used to
access Databricks&reg;. Initial authentication to this API is the same as for all
of the Databricks API endpoints, you must first authenticate
as described in [Authentication](Authentication.md).

## Create token

Create and return a token. This call returns and empty `[]` if the caller exceeds
the token quota, which is 600.

```matlab
create(db, durationInSeconds, commentString);
```

For Example:

```matlab
% Create a handle to the interface
token = databricks.Token();
token.create(100, 'Sample Comment');
```

The token return argument will contain the ID, creation time, expiry time and
value required to work with the Databricks API. Setting a value of `Inf` will
create a token that will never expire.

```matlab
token =

  Token with properties:

    token_value: 'dapi[REDACTED]a722'
    token_info: [1x1 struct]
```

The property ```token.token_info``` is a struct with fields:

```matlab
       token_id: '4c49[REDACTED]c312a'
  creation_time: 16-May-2019 19:12:06
    expiry_time: 16-May-2019 19:13:46
        comment: 'Sample Comment'
```

Create a token with specific scopes using a named argument `scopes` set to a character
vector, string or string array.

```matlab
token = databricks.Token();
token.create(100, 'Sample Comment', scopes=["unity-catalog", "clusters"]);
```

If the scopes argument is omitted the scope `all-apis` is assumed.
In returned token information if scopes are not listed it should be assumed that
the `all-apis` scope applies. If `all-apis` is desired it should not be specified.

## List tokens

List the existing tokens on Databricks account using the REST API, for Example:

```matlab
>> tokens = databricks.Token();
tokens.list()
ans = 
  1x2 Token array with properties:

    token_value
    token_info
```

This can be viewed as a MATLAB&reg; table using (this method will be removed in a future release):

```matlab
list = tokens.list();
table(list)
  2×5 table
    comment        creation_time            expiry_time            scopes                                    token_id                             
    ________    ____________________    ____________________    ____________    __________________________________________________________________
    "laptop"    21-Jul-2026 11:20:36    19-Oct-2026 11:20:36    {0×0 string}    "f5d4ae6e588bd6985d4c995df5bb9f780ed12598cc5bdb0fd0b44abefd02afd2"
    "office"    04-Aug-2026 16:52:55    18-Aug-2026 16:52:55    {0×0 string}    "e553843cfbbe0d8e940e749fabcd2e59132950b912f04d6d1dd9830ecc8f0ba9"
```

## Revoke token

Revoke an API access token using the REST API, for Example:

```matlab
token = databricks.Token(); % assuming a static file based authentication
token.revoke();
```

A token can also be specified for revocation using a specific token Id.


## References

1. Please see [https://docs.databricks.com/api/latest/tokens.html](https://docs.databricks.com/api/latest/tokens.html)

[//]: #  (Copyright 2020-2026 The MathWorks, Inc.)
