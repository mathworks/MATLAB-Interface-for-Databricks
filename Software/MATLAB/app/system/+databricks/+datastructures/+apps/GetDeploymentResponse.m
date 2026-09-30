classdef GetDeploymentResponse < JSONMapper
    % GetDeploymentResponse
    %
    % App API 2.0
    %
    % See also: https://docs.databricks.com/api/workspace/apps/getdeployment


    % Copyright 2026 The MathWorks, Inc.

    properties
        command string { JSONMapper.fieldName(command, "command")}
        createTime datetime { JSONMapper.stringDatetime(createTime,'yyyy-MM-dd''T''HH:mm:ssZ',TimeZone='UTC'), JSONMapper.fieldName(createTime, "create_time") }
        creator string { JSONMapper.fieldName(creator, "creator")}
        deploymentArtifacts databricks.datastructures.apps.DeploymentArtifacts { JSONMapper.fieldName(deploymentArtifacts, "deployment_artifacts")}
        deploymentId string { JSONMapper.fieldName(deploymentId, "deployment_id")}
        envVars databricks.datastructures.apps.EnvVar { JSONMapper.fieldName(envVars, "env_vars"), JSONMapper.JSONArray }
        gitSource databricks.datastructures.apps.GitSource { JSONMapper.fieldName(gitSource, "git_source")}
        mode databricks.datastructures.apps.Mode { JSONMapper.fieldName(mode, "mode")}
        sourceCodePath string { JSONMapper.fieldName(sourceCodePath, "source_code_path")}
        status databricks.datastructures.apps.DeploymentStatus { JSONMapper.fieldName(status, "status")}
        updateTime datetime { JSONMapper.stringDatetime(updateTime,'yyyy-MM-dd''T''HH:mm:ssZ',TimeZone='UTC'), JSONMapper.fieldName(updateTime, "update_time") }
    end

    methods
        function obj = GetDeploymentResponse(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.apps.GetDeploymentResponse
            end
            obj@JSONMapper(s, inputs);
        end
    end
end
