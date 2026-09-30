function clusterPolicy = get(obj, policyId)
    % GET Return a cluster policy given the policy Id
    %
    %
    % Example:
    %   clusterPolicy = databricks.ClusterPolicy;
    %   clusterPolicy.get("D06205EB3700041C")
    %
    % Cf. https://docs.databricks.com/dev-tools/api/latest/policies.html

    % (c) 2022-2026 MathWorks, Inc.

    arguments
        obj databricks.ClusterPolicy
        policyId string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    uriArgs = {'policy_id', policyId};

    clusterURI = obj.getURI('policies/clusters', 'get', uriArgs{:});
    request = obj.getRequestMessage('GET');

    % Call databricks
    resp = request.send(clusterURI, obj.HTTPOptions);

    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        clusterPolicy = databricks.datastructures.clusterpolicy.Policy().fromJSON(resp.Body.Data);
    else
        clusterPolicy = databricks.datastructures.clusterpolicy.ErrorResponse().fromJSON(resp.Body.Data);
    end
end