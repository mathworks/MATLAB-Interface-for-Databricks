classdef Stats < JSONMapper
    % STATS Usage statistics about the instance pool.

    % Copyright 2025 The MathWorks, Inc.

    properties
        idleCount int32 { JSONMapper.fieldName(idleCount, "idle_count") } 
        pendingIdleCount int32 { JSONMapper.fieldName(pendingIdleCount, "pending_idle_count") }
        usedCount int32 { JSONMapper.fieldName(usedCount, "used_count") }
        pendingUsedCount int32 { JSONMapper.fieldName(pendingUsedCount, "pending_used_count") }
    end

    methods
        function obj = Stats(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.instancepools.Stats
            end
            obj@JSONMapper(s, inputs);
        end
    end
end