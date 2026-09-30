classdef ComputeStatus < JSONMapper
    % ComputeStatus
    %
    % App API 2.0

    % Copyright 2026 The MathWorks, Inc.

    properties
        message string { JSONMapper.fieldName(message, "message")}
        state databricks.datastructures.apps.ComputeState { JSONMapper.fieldName(state, "state")}
    end

    methods
        function obj = ComputeStatus(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.apps.ComputeStatus
            end
            obj@JSONMapper(s, inputs);
        end
    end
end