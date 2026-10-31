classdef InstancePools < JSONMapper
    % INSTANCEPOOLS Class to represent an array of instance pools

    % Copyright 2025 The MathWorks, Inc.

    properties
        instancePools databricks.datastructures.instancepools.InstancePool { JSONMapper.fieldName(instancePools, "instance_pools"), JSONMapper.JSONArray }        
    end

    methods
        function obj = InstancePools(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.instancepools.InstancePools
            end
            obj@JSONMapper(s, inputs);
        end
    end
end