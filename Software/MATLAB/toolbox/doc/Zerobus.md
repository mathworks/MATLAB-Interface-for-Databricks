# Zerobus   (Preview)

Zerobus ingest provides near real-time data ingestion of data into tables at high
bandwidth for thousands of clients without need for a message bus. For details see:
[https://www.databricks.com/product/data-engineering/lakeflow-connect/zerobus-ingest](https://www.databricks.com/product/data-engineering/lakeflow-connect/zerobus-ingest)

> Zerobus was announced by Databricks&reg; at the Data + AI Summit in June 2026.
> It is currently a preview feature and so this interface may change without notice.

## Prerequisites

* A destination table.
* A service principal.
* Appropriate permissions granted to the service principal.

To create a table and grant permissions, given, sufficient rights, SQL can be used, e.g.:

```sql
%sql
CREATE TABLE main.default.air_quality (device_name STRING, temp INT, humidity LONG);
```

```sql
%sql
GRANT USE CATALOG ON CATALOG main TO `a<REDACTED>1`;
GRANT USE SCHEMA ON SCHEMA main.default TO `a<REDACTED>1`;
GRANT MODIFY, SELECT ON TABLE main.default.air_quality TO `a<REDACTED>1`;
```

For further details see:

[https://docs.databricks.com/aws/en/ingestion/zerobus-ingest#get-your-workspace-url-and-zerobus-ingest-endpoint](https://docs.databricks.com/aws/en/ingestion/zerobus-ingest#get-your-workspace-url-and-zerobus-ingest-endpoint)

## Zerobus client

Create a Zerobus object that will authenticate as the service principal:

```matlab
z = databricks.Zerobus(catalog="main", schema="default", table="air_quality", clientId="a<REDACTED>1", clientSecret="d<REDACTED>5")
```

The client can be used to make repeated inserts into the table without the need for
repeated authentication. The client obtains an access token with a life span of 1 hour.
When the token expires the client will refresh the token.

> Currently a token may expire during a large transaction leading to a failure without a retry.

The following example creates a JSON payload array of two sets of values, corresponding
to two table rows using the previously defined table schema.

```matlab
payload = ['[{ "device_name": "device_num_1", "temp": 28, "humidity": 60 },', newline ...
            '{ "device_name": "device_num_2", "temp": 25, "humidity": 55 }]'];

% Insert the data into the table
[result, errorResponse] = z.insert(payload);
```

Repeated calls to the `insert` method can be made with different payloads. A new client
should generally not be created per `insert` call to reduce overhead.

> Writing a *batch* of rows of data in a single request is more efficient than writing
> individual rows if the data is available a priori.

## Example:

First created a table using SQL
```sql
CREATE TABLE main.default.air_quality (device_name STRING, temp INT, humidity LONG);
```

```matlab

t = "air_quality";
catalog = "main";
schema = "default";

sp_secret = "d<REDACTED>5";
sp_client_id = "a<REDACTED>1";

% Create the Zerobus object
z = databricks.Zerobus(catalog=catalog, schema=schema, table=t, clientId=sp_client_id, clientSecret=sp_secret)

% Write 10 rows in total
numRows = 10;

% Write 2 batched rows at a time
for n = 1:2:numRows
    % Sample random temperature data
    t1 = randi([-10, 50]);
    t2 = randi([-10, 50]);
    % Sample random humidity data
    h1 = randi([30, 100]);
    h2 = randi([30, 100]);
    % Ids for the supposed measurement devices
    id1 = "device_num_" + string(num2str(n));
    id2 = "device_num_" + string(num2str(n+1));

    % Payload for 2 rows as a JSON array
    payload = char(sprintf('[{"device_name": "%s", "temp": %d, "humidity": %d }, \n { "device_name": "%s", "temp": %d, "humidity": %d }]',...
        id1, t1, h1, id2, t2, h2));
    
    % Provide some feedback
    if mod(n,5) == 0
        fprintf("Insert call #%d\n", n);
    end

    % Send the data to Databricks
    [result, errorResponse] = z.insert(payload);
    assert(result);
end


```

[//]: #  (Copyright 2026 The MathWorks, Inc.)
