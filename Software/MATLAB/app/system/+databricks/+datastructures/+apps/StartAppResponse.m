classdef StartAppResponse < JSONMapper
    % StartAppResponse
    %
    % App API 2.0

    % Copyright 2026 The MathWorks, Inc.

    properties
        activeDeployment databricks.datastructures.apps.AppDeployment { JSONMapper.fieldName(activeDeployment, "active_deployment")}
        appStatus databricks.datastructures.apps.AppStatus { JSONMapper.fieldName(appStatus, "app_status")}
        budgetPolicyId string { JSONMapper.fieldName(budgetPolicyId, "budget_policy_id")}
        computeSize databricks.datastructures.apps.ComputeSize { JSONMapper.fieldName(computeSize, "compute_size")}
        computeStatus databricks.datastructures.apps.ComputeStatus { JSONMapper.fieldName(computeStatus, "compute_status")}
        createTime datetime { JSONMapper.stringDatetime(createTime,'yyyy-MM-dd''T''HH:mm:ssZ',TimeZone='UTC'), JSONMapper.fieldName(createTime, "create_time") }
        creator string { JSONMapper.fieldName(creator, "creator")}
        defaultSourceCodePath string { JSONMapper.fieldName(defaultSourceCodePath, "default_source_code_path")}
        description string { JSONMapper.fieldName(description, "description")}
        effectiveBudgetPolicyId string { JSONMapper.fieldName(effectiveBudgetPolicyId, "effective_budget_policy_id")}
        effectiveUsagePolicyId string { JSONMapper.fieldName(effectiveUsagePolicyId, "effective_usage_policy_id")}
        effectiveUserApiScopes string { JSONMapper.fieldName(effectiveUserApiScopes, "effective_user_api_scopes"), JSONMapper.JSONArray }
        gitRepository databricks.datastructures.apps.GitRepository { JSONMapper.fieldName(gitRepository, "git_repository")}
        id string { JSONMapper.fieldName(id, "id")}
        name string { JSONMapper.fieldName(name, "name")}
        oauth2AppClientId string { JSONMapper.fieldName(oauth2AppClientId, "oauth2_app_client_id")}
        oauth2AppIntegrationId string { JSONMapper.fieldName(oauth2AppIntegrationId, "oauth2_app_integration_id")}
        pendingDeployment databricks.datastructures.apps.AppDeployment { JSONMapper.fieldName(pendingDeployment, "pending_deployment")}
        resources databricks.datastructures.apps.Resource { JSONMapper.fieldName(resources, "resources"), JSONMapper.JSONArray }
        servicePrincipalClientId string { JSONMapper.fieldName(servicePrincipalClientId, "service_principal_client_id")}
        servicePrincipalId int64 { JSONMapper.fieldName(servicePrincipalId, "service_principal_id")}
        servicePrincipalName string { JSONMapper.fieldName(servicePrincipalName, "service_principal_name")}
        telemetryExportDestinations databricks.datastructures.apps.TelemetryExportDestination { JSONMapper.fieldName(telemetryExportDestinations, "telemetry_export_destinations"), JSONMapper.JSONArray }
        thumbnailUrl string { JSONMapper.fieldName(thumbnailUrl, "thumbnail_url")}
        updateTime datetime { JSONMapper.stringDatetime(updateTime,'yyyy-MM-dd''T''HH:mm:ssZ',TimeZone='UTC'), JSONMapper.fieldName(updateTime, "update_time") }
        updater string { JSONMapper.fieldName(updater, "updater") }
        url string { JSONMapper.fieldName(url, "url") }
        usagePolicyId string { JSONMapper.fieldName(usagePolicyId, "usage_policy_id") }
        userApiScopes string { JSONMapper.fieldName(userApiScopes, "user_api_scopes"), JSONMapper.JSONArray }
    end

    methods
        function obj = StartAppResponse(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.apps.StartAppResponse
            end
            obj@JSONMapper(s, inputs);
        end
    end
end
