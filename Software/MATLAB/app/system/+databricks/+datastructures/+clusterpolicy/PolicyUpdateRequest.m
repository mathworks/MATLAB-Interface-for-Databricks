classdef PolicyUpdateRequest < JSONMapper
    % POLICYUPDATEREQUEST Represents a Databricks Cluster Policy update
    %
    % See: https://docs.databricks.com/api/workspace/clusterpolicies/get
    %      https://docs.databricks.com/en/admin/clusters/policy-definition.html
    
    % Copyright 2024 The MathWorks, Inc.
    
    properties
        % Canonical unique identifier for the Cluster Policy
        policyId string { JSONMapper.fieldName(policyId, "policy_id") }
        % Cluster Policy name requested by the user. This has to be unique. Length must be between 1 and 100 characters.
        name string
        % Policy definition document expressed in Databricks Cluster Policy Definition Language.
        % The value be automatically escaped.
        definition string
        % Additional human-readable description of the cluster policy, <= 1000 characters.
        description string
        % ID of the policy family. The cluster policy's policy definition inherits the policy family's policy definition.
        policyFamilyId string { JSONMapper.fieldName(policyFamilyId, "policy_family_id") }
        % Policy definition JSON document expressed in Databricks Policy Definition Language.
        % The value be automatically escaped.
        policyFamilyDefinitionOverrides string { JSONMapper.fieldName(policyFamilyDefinitionOverrides, "policy_family_definition_overrides") }
        % Max number of clusters per user that can be active using this policy. If not present, there is no max limit, >= 1.
        maxClustersPerUser int64 { JSONMapper.fieldName(maxClustersPerUser, "max_clusters_per_user") }
        % A list of libraries to be installed on the next cluster restart that uses this policy. The maximum number of libraries is 500.
        libraries databricks.datastructures.libraries.Library {JSONMapper.JSONArray}
        % Creator user name. The field won't be included in the response if the user has already been deleted.
    end
    
    methods
        function obj = PolicyUpdateRequest(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.clusterpolicy.PolicyUpdateRequest
            end
            obj@JSONMapper(s, inputs);
        end
    end
end
