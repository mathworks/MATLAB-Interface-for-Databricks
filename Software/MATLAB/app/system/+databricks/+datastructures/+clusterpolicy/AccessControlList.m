classdef AccessControlList < JSONMapper
    % ACCESSCONTROLLIST Represents all permissions
    %
    % See: https://docs.databricks.com/api/workspace/clusterpolicies/getpermissions#access_control_list-all_permissions
    
    % Copyright 2024 The MathWorks, Inc.

    properties
        userName string { JSONMapper.fieldName(userName, "user_name") }
        groupName string { JSONMapper.fieldName(groupName, "group_name") }
        servicePrincipalName string { JSONMapper.fieldName(servicePrincipalName, "service_principal_name") }
        displayName string { JSONMapper.fieldName(displayName, "display_name") } 
        allPermissions databricks.datastructures.clusterpolicy.AllPermissions { JSONMapper.fieldName(allPermissions, "all_permissions"), JSONMapper.JSONArray }
    end


    methods
        function obj = AccessControlList(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.clusterpolicy.AccessControlList
            end
            obj@JSONMapper(s, inputs);
        end
    end
end