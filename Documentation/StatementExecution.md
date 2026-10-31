# Statement Execution API

The Databricks&trade; SQL Statement Execution API executes SQL statements on a
SQL warehouse and returns result data without using ODBC, JDBC, or Apache
Spark&trade;. MATLAB&reg; support is provided by the `databricks.StatementExecution`
class. This can be particularly useful if building Databricks Apps rather than working
in Desktop MATLAB either locally or in Databricks itself.

There are two main ways to use this API from MATLAB:

* Use `databricks.StatementExecution.runStatement` when you want a simple
  workflow that executes a statement, waits for completion, fetches the result,
  and returns a MATLAB table with the final status and statement ID.
* Use `databricks.StatementExecution.execute`,
  `databricks.StatementExecution.getStatement`,
  `databricks.StatementExecution.getResultChunkN`, and
  `databricks.StatementExecution.cancelExecution` when you need lower-level
  control over request options, polling, chunks, or cancellation.
* Internal helpers such as `databricks.internal.statementexecution.runStatementImpl`
  and `databricks.internal.statementexecution.response2Table` implement result-file
  handling and table conversion for the higher-level workflow.

## High-level workflow: return a MATLAB table

`runStatement` is the simplest interface. It executes SQL on a warehouse and
returns a MATLAB table, the final statement status, and the statement
ID. Temporary result files are written under `tempdir` while results are
converted and then deleted.

The Statement Execution API cannot use a Databricks cluster as its backend, only
a Warehouse is supported.

```matlab
statementExecution = databricks.StatementExecution;

warehouseId = "02<REDACTED>a4";
statement = "SELECT * FROM samples.nyctaxi.trips LIMIT 10";

[T, status, statementId] = statementExecution.runStatement(statement, warehouseId);

if status.state ~= databricks.datastructures.statementexecution.State.SUCCEEDED
    error("Statement did not succeed. Final state: %s", status.state);
end

head(T)
```

By default, `runStatement` uses `INLINE` disposition with `JSON_ARRAY` result
format. This is the recommended option for result data volumes below 25 MiB. To
fetch larger results with external links, request `EXTERNAL_LINKS`; the wrapper
uses CSV for this mode when `format` is not specified and still returns a MATLAB
table.

> In this context, disposition describes how Databricks returns result data.
> `INLINE` returns result chunks directly in the Statement Execution response.
> `EXTERNAL_LINKS` returns presigned cloud storage URLs that MATLAB downloads
> separately.

`status` is an instance of the class `databricks.datastructures.statementexecution.Status`
and can be examined to see the state of the call itself, the underlying SQL query
and possible errors.

```matlab
statementExecution = databricks.StatementExecution;

disposition = databricks.datastructures.statementexecution.Disposition.EXTERNAL_LINKS;
format = databricks.datastructures.statementexecution.Format.CSV;
statement = "SELECT * FROM samples.bakehouse.media_customer_reviews LIMIT 10";

[T, status, statementId] = statementExecution.runStatement( ...
    statement, warehouseId, disposition=disposition, format=format, ...
    timeout=120, applySchemaTypes=true, verbose=false);
```

`runStatement` intentionally exposes a smaller option set than the full REST
API.

* `disposition` and `format` control the statement result transport and file
  format. If both are omitted, `runStatement` uses `INLINE` and `JSON_ARRAY`.
* `timeout` controls the total time, in seconds, that `runStatement` spends
  executing, polling, downloading, and converting the result. Default: Inf.
* `parameters` supplies named SQL statement parameters.
* `queryTags` supplies Databricks query tags for statement observability.
* `applySchemaTypes` controls whether Databricks schema metadata is used for
  MATLAB table type conversion.
* `verbose` controls progress output.

