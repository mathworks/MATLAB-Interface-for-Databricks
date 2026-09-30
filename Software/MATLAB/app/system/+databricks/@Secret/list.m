function secretTable = list(obj, varargin)
    % LIST List the secret keys that are stored at this scope
    % Only metadata is returned. Secret values cannot be retrieved using this API.
    % If no secrets are defined an empty table is returned. Timestamps are returned
    % as MATLAB datetime values in UTC. Keys are returns as strings and
    % timestamps as datetimes with the table. If there are no secrets an
    % empty table is returned.
    %
    % Example:
    %   result = secret.list
    %   result = 2x2 table
    %     key       last_updated_timestamp
    %   ________    ______________________
    %   "myKey1"     14-Oct-2024 11:19:37 
    %   "myKey2"     14-Oct-2024 11:20:08 

    %   (c) 2020-2026 The MathWorks, Inc.

    if isempty(obj.scope)
        error('DATABRICKS:ERROR','Scope not set');
    end

    % Initializations
    curAPI = 'secrets';
    apiMethod = 'list';
    curURI = obj.getURI(curAPI, apiMethod);
    curURI.Query(end+1) = matlab.net.QueryParameter("scope", obj.scope);

    % Create a request to create a secret scope
    request = obj.getRequestMessage;
    request.Method = matlab.net.http.RequestMethod.GET;

    % Call Databricks
    resp = request.send(curURI, obj.HTTPOptions);

    % Process the response
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        secretArray = databricks.datastructures.secret.secretList().fromJSON(resp.Body.Data);
        nrows = numel(secretArray.secrets);
        secretTable = table('Size', [nrows, 2], 'VariableTypes', ["string", "datetime"], 'VariableNames', ["key", "last_updated_timestamp"]);
        secretTable.last_updated_timestamp.TimeZone = 'UTC';
        for n = 1:nrows
            secretTable(n,:) = {string(secretArray.secrets(n).key), secretArray.secrets(n).last_updated_timestamp};
        end
    else
        matlab.databricks.internal.responseError(resp, 'Failed to list secrets');
    end
end