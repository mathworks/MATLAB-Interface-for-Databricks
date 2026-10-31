# Authentication - REST Interface

If used with Databricks the MLFlow REST API interfaces uses the Databricks
Unified Authentication approach as per the the rest of the Databricks interface.
That is a `.databrickscfg` and other details as specified in the `Documentation/Authentication.md`
of that package.

If not using Databricks the REST interface is authenticated using an authentication file.
Any authentication needed in the fluent interface will be taken care of by the
underlying Python libraries, see also:
 [working with a remote tracking server in the fluent interface](./Fluent.md#working-with-a-serverremote).

The authentication file for the REST interface can be either:

* `~/.mlflow-connect` in the users home directory
* `mlflow.json` somewhere on the MATLAB path

If this is used with a standalone mlflow server, a simple file can
be created (either the `.mlflow-connect` or the `.mlflow.json` mentioned above).

In its simplest form it can look like this:

```json
{
  "host":"http://localhost:5000"
}
```

A bearer token, if available, can be added as the field `token`.
A template file is provided: ``Software/MATLAB/config/mlflow.json.template`.

[//]: #  (Copyright 2021-2024 The MathWorks, Inc.)
