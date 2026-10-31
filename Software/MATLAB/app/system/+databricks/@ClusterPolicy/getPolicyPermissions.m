function result = getPolicyPermissions(obj, policyId)
    % GETPERMISSIONLEVELS Gets the permissions of a cluster policy
    % Cluster policies can inherit permissions from their root object.
    %
    % Example:
    %   clusterPolicy = databricks.ClusterPolicy;
    %   list = clusterPolicy.list;
    %   id = list.policies(2).policyId;
    %   result = clusterPolicy.getPolicyPermissions(id);
    %   result = clusterPolicy.getPolicyPermissions(id)
    %   result = 
    %   GetPermissionsResponse with properties:
    %
    %            objectId: "/cluster-policies/0003EAAED5108C80"
    %          objectType: "cluster-policy"
    %   accessControlList: [1×2 databricks.datastructures.clusterpolicy.AccessControlList]
    %
    %
    % See: https://docs.databricks.com/api/workspace/clusterpolicies/getpermissions#access_control_list-all_permissions-inherited_from_object

    % (c) 2024-2026 MathWorks, Inc.

    arguments
        obj databricks.ClusterPolicy
        policyId string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    clusterURI = obj.getURI('permissions/cluster-policies', char(policyId));
    request = obj.getRequestMessage('GET');

    % Call databricks
    resp = request.send(clusterURI, obj.HTTPOptions);

    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.clusterpolicy.GetPermissionsResponse().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.clusterpolicy.ErrorResponse().fromJSON(resp.Body.Data);
    end
end
