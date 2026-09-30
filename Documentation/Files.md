# Files API

The Files API is a HTTP API that allows reading, writing, listing and deleting of files and directories. The API makes working with file content as raw bytes easier and more efficient than DBFS for example.

The API supports Unity Catalog volumes, where files and directories to operate on are specified using their volume URI path, which follows the format `/Volumes/<catalog_name>/<schema_name>/<volume_name>/<path_to_file>`.

> Please note this API is in "Public Preview" with Databricks&reg; and is subject to change without notice.

* For more details see: [https://docs.databricks.com/api/workspace/files](https://docs.databricks.com/api/workspace/files).
* For details of working with files on Databricks in other ways from MATLAB&reg; see: [WorkingWithFiles](WorkingWithFiles.md).

To use the Files API begin by creating a `Files` object, e.g.:

```matlab
f = databricks.Files;
```

The following methods can then be used to work with files and directories:

* `create`
* `directoryMetadata`
* `download`
* `fileMetadata`
* `list`
* `listPaginated`
* `rm`
* `rmdir`
* `upload`

## `create` - Create a directory

If necessary, also creates any parent directories of the new, empty directory
(like the UNIX&reg; shell command mkdir -p). On success a logical `true` is returned,
otherwise `false`. A `databricks.datastructures.files.ErrorResponse` is also returned.
If called on an existing directory true is returned.

The required `directoryPath` argument is given as an absolute path,
as a scalar text value.

```matlab
f = databricks.Files;
[result, errorResponse] = f.create("/Volumes/main/default/myvolume/myDir")
result =
  logical
   1
```

See also: [https://docs.databricks.com/api/workspace/files/createdirectory](https://docs.databricks.com/api/workspace/files/createdirectory).

## `directoryMetadata` - Gets the metadata of a directory

On success a `databricks.datastructures.files.DirectoryMetadata` object is returned.
On expected error a `databricks.datastructures.files.ErrorResponse` is returned.
The `exists` property indicates if a directory exists or not.

The required `directoryPath` argument is given as an absolute path,
as a scalar text value.

```matlab
f = databricks.Files;
md = f.directoryMetadata("/Volumes/main/default/myvolume/myDir")
md =
    DirectoryMetadata with properties:
      exists: 1
```

See also: [https://docs.databricks.com/api/workspace/files/getdirectorymetadata](https://docs.databricks.com/api/workspace/files/getdirectorymetadata).

## `download` - Downloads a file

Files of up to 5 GiB can be downloaded. On success a logical `true` is returned,
otherwise `false`. A `databricks.datastructures.files.ErrorResponse` is also returned.
The optional logical `overwrite` flag can be used to prevent overwriting a
destination file, the default is true i.e. do overwrite the destination.

If an optional `destination` path named argument is provided it is used as the path
to download to otherwise the name of the file to be downloaded and the current
directory are used.

The required `source` argument is given as an absolute path,
as a scalar text value.

```matlab
f = databricks.Files;
[result, errorResponse] = f.download("/Volumes/main/default/myvolume/myDir/hello-world.txt", destination="hw-downloaded.txt")
result =
  logical
   1
```

See also: [https://docs.databricks.com/api/workspace/files/download](https://docs.databricks.com/api/workspace/files/download).

## `fileMetadata` - Get the metadata of a file

On success a `databricks.datastructures.files.FileMetadata` object is returned.
On expected error a `databricks.datastructures.files.ErrorResponse` is returned.
The contentLength property is the file size in bytes.

The required `filePath` argument is given as an absolute path, as a scalar text value.

```matlab
f = databricks.Files;
md = f.fileMetadata("/Volumes/main/default/myvolume/myDir/hello-world.txt")
md =
    FileMetadata with properties:
        contentType: "application/octet-stream"
      contentLength: 13
       lastModified: 08-Jan-2024 10:27:07
```

See also: [https://docs.databricks.com/api/workspace/files/getmetadata](https://docs.databricks.com/api/workspace/files/getmetadata).

## `list` - List files

Return a complete list of files in a directory.
On success a `databricks.datastructures.files.ListResponse` is returned
otherwise a `databricks.datastructures.files.ErrorResponse` is returned.
To return a page at a time use `databricks.Files.listPaginated()`

The required `directoryPath` argument is given as an absolute path,
as a scalar text value.

An optional `pageSize` int64 argument can be provided that sets the page size
used the default value is 1000.

```matlab
f = databricks.Files;
result = f.list('/Volumes/main/default/myvolume/myDir')
  ListResponse with properties:
    contents: [1x5 databricks.datastructures.files.DirectoryEntry]
```

This method is not recommended for directories with very large file counts
as runtime may be excessive, other approaches should be considered.

See also: [https://docs.databricks.com/api/workspace/files/listdirectorycontents](https://docs.databricks.com/api/workspace/files/listdirectorycontents).

## listPaginated - List a single 'page' of files

This method list some or all directory contents potentially returning a `nextPageToken`.

An optional `pageSize` int64 argument can be provided that sets the page size
used the default value is 1000.

An optional `pageToken` scalar text argument can be provided.

The token being the `nextPageToken` in the response of the previous request
to list the contents of this directory. Provide this token to retrieve the
next page of directory entries. When providing a `pagetoken`, all other
parameters provided to the request must match the previous request.

To list all of the entries in a directory, it is necessary to continue
requesting pages of entries until the response contains no `nextPageToken`.
Note that the number of entries returned must not be used to determine
when the listing is complete.

To return all pages at one time also see: `databricks.Files.list()`

The required `directoryPath` argument is given as an absolute path,
as a scalar text value.

On success a `databricks.datastructures.files.ListResponse` is returned
otherwise a `databricks.datastructures.files.ErrorResponse` is returned.

```matlab
f = databricks.Files;
result = f.list('/Volumes/main/default/myvolume/myDir')
  ListResponse with properties:
    contents: [1x5 databricks.datastructures.files.DirectoryEntry]
```

See also: [https://docs.databricks.com/api/workspace/files/listdirectorycontents](https://docs.databricks.com/api/workspace/files/listdirectorycontents).

## rm - Deletes a file

On success a logical `true` is returned, on failure a `false` is returned along with
a populated `databricks.datastructures.files.ErrorResponse`.
The required `directoryPath` argument is given as an absolute path, as a scalar text value.

```matlab
f = databricks.Files;
  [result, errorResponse] = f.rm("/Volumes/main/default/myvolume/myDir/hello-world.txt")
  result =
    logical
     1
```

See also: [https://docs.databricks.com/api/workspace/files/delete](https://docs.databricks.com/api/workspace/files/delete).

## rmdir - Deletes an empty directory

To delete a non-empty directory, first delete all of its contents.
This can be done by listing the directory contents and deleting each file
and subdirectory recursively. On success a logical `true` is returned, on failure
a logical `false` and  a populated `databricks.datastructures.files.ErrorResponse` is returned.

The required `directoryPath` argument is given as an absolute path,
as a scalar text value.

```matlab
f = databricks.Files;
[result, errorResponse] = f.rmdir("/Volumes/main/default/myvolume/myDeleteMeDir")
result =
  logical
   1
```

See also: [https://docs.databricks.com/api/workspace/files/deletedirectory](https://docs.databricks.com/api/workspace/files/deletedirectory).

## upload - Uploads a file

A file of up to 5 GiB can be uploaded. On success a logical `true` is returned, on failure a
`false` is returned along with a populated `databricks.datastructures.files.ErrorResponse`.

The required `source` and `destination` path arguments are given as absolute paths,
as scalar text values.

The optional named `overwrite` argument indicates if the destination file should be overwritten
if it exists. The default is `true`.

```matlab
f = databricks.Files;
 [result, upload] = f.upload("hello-world.txt", "/Volumes/main/default/myvolume/myDir/hello-world.txt")
 result =
   logical
    1
```

See also: [https://docs.databricks.com/api/workspace/files/upload](https://docs.databricks.com/api/workspace/files/upload).

[//]: #  (Copyright 2024-2025 The MathWorks, Inc.)
