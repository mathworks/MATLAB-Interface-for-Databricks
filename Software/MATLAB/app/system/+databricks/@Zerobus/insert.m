function [result, errorResponse] = insert(obj, payload, options)
    % insert inserts a payload into the catalog.schema.table defined in the Zerobus object
    % Currently only JSON payloads are supported.
    %
    % Example:
    %   % First create a table created in this case using SQL in a Notebook
    %   %sql
    %   CREATE TABLE main.default.air_quality (device_name STRING, temp INT, humidity LONG);
    %   
    %   % Create a service principal and enable permissions for the table.
    %   % See: databricks Documentation linked below.
    %
    %   % Create a Zerobus object that will authenticate as the service principal
    %   z = databricks.Zerobus(catalog="main", schema="default", table="air_quality", clientId="a<REDACTED>1", clientSecret="d<REDACTED>5")
    %
    %   % Create a JSON payload array of 2 sets values, corresponding to 2 table rows
    %   payload = ['[{ "device_name": "device_num_1", "temp": 28, "humidity": 60 },', newline ...
    %               '{ "device_name": "device_num_2", "temp": 25, "humidity": 55 }]'];
    %
    %   % Insert the data into the table
    %   [result, errorResponse] = z.insert(payload);
    %
    % See also:
    %   https://www.databricks.com/product/data-engineering/lakeflow-connect/zerobus-ingest
    %   https://docs.databricks.com/aws/en/ingestion/zerobus-ingest?language=REST%C2%A0API
    
    % Copyright 2026 MathWorks Inc.

    % TODO: Handle a token expiring mid-transaction, refresh and retry.

    arguments (Input)
        obj
        payload string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.verbose (1,1) logical = false
    end

    URI = matlab.net.URI(obj.endpoint);
    URI.Path = {'zerobus', 'v1', 'tables', [char(obj.catalog), '.', char(obj.schema), '.', char(obj.table)], 'insert'};
    request = matlab.net.http.RequestMessage;
    request.Method = matlab.net.http.RequestMethod("POST");
    % Assumes a JSON payload for now
    request.Header(end+1) = matlab.net.http.field.ContentTypeField('application/json');
    request.Header(end+1) = matlab.net.http.HeaderField("User-Agent", obj.UserAgent);

    % Assume the token will remain valid for the duration of transaction
    [accessToken, expiryTime, errorResponse] = obj.getAccessToken(obj.catalog, obj.schema, obj.table, obj.clientId, obj.clientSecret, verbose=options.verbose);
    if isempty(accessToken) || strlength(accessToken) == 0 || isempty(expiryTime)
        disp(errorResponse);
        error("DATABRICKS:ZEROBUS:INSERT:AUTH", "insert authentication failed.")
    end
    request.Header(end+1) = matlab.net.http.HeaderField("Authorization", "Bearer " + accessToken);

    request.Body = matlab.net.http.MessageBody;
    request.Body.Payload = payload;

    resp = request.send(URI, obj.HTTPOptions);

    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = true;
        errorResponse = databricks.datastructures.ErrorResponse.empty;      
    else
        result = false;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);      
    end
end

