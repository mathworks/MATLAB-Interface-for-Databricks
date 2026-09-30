function result = create(obj, createRequest)
    % create Creates a Cluster Policy based on a policy definition
    % The policy definition is provided as a string.
    %
    % Required arguments:
    %   createRequest: A databricks.datastructures.clusterpolicy.CreateRequest
    %
    % Example:
    %    cp = databricks.ClusterPolicy;
    %    cr = databricks.datastructures.clusterpolicy.CreateRequest;
    %    cr.name = "My Cluster Name";
    %    cr.definition = '{"spark_conf.spark.databricks.cluster.profile":{"type":"forbidden","hidden":true}}';
    %    cr.description = "My Policy Description";
    %    cp.create(cr);
    %
    % See also: https://docs.databricks.com/administration-guide/clusters/policy-definition.html

    % (c) 2022-2026 MathWorks, Inc.

    arguments
        obj databricks.ClusterPolicy
        createRequest (1,1) databricks.datastructures.clusterpolicy.CreateRequest
    end

    if (isprop(createRequest, "definition") && ~isempty(createRequest.definition) && strlength(createRequest.definition) > 0) && (isprop(createRequest, "policyFamilyId") && ~isempty(createRequest.policyFamilyId) && strlength(createRequest.policyFamilyId) > 0)
        error("definition & policyFamilyId cannot both be set use policyFamilyDefinitionOverrides instead");
    end

    %% Create a new spark cluster on databricks
    clusterURI = obj.getURI('policies/clusters', 'create');
    request = obj.getRequestMessage('POST');

    request.Body = matlab.net.http.MessageBody;

    % Set the body
    requiredProperties = "name";
    optionalProperties = ["definition", "description", "policyFamilyId", "policyFamilyDefinitionOverrides", "maxClustersPerUser", "libraries"];

    request.Body(1).Payload = createRequest.getPayload(requiredProperties, optionalProperties);

    % Call databricks
    resp = request.send(clusterURI, obj.HTTPOptions);

    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        createResponse = databricks.datastructures.clusterpolicy.CreateResponse().fromJSON(resp.Body.Data);
        if isprop(createResponse, "policyId")
            result = createResponse.policyId;
        else
            error("No policyId found in databricks.datastructures.clusterpolicy.CreateResponse");
        end
    else
        result = databricks.datastructures.clusterpolicy.ErrorResponse().fromJSON(resp.Body.Data);
    end
end