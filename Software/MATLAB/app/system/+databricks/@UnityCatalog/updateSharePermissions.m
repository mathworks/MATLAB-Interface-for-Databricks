function result = updateSharePermissions(obj, name, permissionsdiff)
    % UPDATESHAREPERMISSIONS updates permissions on a delta sharing share.
    %
    % The changes are specified through a PermissionsDiff object which has
    % a changes property. changes in turn has an add and remove property,
    % use these to indeed add or remove permissions. UPDATESHAREPERMISSIONS
    % does not fully overwrite/replace existing permissions it really adds
    % and removes the specified permissions to/from the existing ones.
    %
    % Example:
    %
    %   result = updateSharePermissions(name, permissionsdiff);
    %
    % Required Inputs:
    %   name
    %       Description:
    %           share name
    %       Type:
    %           string
    %   permissionsdiff
    %       Description:
    %           Information to update
    %       Type:
    %           databricks.datastructures.unitycatalog.PermissionsDiff
    %   
    % Outputs:
    %   result
    %       Description:
    %           updated permissions
    %       Type:
    %           databricks.datastructures.unitycatalog.PermissionsList
    %
    % See Also: databricks.datastructures.unitycatalog.PermissionsDiff,
    %           databricks.datastructures.unitycatalog.PermissionsList
    
    % Copyright 2022-2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        name string {mustBeTextScalar}
        permissionsdiff databricks.datastructures.unitycatalog.PermissionsDiff
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'shares');
    URI.Path(end+1) = name;
    URI.Path(end+1) = "permissions";

    % Start a PATCH request
    request = obj.getRequestMessage('PATCH');

    % Set the body
    requiredProperties = [ ];

    optionalProperties = [ ];

    request.Body(1).Payload = permissionsdiff.getPayload(requiredProperties,optionalProperties);

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.PermissionsList().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end