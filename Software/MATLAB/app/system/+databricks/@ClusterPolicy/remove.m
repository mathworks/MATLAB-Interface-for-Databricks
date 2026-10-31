function result = remove(obj, policyId, options)
    % REMOVE Delete Cluster Policy given the policy Id
    %
    % Example:
    %   cp = databricks.ClusterPolicy();
    %   cp.remove("D06205EB3700041C");
    %
    % Cf. https://docs.databricks.com/dev-tools/api/latest/policies.html

    % (c) 2022-2026 MathWorks, Inc.

    arguments
        obj databricks.ClusterPolicy
        policyId string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.verbose (1,1) logical = true
    end

    clusterURI = obj.getURI('policies/clusters', 'delete');
    request = obj.getRequestMessage('POST');

    request.Body = matlab.net.http.MessageBody;
    request.Body.Payload = jsonencode( ...
        struct('policy_id', policyId)...
        );

    % Call databricks
    resp = request.send(clusterURI, obj.HTTPOptions);

    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        if options.verbose
            fprintf('Successfully removed Cluster Policy: %s\n', policyId);
        end
        result = databricks.datastructures.clusterpolicy.ErrorResponse().empty;
    else
        % Could not delete cluster policy
        if options.verbose
            fprintf(2, 'Failed to delete Cluster Policy: %s"\n', policyId);
        end
        result = databricks.datastructures.clusterpolicy.ErrorResponse().fromJSON(resp.Body.Data);
    end
end