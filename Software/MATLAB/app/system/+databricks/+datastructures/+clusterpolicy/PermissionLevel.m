classdef PermissionLevel < JSONMapper
    % PERMISSIONLEVEL Represents specific permission level
    %
    % See: https://docs.databricks.com/api/workspace/clusterpolicies/getpermissionlevels#permission_levels-permission_level
    
    % Copyright 2024 The MathWorks, Inc.

    properties
        permissionLevel string { JSONMapper.fieldName(permissionLevel, "permission_level") }
        description string
    end


    methods
        function obj = PermissionLevel(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.clusterpolicy.PermissionLevel
            end
            obj@JSONMapper(s, inputs);
        end
    end
end