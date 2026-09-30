classdef GetPermissionsResponse < JSONMapper
    % GETPERMISSIONSRESPONSE Response to get cluster policy permissions 
    %
    % See: https://docs.databricks.com/api/workspace/clusterpolicies/getpermissions#access_control_list-all_permissions
    
    % Copyright 2024 The MathWorks, Inc.

    properties
        objectId string { JSONMapper.fieldName(objectId, "object_id") }
        objectType string { JSONMapper.fieldName(objectType, "object_type") }
        accessControlList databricks.datastructures.clusterpolicy.AccessControlList { JSONMapper.fieldName(accessControlList, "access_control_list"), JSONMapper.JSONArray }
    end


    methods
        function obj = GetPermissionsResponse(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.clusterpolicy.GetPermissionsResponse
            end
            obj@JSONMapper(s, inputs);
        end
    end
end