| `disposition` value | `format` value | How selected | Notes |
| --- | --- | --- | --- |
| `INLINE` | `JSON_ARRAY` | Default when neither option is specified | Main default mode for `runStatement`. |
| `EXTERNAL_LINKS` | `CSV` | Default `format` when `disposition=EXTERNAL_LINKS` | Used when external result links are requested and no format is specified. |
| `INLINE` | `JSON_ARRAY` | Default `disposition` when `format=JSON_ARRAY` | `JSON_ARRAY` implies inline results when disposition is omitted. |
| `EXTERNAL_LINKS` | `CSV` | Default `disposition` when `format=CSV` | Non-`JSON_ARRAY` formats imply external links when disposition is omitted. |
| `EXTERNAL_LINKS` | `ARROW_STREAM` | Default `disposition` when `format=ARROW_STREAM` | `ARROW_STREAM` is an accepted `Format` enum value. |
| `EXTERNAL_LINKS` | `FORMAT_UNSPECIFIED` | Default `disposition` when `format=FORMAT_UNSPECIFIED` | Accepted by the enum; `runStatement` treats it as non-`JSON_ARRAY`. |
| Any explicit valid pair | Any explicit valid pair | User-specified | If both are provided, `runStatement` uses both as supplied. `INLINE` with any format other than `JSON_ARRAY` errors. |

Databricks supports `ARROW_STREAM` and `CSV` only with `EXTERNAL_LINKS`
disposition. `JSON_ARRAY` is supported with both `INLINE` and `EXTERNAL_LINKS`.
The high-level wrapper errors if `INLINE` is paired with any format other than
`JSON_ARRAY`.

`timeout` defaults to `Inf`. If the timeout is exceeded after Databricks has
returned a statement ID and the current state is `PENDING` or `RUNNING`,
`runStatement` attempts to cancel the remote statement and then errors. This is
different from the Databricks REST API `wait_timeout` field, which controls only
how long the initial execute request waits before returning. Use the lower-level
`execute` workflow to set `wait_timeout` or `on_wait_timeout` directly.

`applySchemaTypes` defaults to `true` and uses the statement schema to convert
JSON_ARRAY and CSV result data to MATLAB table types. Set `applySchemaTypes=false`
to use MATLAB's default CSV type inference for CSV results or to return JSON_ARRAY
rows as raw strings in a one-variable table without decoding JSON values.

Use the lower-level methods to control catalog or schema settings, row or byte
limits, explicit chunk handling, `wait_timeout` behavior, or access to the full
`StatementResponse`.

## Result conversion semantics

`runStatement` returns MATLAB tables for the supported Statement Execution
result combinations, the specifics of the table can differ by Databricks result
format. The response manifest is the source of truth for table variable names,
column order, result row count, and Databricks SQL types, prior to conversion.

For `JSON_ARRAY` results with `applySchemaTypes=true`, MATLAB decodes the JSON
payload and converts each column using the Databricks schema where supported.
For `CSV` results with `applySchemaTypes=true`, MATLAB builds `readtable` import
options from the manifest before reading the downloaded CSV file. In both cases,
the returned table uses the manifest column names and ordering.

When `applySchemaTypes=false`, the conversion is intentionally less intrusive:
CSV results are read with MATLAB's default text import inference, then renamed
and annotated from the manifest. `JSON_ARRAY` results are not decoded into
MATLAB values. Instead, each top-level JSON result row is returned as a raw JSON
string in a single table variable named `Result`. This preserves value text that
`jsondecode` could otherwise normalize, such as numeric spelling, escaped string
content, or JSON `null`.

```matlab
[T, status, statementId] = statementExecution.runStatement( ...
    statement, warehouseId, applySchemaTypes=false);
```

For `JSON_ARRAY`, `T` has one row per result row and one variable:

```text
Result
--------------------------
["001","42"]
[null,"7"]
```

For queries that result in 0 rows, the returned MATLAB table has the expected
variables and zero rows. Databricks CSV output for this case can still contain a
header row in the downloaded result file, while `JSON_ARRAY` output is written as
an empty array, `[]`. The MATLAB table shape is driven by the manifest rather
than by the presence of data rows in the file.

Some Databricks SQL types do not have a lossless MATLAB table type mapping.
Complex values and values that may lose precision are represented as strings.
Date and timestamp values are imported as `datetime`; timestamp values are
treated as UTC.

## Low-level workflow: submit a request

