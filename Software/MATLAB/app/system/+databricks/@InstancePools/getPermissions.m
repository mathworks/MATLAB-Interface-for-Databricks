function [result, errorResponse] = getPermissions(obj, id)
    % GETPERMISSIONS Retrieve the information for an instance pool based on its identifier
    %
    % Example:
    %   ip = databricks.InstancePools;
    %   instance_pool_id="1234-567890-fetch12-pool-A3BcdEFg"
    %   permissions = ip.getPermissions(instance_pool_id)
    %     permissions = 
    %
    %   Permissions with properties:
    %
    %     accessControlList: [1x2 databricks.datastructures.clusterpolicy.AccessControlList]
    %              objectId: "/instance-pools/0826-084204-pots8-pool-7jdm3sfb"
    %            objectType: "instance-pool"

    % (c) 2025-2026 The MathWorks Inc

    arguments
        obj databricks.InstancePools
        id string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    % Get URI
    URI = obj.getURI('permissions', 'instance-pools');

    URI.Path(end+1) = id;
   
    request = obj.getRequestMessage('GET');

    resp = request.send(URI, obj.HTTPOptions);
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.instancepools.Permissions().fromJSON(resp.Body.Data);
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        result = databricks.datastructures.instancepools.Permissions.empty;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end