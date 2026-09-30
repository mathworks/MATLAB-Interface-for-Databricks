# Upgrading the Interface from a previous release

If upgrading using a `.zip` file it is recommended to install the package alongside
any existing installation by putting it in a separate directory. Consider including
the version in the directory name. The use of older releases should be discontinued
once a transition to a later release can be completed. Only one version of the package
should exist on the MATLAB&reg; path at any one time. Restarting MATLAB and running the
respective `Software/MATLAB/startup.m` file is a simple way to ensure this is the case.

Configuration file settings generally remain similar and can be compared with those
of a previous release for non default settings.

From version 5.0.0 the `.databricks-connect` file is no longer used and should be
removed if not used by older releases. Also, any Databricks&reg; Connect jar file that
has been added to the static `javaclasspath.txt` file is no longer required.
This entry should be removed or commented out using a `#`.
Updating this file requires MATLAB to be restarted. The jar file referenced
has been replaced with Python&reg; based libraries as of v5.0.0.

## JDBC Driver

The Databricks JDBC driver is no longer included in the package. The driver must
be downloaded from [Databricks](https://www.databricks.com/spark/jdbc-drivers-archive).
The `jarFilePath` name-value pair can be used to specify the path to the driver.
See [Installing JDBC Driver](InstallingJDBCDriver.md) for details.

## MATLAB Runtimes

MATLAB Runtimes stored on `/Volumes` in the "interface directory" do not need to be
updated unless a new release of MATLAB is to be used, however it is good practice
to periodically update runtimes to the latest releases to receive the latest bug fixes.
For details see [Feature Support](SupportMatrix.md). Versions prior to 5.0.0 stored
MATLAB runtimes on DBFS, these are not used by version 5 and greater.

## Init Scripts

Similarly, as of version 5.0.0 the init script is stored in the "interface directory"
on `/Volumes`. It is not backwardly compatible with older init scripts. From 5.0.0
only one init script is used regardless of the MATLAB version.

If a custom init script is required by a user consider storing that in their Workspace
to avoid confusion.

Init scripts cannot be used with Databricks runtimes 17 and greater.

If there are specific questions not covered or a need for support in migration,
contact <databricks@mathworks.com>.

[//]: #  (Copyright 2021-2025 The MathWorks, Inc.)
