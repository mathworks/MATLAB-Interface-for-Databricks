classdef AppDeployment < JSONMapper
    % APPDEPLOYMENT
    %
    % App API 2.0

    % Copyright 2026 The MathWorks, Inc.

    properties
        % The command with which to run the app. This will override the command specified in the app.yaml file.
        command string { JSONMapper.fieldName(command, "command")}
        % The creation time of the deployment. Formatted timestamp in ISO 6801.
        createTime datetime { JSONMapper.stringDatetime(createTime,'yyyy-MM-dd''T''HH:mm:ssZ',TimeZone='UTC'), JSONMapper.fieldName(createTime, "create_time") }
        % The email of the user creates the deployment.
        creator string { JSONMapper.fieldName(creator, "creator")}
        % The deployment artifacts for an app.
        deploymentArtifacts databricks.datastructures.apps.DeploymentArtifacts { JSONMapper.fieldName(deploymentArtifacts, "deployment_artifacts")}
        % The unique id of the deployment.
        deploymentId string { JSONMapper.fieldName(deploymentId, "deployment_id")}
        % The environment variables to set in the app runtime environment.
        % This will override the environment variables specified in the app.yaml file.
        envVars databricks.datastructures.apps.EnvVar { JSONMapper.fieldName(envVars, "env_vars"), JSONMapper.JSONArray }
        % Git repository to use as the source for the app deployment.
        gitSource databricks.datastructures.apps.GitSource { JSONMapper.fieldName(gitSource, "git_source")}
        % The mode of which the deployment will manage the source code.
        mode databricks.datastructures.apps.Mode { JSONMapper.fieldName(mode, "mode")}
        % The workspace file system path of the source code used to create the app deployment.
        % This is different from deployment_artifacts.source_code_path, which is the path used by the deployed app.
        % The former refers to the original source code location of the app in the workspace
        % during deployment creation, whereas the latter provides a system generated stable
        % snapshotted source code path used by the deployment.
        % Example "/Workspace/user@test.com/my_custom_app"
        sourceCodePath string { JSONMapper.fieldName(sourceCodePath, "source_code_path")}
        % Status and status message of the deployment
        status databricks.datastructures.apps.DeploymentStatus { JSONMapper.fieldName(status, "status")}
        % The update time of the deployment. Formatted timestamp in ISO 6801.
        updateTime datetime { JSONMapper.stringDatetime(updateTime,'yyyy-MM-dd''T''HH:mm:ssZ',TimeZone='UTC'), JSONMapper.fieldName(updateTime, "update_time") }
    end

    methods
        function obj = AppDeployment(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.apps.AppDeployment
            end
            obj@JSONMapper(s, inputs);
        end
    end
end