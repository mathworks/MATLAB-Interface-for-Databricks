classdef CreateRequest < JSONMapper
    % CREATEREQUEST Represents a Databricks Cluster Policy Creation Request
    %
    %
    % Properties:
    %   name: Cluster Policy name requested by the user. This has to be unique.
    %         Length must be between 1 and 100 characters.
    %
    %   definition: Policy definition document expressed in Databricks Cluster
    %               Policy Definition Language. The value will be automatically escaped.
    %
    %   description: Additional human-readable description of the cluster policy,
    %                <= 1000 characters.
    %
    %   policyFamilyId: ID of the policy family. The cluster policy's policy definition
    %                   inherits the policy family's policy definition.
    %
    %   policyFamilyDefinitionOverrides: Policy definition JSON document expressed in
    %                                    Databricks Policy Definition Language.
    %
    %   maxClustersPerUser: Max number of clusters per user that can be active using this policy. If not present, there is no max limit.
    %
    %   libraries: A list of libraries to be installed on the next cluster restart that uses this policy. The maximum number of libraries is 500.
    %
    %
    % See: https://docs.databricks.com/api/workspace/clusterpolicies/get
    %      https://docs.databricks.com/en/admin/clusters/policy-definition.html

    % Copyright 2024 The MathWorks, Inc.

    properties
        % Cluster Policy name requested by the user. This has to be unique. Length must be between 1 and 100 characters.
        name string
        % Policy definition document expressed in Databricks Cluster Policy Definition Language.
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
    end

    methods
        function obj = CreateRequest(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.clusterpolicy.CreateRequest
            end
            obj@JSONMapper(s, inputs);
        end
    end
end
