classdef Status < JSONMapper
    % STATUS Status of failed pending instances in the pool

    % Copyright 2025 The MathWorks, Inc.

    properties
        pendingInstanceErrors databricks.datastructures.instancepools.PendingInstanceError { JSONMapper.fieldName(pendingInstanceErrors, "pending_instance_errors"), JSONMapper.JSONArray}    
    end

    methods
        function obj = Status(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.instancepools.Status
            end
            obj@JSONMapper(s, inputs);
        end
    end
end