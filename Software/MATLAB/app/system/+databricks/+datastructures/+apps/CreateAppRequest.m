classdef CreateAppRequest < JSONMapper
    % CreateAppRequest
    %
    % App API 2.0

    % Copyright 2026 The MathWorks, Inc.

    properties
        budgetPolicyId string { JSONMapper.fieldName(budgetPolicyId, "budget_policy_id")}
        computeSize databricks.datastructures.apps.ComputeSize { JSONMapper.fieldName(computeSize, "compute_size")}
        description string { JSONMapper.fieldName(description, "description")}
        gitRepository databricks.datastructures.apps.GitRepository { JSONMapper.fieldName(gitRepository, "git_repository")}
        name string { JSONMapper.fieldName(name, "name")}
        resources databricks.datastructures.apps.Resource { JSONMapper.fieldName(resources, "resources"), JSONMapper.JSONArray }
        telemetryExportDestinations databricks.datastructures.apps.TelemetryExportDestination { JSONMapper.fieldName(telemetryExportDestinations, "telemetry_export_destinations"), JSONMapper.JSONArray }
        usagePolicyId string { JSONMapper.fieldName(usagePolicyId, "usage_policy_id") }
        userApiScopes string { JSONMapper.fieldName(userApiScopes, "user_api_scopes"), JSONMapper.JSONArray }
    end

    methods
        function obj = CreateAppRequest(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.apps.CreateAppRequest
            end
            obj@JSONMapper(s, inputs);
        end
    end
end
