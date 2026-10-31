# Startup and Shutdown

> **Note:** This feature is currently being developed. It may be changed or
> removed without further notice.

## Introduction

When MATLAB&reg; Desktop is started on Databricks&reg;, it's in a fresh state. The user
may need to change settings to get the environment they're used to and prefer.
They may also want or need particular libraries, tools, configurations, etc.
to be able to work as efficiently.

The feature is based on the concepts of **startup** and **shutdown**, i.e. that
something should be done during or prior to **startup**, and something should
be done during or prior to **shutdown**.

This feature makes it possible to choose certain files or folders on Databricks
that should be compressed (`tar.gz`) when MATLAB exits, and decompressed when
starting a new MATLAB Desktop (on Databricks). It also enables installing
user defined MATLAB Toolboxes (`.mltbx` format).

## Basic usage

This feature is configured through a JSON file that must reside on Databricks,
preferably in the user's own Workspace.

This is a very simple example:

```json
{
    "type": "Context",
    "username": "a_user",
    "operations": [
        {
            "type": "MLTbx",
            "tbx_location": "/Volumes/main/default/myvolume/Examples/MATLABToolboxes/foobar.mltbx",
            "agree_to_license": true,
            "context": "matlab"
        },
        {
            "type": "Copy",
            "src_location": "/home/a_user/.matlab",
            "zip_location": "/Workspace/Users/a_user@example.com/MathWorks/Context/R2025b",
            "exclude_list": ["MWI", "__mw_resources_mw__"],
            "context": "python"
        }
    ]
}
```

There is currently no MATLAB tool to create this file automatically. Each element
(on different levels) has the field `type`, which is used for serialization
and deserialization.

`operations` is a list of different operations. There are currently two types,
`Copy` and `MLTbx`, with the following functinoality:

`Copy` will package a file or a directory on shutdown, and save it in the form
of a `.tar.gz` archive somewhere on the path. If this has been done, the next
startup it will be loaded. This is a simple way to have different working
folders that reappear in a new MATLAB session. The fields are:

- `type` this must be set to `Copy`
- `src_location` which is the directory or file to save
- `zip_location` which is the directory where to save the package
- `exclude_list` enable excluding certain elements from the compressed archive.
  This can be done to exclude confidential material, or to reduce the size of
  the archive. In the example with `.matlab`, it will remove the `MWI` folder,
  which is not needed, and also the  `__mw_resources_mw__` folder. The exclude
  algorithm will exclude any file containing one of the strings in the `exclude_list`.
  is a list of files or folders to potentially exclude. Typical candidates here
  would be build folders or temporary files. 
- `context` this must be set to `python`

`MLTbx` will install a MATLAB toolbox at startup.
No effort is made to uninstall it at shutdown.
The fields are:

- `type` this must be set to `MLTbx`
- `tbx_location` the location of the `.mltbx` file to install from
- `agree_to_license` a boolean value, that when set to `true` will accept the
   license, if any. Not setting this to `true` for a `.mltbx` that needs a license
   may freeze the startup process.
- `context` this must be `matlab`

### Release dependency

Please note that certain saved data may be release dependent. For that reason,
we chose to save the MATLAB preference directory (`prefdir`) in a specific
directory (only readable by the user):

`"zip_location": "/Workspace/Users/a_user@example.com/MathWorks/Context/R2025b",`

See section [Configuration](#configuration) about this too.

## Size and security considerations

Files can be saved to any persistent file system on Databricks. We recommend
using either `/Volumes` or `/Workspace`.

The Databricks workspace currently has a size limit per file of 500 MB, so if
larger files or directories must be compressed, it may be necessary to put them
on `/Volumes`.

If a directory should be copied, using the `exclude_list` can be a way of
ensuring that

- Size is reduced
- Personal files are not part of the compressed archive

If the compressed file contains any confidential information (like ssh keys),
it's the responsibility of the user to decide if the storage location is secure
enough for the data that is stored.

It should be avoided to have common locations for compressed files. The
`tar gzip` process will preserve `user` and `group` information, so if
`alice` saves a folder, and `bob` tries to unpack it, he may not be able
to read the files.

> **Note:** Having a common compressed file (that is maybe not changed, just
> used), may clearly be a use case. This may be added later as a setting or as
> a separate operation type.

## Configuration

> **Note:** This configuration is going to change, as there is now an official
> reference architecture for running a MATLAB Desktop on Databricks, see
> [matlab-on-databricks](https://github.com/mathworks-ref-arch/matlab-on-databricks).
> The startup/shutdown feature is not directly supported with the reference
> architecture at the time of writing.

The default location for the `json` file is in the users private workspace,
with a directory added for the corresponding MATLAB Release. In this example
**R2026a**

`/Workspace/Users/a_user@example.com/MathWorks/Context/R2026a/mw_prefs.json`.

> **Note:** See section [Release dependency](#release-dependency) above too.

If the user wants to use a different location, this is possible by setting the
environment variable `MW_STARTUP_SHUTDOWN_CONFIG` correspondingly.

This can also be used to have different setups for different tasks, e.g.
`/Workspace/Users/a_user@example.com/project_x.json` and
`/Workspace/Users/a_user@example.com/project_y.json`.

## Missing compressed files

If a `.tar.gz` file is missing from the `zip_location`, it's just ignored during
the `startup` phase. Consider the example saving git configurations above, i.e.

```json
    "src_location": "/home/a_user/.gitconfig",
    "zip_location": "/Workspace/Users/a_user@example.com/MathWorks/Context",
```

If the file
`/Workspace/Users/a_user@example.com/MathWorks/Context/.gitconfig.tar.gz`
is missing, MATLAB simply starts without this file.

In the current MATLAB (on Databricks), the user can add some configurations, e.g.

```matlab
!git config --global user.name "My Name"
!git config --global user.email "USERNAME@example.com"
!git config --global alias.st status
!git config --global alias.co checkout
```

When the `shutdown` procedure is invoked, this file will be found, and the
data will be compressed and saved. The next time when the user starts
MATLAB Desktop on Databricks, the `.gitconfig` file will be unpacked prior to
starting MATLAB, and the user will have his or her _usual environment_.

The user can use either command line git, as above, or the built-in support
from the MATLAB Desktop.

## Startup and Shutdown methods

The **startup** methods are executed automatically, if configured, but when are
the **shutdown** methods executed? It turns out that they may or may not be executed.

There are a few ways of ensuring that the **shutdown** methods will run.

- When leaving MATLAB, run `exit` in MATLAB, as you might on a Desktop MATLAB
on your computer. When it has finished (there is some output during **shutdown**),
the cluster can be terminated/deleted.

- Run `finish`. The Databricks package contains a `finish` function, which is called
when the user executes `exit`. It is, however, possible to simply call `finish`
without exiting MATLAB. The user may want to do this to
_save the data at regular intervals_.

[//]: #  (Copyright 2025-2026 The MathWorks, Inc.)
