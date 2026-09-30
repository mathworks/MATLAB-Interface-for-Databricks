classdef PendingInstanceError < JSONMapper
    % PENDINGINSTANCEERROR

    % Copyright 2025 The MathWorks, Inc.

    properties
        instanceId string { JSONMapper.fieldName(instanceId, "instance_id") }
        message string
    end

    methods
        function obj = PendingInstanceError(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.instancepools.PendingInstanceError
            end
            obj@JSONMapper(s, inputs);
        end
    end
end