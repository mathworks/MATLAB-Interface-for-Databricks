classdef AllPermissions < JSONMapper
    % ALLPERMISSIONS Represents all permissions
    %
    % See: https://docs.databricks.com/api/workspace/clusterpolicies/getpermissions#access_control_list-all_permissions
    
    % Copyright 2024 The MathWorks, Inc.

    properties
        permissionLevel string { JSONMapper.fieldName(permissionLevel, "permission_level") }
        inherited logical
        inheritedFromObject string { JSONMapper.fieldName(inheritedFromObject, "inherited_from_object"), JSONMapper.JSONArray }
    end

    methods
        function obj = AllPermissions(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.clusterpolicy.AllPermissions
            end
            obj@JSONMapper(s, inputs);
        end
    end
end