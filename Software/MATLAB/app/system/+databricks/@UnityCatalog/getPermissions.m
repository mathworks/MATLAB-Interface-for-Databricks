function result = getPermissions(obj, sec_type, sec_full_name,principal)
    % GETPERMISSIONS gets permissions as set for a given object.
    %
    % Example:
    %
    %   result = uc.getPermissions(sec_type, sec_full_name,principal);
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
    %
    % Optional Inputs:
    %   principal
    %       Description:
    %           Principal of interest, if set only return permissions for
    %           this user/group.
    %       Type:
    %           string
    %       Default Value:
    %           <empty>
    %
    % Outputs:
    %   result
    %       Description:
    %           List with permissions
    %       Type:
    %           databricks.datastructures.unitycatalog.PermissionsList
    %
    % Throws an error if the specified object cannot be found.
    %
    % See Also: databricks.datastructures.unitycatalog.PermissionsList
    
    % Copyright 2022-2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        sec_type string {mustBeTextScalar,mustBeMember(sec_type,[ ...
            "metastore","catalog","schema","table","storage-credential",...
            "external-location","view","function"])}
        sec_full_name string {mustBeTextScalar}
        principal string = string.empty
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'permissions');
    URI.Path(end+1) = sec_type;
    URI.Path(end+1) = sec_full_name;

    % Start a GET request
    request = obj.getRequestMessage('GET');

    if ~isempty(principal)
        URI.Query(end+1) = matlab.net.QueryParameter("principal",principal);
    end

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.PermissionsList().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end