function result = updateConnection(obj, name, connectionUpdateRequest)
    % UPDATECONNECTION updates catalog settings.
    %
    % Only the values which are actually set in the data structure will be
    % updated. To not update/change a value leave the property entirely
    % empty in the data structure.
    %
    % Examples:
    %   result = uc.updateConnection(name, updateConnection);
    %
    %   connectionUpdateRequest = databricks.datastructures.unitycatalog.ConnectionUpdateRequest();
    %   connectionUpdateRequest.new_name = "my_new_connection_name";
    %   connectionUpdateRequest.options = JSONMapperMap("host", "https://new.example.com", "bearer_token", "abcdefgh");
    %   result = uc.updateConnection("my_connection", connectionUpdateRequest);
    %
    % Required Inputs:
    %   name
    %       Description:
    %           (current) name of connection
    %       Type:
    %           string
    %   connectionUpdateRequest
    %       Description:
    %           Information to update
    %       Type:
    %           databricks.datastructures.unitycatalog.ConnectionUpdateRequest
    %       Required Properties
    %           options
    %       Optional Properties in the data structure which can be updated:
    %           new_name
    %           options
    %           owner
    %
    % Outputs:
    %   result
    %       Description:
    %           updated connection settings/configuration
    %       Type:
    %           databricks.datastructures.unitycatalog.Connection
    %
    % See Also: databricks.datastructures.unitycatalog.Connection
    %           https://docs.databricks.com/api/workspace/connections/update
    
    % Copyright 2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        name string {mustBeTextScalar}
        connectionUpdateRequest databricks.datastructures.unitycatalog.ConnectionUpdateRequest
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'connections');
    URI.Path(end+1) = name;

    % Start a PATCH request
    request = obj.getRequestMessage('PATCH');

    % Set the body
    requiredProperties = ["options"]; %#ok<NBRAK2>

    optionalProperties = ["new_name", "owner"];

    request.Body(1).Payload = connectionUpdateRequest.getPayload(requiredProperties, optionalProperties);

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.Connection().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end