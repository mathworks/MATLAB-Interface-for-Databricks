# Portfolio optimization example

This example requires the MathWorks Financial Toolbox&trade; [https://www.mathworks.com/products/finance.html](https://www.mathworks.com/products/finance.html).
Use the `ver` command to check if it is installed.

## Getting started

Begin by copying the example to a temporary working directory:

```matlab
workDir = fullfile(tempdir, "Portfolio");
copyfile(databricksRoot("examples", "DatabricksConnect", "Portfolio"), workDir)
cd(workDir)
```

### Included files

* Sample data is generated at runtime from `CAPMuniverse.mat` (requires Financial Toolbox).
* `runWithDatabricksConnect.m` - Test and development script uses Databricks&reg; Connect
to populate input data and create an a schema file (provided) if needed. It then
runs the optimization locally.
* `optimizePortfolio.m` - The portfolio optimization function that uses the Financial Toolbox.
* `buildPortfolioLib.m` - Script to compile the MATLAB&reg; function into a deployable .whl library.
* `runOnDatabricks.m` - Script to execute the compiled library as an *Artifact* on
a Databricks cluster using Databricks Connect.

## Run the uncompiled form

Step through the script `runWithDatabricksConnect.m` to test the portfolio optimization
locally using Databricks Connect. This will upload the required data and build the schema
file if required.

This requires access to a Databricks cluster. This cluster does not need the MATLAB
runtime installed though that will be needed in subsequent steps when the compiled
artifact is used. The script assumes the cluster has been set as the default cluster
see: `updateClusterId()`.

## Compile the MATLAB function

Check the schema file was created in the previous step if it was not already present: `optimizePortfolio.Schema`.

Build example artifact `.whl` file: `example.portfolio_Artifact.zip`

```matlab
PSB = buildPortfolioLib()
```

The output is produced in a `_build` directory.

## Run the compiled artifact on Databricks, using Databricks Connect

In this case the optimization function is executed remotely as an artifact via
Databricks Connect. The cluster used in this step must have the corresponding MATLAB
Runtime installed. Step through: `runOnDatabricks.m`

`volumesDeltaPath` is the value used to save the sample input data in `runWithDatabricksConnect.m`.
This value must be customized.

```matlab
PSB = buildPortfolioLib()
result = runOnDatabricks(PSB, volumesDeltaPath)
```
