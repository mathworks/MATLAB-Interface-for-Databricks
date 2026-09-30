# Zerobus example

This example demonstrates how to use Zerobus to ingest data into a table from MATLAB&reg;
while monitoring it from a Databricks&reg; Notebook.

## Working directory

Begin by copying the example to a temporary working directory:

```matlab
workDir = fullfile(tempdir, "Zerobus");
copyfile(databricksRoot("examples", "Zerobus"), workDir)
cd(workDir)
```

## Example files

### `CreateAndMonitor.py`

Import the `CreateAndMonitor.py` Python&reg; notebook into your Databricks workspace.
Then use the initial cells in `CreateAndMonitor.py` to create the destination table
and grant the service principal the needed privileges.

Refer to [https://docs.databricks.com/aws/en/ingestion/zerobus-ingest#get-your-workspace-url-and-zerobus-ingest-endpoint](https://docs.databricks.com/aws/en/ingestion/zerobus-ingest#get-your-workspace-url-and-zerobus-ingest-endpoint)
for details on creating the service principal and obtaining the `clientId` and `clientSecret`.

Check the table is created, it should initially have zero rows.

### `zb.m`

`zb.m` is used to create a Zerobus client in MATLAB and insert data into the table.

Run the loop in MATLAB while refreshing the row count in the Databricks Notebook to
observe the data being ingested in near real-time. The notebook will typically trail
MATLAB code by a few seconds.
