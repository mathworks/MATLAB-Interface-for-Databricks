classdef DeploymentStatus < JSONMapper
    % DEPLOYMENTSTATUS
    %
    % App API 2.0

    % Copyright 2026 The MathWorks, Inc.

    properties
        message string { JSONMapper.fieldName(message, "message")}
        state databricks.datastructures.apps.DeploymentState { JSONMapper.fieldName(state, "state")}
    end

    methods
        function obj = DeploymentStatus(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.apps.DeploymentStatus
            end
            obj@JSONMapper(s, inputs);
        end
    end
end