function result = getPermissionLevels(obj, policyId)
    % GETPERMISSIONLEVELS Gets the permission levels that a user can have on an object
    %
    % Example:
    %   clusterPolicy = databricks.ClusterPolicy;
    %   list = clusterPolicy.list;
    %   id = list.policies(2).policyId;
    %   result = clusterPolicy.getPermissionLevels(id);
    %   result.permissionLevels(1)
    %   ans = 
    %   PermissionLevel with properties:
    %      permissionLevel: "CAN_USE"
    %        description: "Can use the policy"
    %
    %
    % See: https://docs.databricks.com/api/workspace/clusterpolicies/getpermissionlevels

    % (c) 2024-2026 MathWorks, Inc.

    arguments
        obj databricks.ClusterPolicy
        policyId string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    clusterURI = obj.getURI('permissions/cluster-policies', [char(policyId), '/permissionLevels']);
    request = obj.getRequestMessage('GET');

    % Call databricks
    resp = request.send(clusterURI, obj.HTTPOptions);

    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.clusterpolicy.GetPermissionLevelsResponse().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.clusterpolicy.ErrorResponse().fromJSON(resp.Body.Data);
    end
end