Use `execute` with an `ExecuteStatementRequest` object when you want to control
the request payload directly. This method submits the statement and returns the
initial `StatementResponse` plus an error response object when Databricks returns
an error. `getStatement` and `getResultChunkN` must then be used to marshall the
resulting data when available.

The recommended higher-level `runStatement` workflow handles polling and chunk
fetching for supported table outputs automatically.

```matlab
statementExecution = databricks.StatementExecution;

request = databricks.datastructures.statementexecution.ExecuteStatementRequest;
request.statement = "SHOW TABLES IN samples.nyctaxi";
request.warehouseId = warehouseId;
request.disposition = databricks.datastructures.statementexecution.Disposition.INLINE;
request.format = databricks.datastructures.statementexecution.Format.JSON_ARRAY;
request.waitTimeout = "30s";
request.onWaitTimeout = databricks.datastructures.statementexecution.TimeoutAction.CANCEL;

[result, errorResponse] = statementExecution.execute(request);

if ~isempty(errorResponse)
    error("Statement execution failed: %s", errorResponse.message);
end

disp(result.status.state)
```

## Poll statement status

When a request returns a statement ID before the statement reaches a terminal
state, poll with `getStatement`.

```matlab
statementId = result.statementId;

while result.status.state == databricks.datastructures.statementexecution.State.PENDING || ...
        result.status.state == databricks.datastructures.statementexecution.State.RUNNING
    pause(2)
    [result, errorResponse] = statementExecution.getStatement(statementId);
    if ~isempty(errorResponse)
        error("Failed to poll statement: %s", errorResponse.message);
    end
end
```

Terminal states include `SUCCEEDED`, `FAILED`, `CANCELED`, and `CLOSED`.

## Fetch result chunks

Statement results may be split into chunks. The first chunk is usually included
in the successful statement response. If the result data indicates there is a
next chunk, fetch it by zero-based chunk index with `getResultChunkN`.

```matlab
resultData = result.result;

while ~isempty(resultData.nextChunkIndex)
    [resultData, errorResponse] = statementExecution.getResultChunkN( ...
        statementId, resultData.nextChunkIndex);
    if ~isempty(errorResponse)
        error("Failed to fetch result chunk: %s", errorResponse.message);
    end

    % Process resultData here.
end
```

For `INLINE` disposition, JSON array data is returned in result chunks. For
`EXTERNAL_LINKS`, result chunks contain presigned external links. Treat external
links as sensitive: they point to cloud storage outside the Databricks compute
plane and expire after a limited time.

## Cancel a statement

Use `cancelExecution` to request cancellation of a running statement. Cancellation
is asynchronous, so poll with `getStatement` after the call to confirm the final
state. The `runStatement` method will attempt to cancel a statement automatically
in the case of a timeout.

```matlab
[accepted, errorResponse] = statementExecution.cancelExecution(statementId);

if ~isempty(errorResponse)
    error("Cancellation request failed: %s", errorResponse.message);
end

if accepted
    [result, errorResponse] = statementExecution.getStatement(statementId);
end
```

## Result formats and table conversion

MATLAB table conversion by the high level API is currently supported for:

* `INLINE` disposition with `JSON_ARRAY` format. This is recommended for result
  data volumes below 25 MiB.
* `EXTERNAL_LINKS` disposition with `CSV` format.

`runStatement` chooses these supported combinations automatically when
`disposition` or `format` is omitted.

Schema-driven type conversion is enabled by default and can be disabled with
`applySchemaTypes=false`. When disabled, CSV results use MATLAB's default CSV
type inference and JSON_ARRAY rows are returned as raw strings in a one-variable
table without decoding JSON values. This can be useful for diagnostics.

The low-level API support other formats supported by Databricks,
it does not automatically convert the result to a MATLAB table.

## Parameterized statements

Databricks Statement Execution supports named parameter markers in SQL text.
Use `:name` markers in the statement and provide a `parameters` array in the
request payload. Parameter values are represented as strings. The optional
`type` field asks Databricks to cast and validate the string value as that SQL
type.

```matlab
statementExecution = databricks.StatementExecution;

parameter = databricks.datastructures.statementexecution.Parameter( ...
    name="my_id", value="2", type="BIGINT");

[T, status, statementId] = statementExecution.runStatement( ...
    "SELECT id FROM range(10) WHERE id = :my_id", ...
    warehouseId, parameters=parameter);
```

