classdef DeploymentArtifacts < JSONMapper
    % DEPLOYMENTARTIFACTS The deployment artifacts for an app
    %
    % App API 2.0

    % Copyright 2026 The MathWorks, Inc.

    properties
        % The snapshotted workspace file system path of the source code loaded by the deployed app.
        % Example "/Workspace/Users/9627a015-e892-43f7-9085-eec3892da408/src/01ef1a1ed75d1964b62234a35efa61fc"
        sourceCodePath string { JSONMapper.fieldName(sourceCodePath, "source_code_path")}
    end

    methods
        function obj = DeploymentArtifacts(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.apps.DeploymentArtifacts
            end
            obj@JSONMapper(s, inputs);
        end
    end
end
