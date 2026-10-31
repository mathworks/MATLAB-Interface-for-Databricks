# Libraries

## Cluster scoped library API

Cluster scoped libraries apply at the level of the cluster.
The Libraries API allows you to install and uninstall libraries on a cluster and
to get the status of the libraries on a cluster.
For further details see: [https://docs.databricks.com/dev-tools/api/latest/libraries.html](https://docs.databricks.com/dev-tools/api/latest/libraries.html)
See also [PythonSparkBuilder documentation](matlab-spark-api/PythonSparkBuilder.md) for more information on building,
deploying and invoking a library.

> Notebook scope libraries, described below, can be used alongside cluster scope libraries.

A Library object is declared and configured as follows:

```matlab
lib = databricks.Library()
lib.setType('whl');
lib.whl = '/Volumes/main/default/myvolume/myLibrary.whl';
```

### Library types

Libraries can have the following types:

* `jar`
* `egg`
* `whl`
* `pypi`
* `maven`
* `cran`
* `requirements`

Typically when working with this package, libraries of type `whl` are used, as
that is the type produced by MATLAB&reg; Compiler SDK&trade;, e.g.: `lib.setType('whl')`.

### Installing a library

Install libraries on a cluster as follows. The installation is asynchronous, it
completes in the background after the request returns.

```matlab
lib = databricks.Library;
lib.setType('whl');
lib.whl = '/Volumes/main/default/myvolume/myLibrary.whl';
clusterId = '0000-000000-demo000'
lib.install(clusterId);
```

Note this request is asynchronous and will complete in the background.
Use `getClusterStatus()` to confirm completion.

```matlab
lib = databricks.Library;
result = lib.getClusterStatus(myCluster.cluster_id);
```

The returned result for the libraries will have a status field value of 'INSTALLED'
when a given library has been installed.

### Uninstall a library

To uninstall a library from a cluster use the uninstall method as follows. Note
that once uninstalled the library will no longer be available to other users of
the cluster.

```matlab
lib = databricks.Library;
lib.setType('whl');
lib.jar = '/Volumes/main/default/myvolume/myLibrary.whl';
clusterId = '0000-000000-demo000'
lib.uninstall(clusterId);
```

When uninstalling a library from a cluster, the library is removed only
when the cluster is restarted. Until restarted the status of the uninstalled library
appears as "Uninstall pending restart".

## Notebook scoped libraries

If a cluster has been created using a policy that defines a library,
e.g. as is required when using the MATLAB runtime from a the
Databricks&reg; Workspace policy drop down menu,
*then further cluster scoped libraries cannot be added after cluster creation time*.

> The following applies to Python&reg; `.whl` files including those built using MATLAB compiler only.

Notebook scoped libraries allow libraries to be installed at the level of a notebook,
rather than at the level of the cluster. Whether a policy is used or not.

Also as described above, updating a cluster defined library requires restarting
the cluster, this is slow and inconvenient. A notebook scoped library can be updated
more easily.

To install a library from a notebook use `%pip`, *note the `%` is important*.

```text
%pip install /Volumes/main/default/myvolume/mydir/my.example.whl
```

> Note: It may be necessary to restart the notebook's kernel using `%restart_python`
> or `dbutils.library.restartPython()` to use updated packages.

To update a library, copy the updated `.whl` to a given location and again use
`%pip install`, but this time appending the option: `--force-reinstall`.

```text
%restart_python
%pip install /Volumes/main/default/myvolume/mydir/my.example.whl --force-reinstall
```

See: [https://docs.databricks.com/en/libraries/cluster-libraries.html#uninstall-a-library-from-a-cluster](https://docs.databricks.com/en/libraries/cluster-libraries.html#uninstall-a-library-from-a-cluster)

[//]: #  (Copyright 2020-2024 The MathWorks, Inc.)
