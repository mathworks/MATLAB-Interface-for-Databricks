classdef CreateResponse < JSONMapper
    % CREATERESPONSE Represents a Databricks Cluster Policy Creation Response
    %
    % Properties
    %   policyId: Canonical unique identifier for the Cluster Policy
    %
    % See: https://docs.databricks.com/api/workspace/clusterpolicies/get
    %      https://docs.databricks.com/en/admin/clusters/policy-definition.html

    % Copyright 2024 The MathWorks, Inc.

    properties
        % Canonical unique identifier for the Cluster Policy
        policyId string { JSONMapper.fieldName(policyId, "policy_id") }
    end

    methods
        function obj = CreateResponse(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.clusterpolicy.CreateResponse
            end
            obj@JSONMapper(s, inputs);
        end
    end
end
