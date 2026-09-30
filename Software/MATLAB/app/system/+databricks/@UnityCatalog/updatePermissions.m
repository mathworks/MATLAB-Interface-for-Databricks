function result = updatePermissions(obj, sec_type, sec_full_name, permissionsdiff)
    % UPDATEPERMISSIONS updates permissions on a given object.
    %
    % The changes are specified through a PermissionsDiff object which has 
    % a changes property. changes in turn has an add and remove property,
    % use these to indeed add or remove permissions. UPDATEPERMISSIONS does 
    % not fully overwrite/replace existing permissions it really adds and 
    % removes the specified permissions to/from the existing ones.
    %
    % Example:
    %
    %   result = uc.updatePermissions(sec_type, sec_full_name, permissionsdiff);
    %
    % Required Inputs:
    %   sec_type
    %       Description:
    %           Type of object to retrieve permissions for
    %       Type:
    %           string
    %       Allowed Values:
    %           "metastore","catalog","schema","table",
    %           "storage-credential","external-location","view","function"
    %   sec_full_name  
    %       Description:
    %           full name of the object to retrieve permissions for
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
        sec_type string {mustBeTextScalar,mustBeMember(sec_type,[ ...
            "metastore","catalog","schema","table","storage-credential",...
            "external-location","view","function"])}
        sec_full_name string {mustBeTextScalar}
        permissionsdiff databricks.datastructures.unitycatalog.PermissionsDiff
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'permissions');
    URI.Path(end+1) = sec_type;
    URI.Path(end+1) = sec_full_name;

    % Start a PATCH request
    request = obj.getRequestMessage('PATCH');

    % Set the body
    requiredProperties = [];

    optionalProperties = [];

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