The same parameters can be passed with the lower-level `execute` workflow:

```matlab
request = databricks.datastructures.statementexecution.ExecuteStatementRequest;
request.statement = ...
    "SELECT id FROM range(10) WHERE id = :my_id";
request.warehouseId = warehouseId;
request.parameters = databricks.datastructures.statementexecution.Parameter( ...
    name="my_id", value="2", type="BIGINT");

[result, errorResponse] = statementExecution.execute(request);

if ~isempty(errorResponse)
    error("Statement execution failed: %s", errorResponse.message);
end
```

To pass a SQL `NULL`, omit the parameter `value`:

```matlab
request.parameters = databricks.datastructures.statementexecution.Parameter( ...
    name="missing_value");
```

Databricks Statement Execution supports named parameter markers only. Positional
`?` markers are not supported by this API.

## Query tags

Query tags annotate a SQL statement request. They can help identify statements
later in Databricks query history or in workspace observability workflows. A tag
has a required `key` and an optional `value`.

```matlab
statementExecution = databricks.StatementExecution;

queryTags(1) = databricks.datastructures.statementexecution.QueryTag( ...
    key="client", value="matlab");
queryTags(2) = databricks.datastructures.statementexecution.QueryTag( ...
    key="workflow", value="statement_execution");

[T, status, statementId] = statementExecution.runStatement( ...
    "SELECT 1 AS tagged_value", warehouseId, queryTags=queryTags);
```

The same query tags can be passed with the lower-level `execute` workflow:

```matlab
request = databricks.datastructures.statementexecution.ExecuteStatementRequest;
request.statement = "SELECT 1 AS tagged_value";
request.warehouseId = warehouseId;
request.queryTags(1) = databricks.datastructures.statementexecution.QueryTag( ...
    key="client", value="matlab");
request.queryTags(2) = databricks.datastructures.statementexecution.QueryTag( ...
    key="workflow", value="statement_execution");

[result, errorResponse] = statementExecution.execute(request);

if ~isempty(errorResponse)
    error("Statement execution failed: %s", errorResponse.message);
end
```

To send a tag with a key and no value, omit `value`:

```matlab
request.queryTags = databricks.datastructures.statementexecution.QueryTag( ...
    key="ad_hoc_analysis");
```

Databricks records at most one value per query tag key, and the order of query
tags is not significant. If more than 20 query tags are supplied, Databricks
coerces the sequence to 20.

## Methods of interest

Statement execution methods on `databricks.StatementExecution` include:

| Method | Purpose |
| --- | --- |
| `runStatement` | Execute a SQL statement, wait for completion, fetch results, and return a MATLAB table, final status, and statement ID. |
| `execute` | Submit an `ExecuteStatementRequest` and return the raw statement response. |
| `getStatement` | Get statement status, manifest, and the first result chunk when available. Generally used by lower-level workflows rather than end-user code. |
| `getResultChunkN` | Fetch a result chunk by zero-based chunk index. Generally used by lower-level workflows rather than end-user code. |
| `cancelExecution` | Request cancellation of a running statement. |

Internal implementation helpers such as
`databricks.internal.statementexecution.runStatementImpl` and
`databricks.internal.statementexecution.response2Table` live under the
`databricks.internal.statementexecution` package and are not the primary
user-facing API.

## References

Databricks documentation:

* [Databricks Statement Execution REST API](https://docs.databricks.com/api/statement-execution/v1/statement-execution)
* [Databricks workspace Statement Execution API reference](https://docs.databricks.com/api/workspace/statementexecution)
* [Databricks SQL execution tutorial](https://docs.databricks.com/aws/en/dev-tools/sql-execution-tutorial)

Related package documentation:

* [JDBC Connection based workflow](JDBCWorkflow.md)
* [Installing the Databricks JDBC driver](InstallingJDBCDriver.md)
* [Standalone JDBC interface](StandaloneJDBCDatabaseInterface.md)

[//]: #  (Copyright 2023-2026 The MathWorks, Inc.)
