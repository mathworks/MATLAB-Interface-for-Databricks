# App Designer Example

App Designer can be used to build and run MATLAB&reg; Apps from the MATLAB desktop,
including when using MATLAB on Databricks&reg;. See:

* [https://www.mathworks.com/products/matlab/app-designer.html](https://www.mathworks.com/products/matlab/app-designer.html)
* [https://github.com/mathworks-ref-arch/matlab-on-databricks/tree/main](https://github.com/mathworks-ref-arch/matlab-on-databricks/tree/main)

This example builds a very basic app which uses the Databricks REST API interface
as covered by the `databricks.Cluster` class to display a table of information about
Databricks Clusters.

Begin by copying the example to a temporary working directory:

```matlab
workDir = fullfile(tempdir, "ClusterTable");
copyfile(databricksRoot("examples", "AppDesigner", "ClusterTable"), workDir)
cd(workDir)
```

Then step through the `buildMltbx.m` script to package the app as a `.mltbx` file.

If working with MATLAB on Databricks, `/Volumes` can be used a source for installing
toolboxes, but `/Volumes` should *not* be used as a working directory for building
toolboxes. Use a `/local_disk0/` or `/home/<username>` directory instead and copy
the results to persistent storage on `/Volumes` or `/Workspace` when complete.

```matlab
% Install the packaged ClusterTable app from a /Volumes path
matlab.addons.install("/Volumes/main/default/myvolume/myDirectory/ClusterTable.mltbx")

% Install from the default build location
matlab.addons.install(fullfile(tempdir, "ClusterTable", "ClusterTable")+".mltbx")

% Launch the App
ClusterTable
```

For day-to-day use the automatic installation of apps at startup can be achieved
in a number of ways. For example by configuring the `MWI_MATLAB_STARTUP_SCRIPT`
environment variable in the policy used to start clusters to include the desired
`matlab.addons.install()` commands.

> Standalone compiled graphical MATLAB apps cannot be used in Databricks.
> Run the App via the MATLAB Desktop as described instead.

> Existing apps with Windows&reg; dependant dependencies e.g. `.dll` files cannot be used on
> Databricks, which is Linux&reg; only, without adaptation.

Clean up by uninstalling the toolbox as described at the end of `buildMltbx.m` and
removing the temporary working directory:

```matlab
[status,msg,msgID] = rmdir(workDir)
```
