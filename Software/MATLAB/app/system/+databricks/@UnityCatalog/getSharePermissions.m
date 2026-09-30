function result = getSharePermissions(obj, name)
    % GETSHAREPERMISSIONS gets permissions of specified delta sharing share.
    %
    % Example:
    %
    %   result = uc.getSharePermissions(name);
    %
    % Required Inputs:
    %   name
    %       Description:
    %           name of the share
    %       Type:
    %           string
    %
    % Outputs:
    %   result
    %       Description:
    %           permissions on the share
    %       Type:
    %           databricks.datastructures.unitycatalog.PermissionsList
    %
    % Throws an error if the specified share cannot be found.
    %
    % See Also: databricks.datastructures.unitycatalog.PermissionsList
    
    % Copyright 2022-2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        name string {mustBeTextScalar}
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'shares');
    URI.Path(end+1) = name;
    URI.Path(end+1) = "permissions";
    
    % Start a GET request
    request = obj.getRequestMessage('GET');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.PermissionsList().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end