function result = createConnection(obj, connectionInfo)
    % CREATECONNECTION creates a new connection.
    %
    % Examples:
    %   result = uc.createConnection(connectionInfo);
    %
    %   connectionInfo =  databricks.datastructures.unitycatalog.ConnectionInfo();
    %   connectionInfo.connection_type = databricks.datastructures.unitycatalog.ConnectionType.HTTP;
    %   connectionInfo.name = "my_connection";
    %   connectionInfo.comment = "test connection to example.com";
    %   connectionInfo.options = JSONMapperMap( ...
    %     "host", "https://example.com", ...
    %     "port", "443", ...
    %     "bearer_token", "abcdREDACTEDefgh", ...
    %     "is_mcp_connection", "false", ...
    %     "base_path", "/my/base/path/");
    %   connectionInfo.read_only = false;
    %   result = uc.createConnection(connectionInfo);
    %
    % Required Inputs:
    %   connectionInfo
    %       Description:
    %           settings/configuration for the new connection
    %       Type:
    %           databricks.datastructures.unitycatalog.ConnectionInfo
    %       Required Properties in the data structure which must be set:
    %           connection_type
    %           name
    %           options
    %       Optional Properties in the data structure which can be set:
    %           comment
    %           connectionProperties
    %           read_only
    %
    % Outputs:
    %   result
    %       Description:
    %           settings/configuration of the created connection
    %       Type:
    %           databricks.datastructures.unitycatalog.Connection
    %
    % See Also: databricks.datastructures.unitycatalog.Connection
    %           https://docs.databricks.com/api/workspace/connections/create

    % Copyright 2026 The MathWorks, Inc.

    arguments
        obj databricks.UnityCatalog
        connectionInfo databricks.datastructures.unitycatalog.ConnectionInfo
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'connections');

    % Start a POST request
    request = obj.getRequestMessage('POST');

    % Set the body
    requiredProperties = ["name", "connection_type", "options"];

    optionalProperties = ["comment", "connectionProperties", "read_only"];

    request.Body(1).Payload = connectionInfo.getPayload(requiredProperties, optionalProperties);

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);

    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.Connection().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end