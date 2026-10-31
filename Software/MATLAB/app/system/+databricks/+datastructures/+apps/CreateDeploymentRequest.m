classdef CreateDeploymentRequest < JSONMapper
    % CreateDeploymentRequest
    %
    % App API 2.0

    % Copyright 2026 The MathWorks, Inc.

    properties
        command string { JSONMapper.fieldName(command, "command")}
        deploymentId string { JSONMapper.fieldName(deploymentId, "deployment_id")}
        envVars databricks.datastructures.apps.EnvVar { JSONMapper.fieldName(envVars, "env_vars"), JSONMapper.JSONArray }
        gitSource databricks.datastructures.apps.GitSource { JSONMapper.fieldName(gitSource, "git_source")}
        mode databricks.datastructures.apps.Mode { JSONMapper.fieldName(mode, "mode")}
        sourceCodePath string { JSONMapper.fieldName(sourceCodePath, "source_code_path")}
    end

    methods
        function obj = CreateDeploymentRequest(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.apps.CreateDeploymentRequest
            end
            obj@JSONMapper(s, inputs);
        end
    end
end
