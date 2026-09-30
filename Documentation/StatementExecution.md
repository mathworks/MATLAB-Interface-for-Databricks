# Statement Execution API

> The underlying Databricks&reg; REST API is currently in preview.

The Databricks SQL Statement Execution API can be used to execute SQL statements
on a SQL warehouse and fetch the result. A subset of this functionality is supported
from MATLAB&reg;. This is a preview release only and Statement Execution functionality
should be expected to change or be removed without notice in future releases. Feature
support is incomplete.

## Create a Statement Execution query

The following code creates a Statement Execution object, configures it with a simple
SQL query to return the integers from 0 to 99 and to export the results via
external storage e.g. Azure&reg; blob.

For details of how to programmatically interact with a SQL Warehouse see: [WorkspacesAPI](WorkspacesAPI.md).

```matlab
% The StatementExecution object se will be used to run the query
se = databricks.statementexecution.api.StatementExecution;

% Set a warehouse Id
warehouseId = "02<REDACTEDa4";

esr = databricks.statementexecution.models.ExecuteStatementRequest
esr.warehouse_id = warehouseId;
% Set the SQL statement of interest, integers 0-99
esr.statement = "SELECT * FROM range(100)";
esr.wait_timeout = "10s";
% Export the result to external storage
esr.disposition = databricks.statementexecution.models.Disposition.EXTERNAL_LINKS;

% Execute the query
[code, result, response] = se.executeStatement(esr);

if code ~= matlab.net.http.StatusCode.OK
    error("Error executing: %s", esr.statement);
end

% Download the file from external storage
resultFile1 = websave('seResult.json', result.result.external_links.external_link);
% The default format is JSON, in this case using built in jsondecode to return
% a cell array
resultDataCell1 = jsondecode(fileread(resultFile1))
% Convert the cell array to a table
resultDataTable1 = cell2table(resultDataCell1)
```

To return data in CSV format, the format can be specified as follows:

```matlab
esr = databricks.statementexecution.models.ExecuteStatementRequest;
esr.warehouse_id = warehouseId;
esr.statement = "SELECT * FROM range(100)";
esr.wait_timeout = "10s";
esr.disposition = databricks.statementexecution.models.Disposition.EXTERNAL_LINKS;
esr.format = "CSV";
[code, result, response] = se.executeStatement(esr);

resultFile1 = websave('elresult.csv', result.result.external_links.external_link)
resultDataTable2 = readtable(resultFile1)
```

When more than one chunk is returned, subsequent chunks need to also be downloaded
and the results concatenated. The internal function: `databricks.internal.statementexecution.executeStatement`
is a more complete higher-level implementation that downloads complete result sets.

## Methods of interest

Statement execution specific methods on the `databricks.statementexecution.api.StatementExecution`
object are as follows, additional methods are inherited from base classes:

* cancelExecution - Cancel statement execution
* executeStatement - Execute a SQL statement
* getStatement - Get status, manifest, and result first chunk
* getStatementResultChunkN - Get result chunk by index

## References

For further details of the API see:

* [https://docs.databricks.com/api/workspace/statementexecution](https://docs.databricks.com/api/workspace/statementexecution)
* [https://docs.databricks.com/en/sql/admin/sql-execution-tutorial.html](https://docs.databricks.com/en/sql/admin/sql-execution-tutorial.html)

[//]: #  (Copyright 2023-2025 The MathWorks, Inc.)
