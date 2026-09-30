function result = edit(obj, policyUpdateRequest, options)
    %  Edit Cluster Policy
    %
    % Change a Cluster Policy. Input is provided as a databricks.datastructures.clusterpolicy.PolicyUpdateRequest
    %
    % Optional named arguments
    %   verbose        Produce additional output, default is true.
    %
    % On success an empty databricks.datastructures.clusterpolicy.ErrorResponse
    % is returned, otherwise a populated ErrorResponse is returned.
    %
    % Example:
    %   cp = databricks.ClusterPolicy();
    %   pur = databricks.datastructures.clusterpolicy.PolicyUpdateRequest();
    %   pur.policyId = "D06205EB3700041C";
    %   pur.definition = string('{"spark_conf.spark.databricks.cluster.profile":{"type":"forbidden","hidden":true}}');
    %   cp.edit(pur)

    % (c) 2022-2026 MathWorks, Inc.

    arguments
        obj databricks.ClusterPolicy
        policyUpdateRequest (1,1) databricks.datastructures.clusterpolicy.PolicyUpdateRequest
        options.verbose (1,1) logical = true
    end

    clusterURI = obj.getURI('policies/clusters', 'edit');
    request = obj.getRequestMessage('POST');

    request.Body = matlab.net.http.MessageBody;

    requiredProperties = "policyId";
    optionalProperties = ["name", "definition", "description", "policyFamilyId", "policyFamilyDefinitionOverrides", "maxClustersPerUser", "libraries"];

    request.Body(1).Payload = policyUpdateRequest.getPayload(requiredProperties, optionalProperties);

    % Call databricks
    resp = request.send(clusterURI, obj.HTTPOptions);

    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
       % No return value, edit worked.
       result = databricks.datastructures.clusterpolicy.ErrorResponse().empty;
    else
        % Could not list cluster policies
        result = databricks.datastructures.clusterpolicy.ErrorResponse().fromJSON(resp.Body.Data);
        if options.verbose
            fprintf(2, 'Failed to update cluster policy: %s\n', policyUpdateRequest.policyId);
        end
    end
end