# DBFS API

> Both DBFS root and DBFS mounts are deprecated and not recommended by Databricks&reg;.
> New accounts are provisioned without access to these features. Databricks recommends
> using Unity Catalog volumes, external locations, or workspace files instead.
> See: [https://docs.databricks.com/en/dbfs/index.html](https://docs.databricks.com/en/dbfs/index.html).

The Databricks File System (DBFS) is a distributed file system mounted into a
Databricks workspace and available on Databricks clusters. DBFS is an abstraction
on top of scalable object storage. A MATLAB&reg; interface to this API is provided and
is described below.

* Working with files stored in a `/Volumes` path is typically recommended vs. DBFS.
This is supported using the [Files](Files.md) API. Files is faster and more secure.
* For general details of working with files on Databricks in other ways from MATLAB see: [WorkingWithFiles](WorkingWithFiles.md).
* If using [MATLAB on Databricks](https://github.com/mathworks-ref-arch/matlab-on-databricks) DBFS may be available as a mounted filesystem, as noted above this is not recommended.

## Upload a file to DBFS

Upload a file to the Databricks file system (DBFS). The upload is performed as a multipart REST 2.0 series of calls using the `create`, `add-block` and `close` API calls. The data is transmitted in 1/2 MiB chunks using the Databricks streaming API.

For example:

```matlab
db = databricks.DBFS();
db.upload('sample.mat');
```

The method accepts an additional argument to specify the target folder.

```matlab
db.upload('sample.mat','/MATLAB/')
```

## List contents of a file or folder

List the contents of a directory, or details of the file. If the file or directory does not exist, an empty FileInfo object is returned.

For example:

```matlab
% Create a handle to the interface
db = databricks.DBFS();
fList = db.listFiles()

fList =

1x4 FileInfo array with properties:

  path
  is_dir
  file_size
  modification_time
```

This array of FileInfo objects can be viewed as a table.

```matlab
fTable = table(db.listFiles)

fTable =

 74x4 table
                 path                 is_dir    file_size     modification_time  
    ______________________________    ______    _________    ____________________
    {'/FileStore'                }    true           0       01-Jan-1970 00:00:00
    {'/myDemo'                   }    true           0       01-Jan-1970 00:00:00
    {'/MATLAB'                   }    true           0       01-Jan-1970 00:00:00
```

This functionality is exposed as convenience method. This method also accepts an optional path argument.

```matlab
fTable = db.ls('/MATLAB')

fTable =
  28x4 table
                            path                            is_dir    file_size     modification_time  
    ____________________________________________________    ______    _________    ____________________
    "/MATLAB/AnalyticObject_Structure.mat"                  false         10219    19-Aug-2021 02:35:42
    "/MATLAB/FinancialTransactionData.csv"                  false     493534783    14-Jul-2020 20:55:48
    "/MATLAB/analysisData.mat"                              false        930719    06-Aug-2021 17:53:38
    "/MATLAB/demo"                                          true              0    01-Jan-1970 00:00:00
```

## Get information about a file or directory

Get the file information for a file or directory using the `getStatus` method.

```matlab
% Create a handle to the interface
db = databricks.DBFS();
info = db.getStatus('/MATLAB')

info = 
  FileInfo with properties:

                 path: '/MATLAB'
               is_dir: 1
            file_size: 0
    modification_time: 01-Jan-1970
```

Getting the status of a particular file requires the full path to the file.

```matlab
info = db.getStatus('/MATLAB/analysisData.mat')
info = 
  FileInfo with properties:

                 path: '/MATLAB/analysisData.mat'
               is_dir: 0
            file_size: 930719
    modification_time: 06-Aug-2021 17:53:38
```

## Create a folder

Create the given directory and necessary parent directories if they do not exist. The creation operation will succeed as long as there is no file (not a directory) at any prefix of the input path.

```matlab
% Create a handle to the interface
db = databricks.DBFS();
db.mkdir('/Data');
Successfully created folder: /Data
```

The path of the new directory is a mandatory argument. This path should be the absolute DBFS path (e.g. '/mnt/foo/').

```matlab
db.mkdir('/Data/testfolder')
```

## Delete a file or folder

Delete the file or directory (optionally recursively delete all files in the directory).

```matlab
% Create a handle to the interface
db = databricks.DBFS();
db.rm('/Data');
```

If the specified path is a non-empty directory, the invocation will fail with an error:

```matlab
Failed to delete folder: /Data
{"error_code":"IO_ERROR","message":"Path is a folder: /.../Data and it is not an empty directory"}
```

To recursively delete the folder and all subfolders/files, an additional recursive flag is required.

```matlab
% Create a handle to the interface
db = databricks.DBFS();
db.rm('/Data', true);
```

If the specified file or directory does not exist the operation will still complete without error,
displaying "Delete complete". If the existence of the file or folder is significant it should be
first checked using the `getStatus()` method.

## Moving a file in DBFS

> Note this methods should not be used for large scale file movements, see function help for details.

```matlab
% Create a handle to the interface
db = databricks.DBFS();
db.move('/mySourceDir/mySourcefile.txt', '/myDestinationDir/myDestinationFile.txt');
```

## DBFS limitations

DBFS is a FUSE mount on top of underlying object storage, either Azure&reg; Blob or AWS&reg; S3. This imposes certain limitations particularly the inability to do non-sequential writes. This means that certain MATLAB IO operations for certain file types will not be able to write to a `/dbfs` file path, e.g. `save()` or `savefig()`other such as `imwrite()` can do so. To work around this issue make the initial save to a temporary file in `/local_disk0/tmp`, a conventional filesystem on the node, and from there move the file to a `/dbfs` with `copyfile()` or `movefile()`.

Local file IO limitations are described here in the case of Azure and apply similarly in the case of AWS: [https://docs.microsoft.com/en-us/azure/databricks/data/databricks-file-system#local-file-apis](https://docs.microsoft.com/en-us/azure/databricks/data/databricks-file-system#local-file-apis).

## References

Please see:

1. [https://docs.databricks.com/api/latest/dbfs.html](https://docs.databricks.com/api/latest/dbfs.html)
2. [https://docs.microsoft.com/en-us/azure/databricks/data/data-sources/azure/azure-storage](https://docs.microsoft.com/en-us/azure/databricks/data/data-sources/azure/azure-storage)

[//]: #  (Copyright 2020-2026 The MathWorks, Inc.)
