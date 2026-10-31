classdef Permissions < JSONMapper
    % PERMISSIONS Defines the permissions of an instance pool
    % Instance pools can inherit permissions from their root object.

    % Copyright 2025 The MathWorks, Inc.

    properties
        accessControlList databricks.datastructures.clusterpolicy.AccessControlList { JSONMapper.fieldName(accessControlList, "access_control_list") }
        objectId string { JSONMapper.fieldName(objectId, "object_id") }
        objectType string { JSONMapper.fieldName(objectType, "object_type") }
    end

    methods
        function obj = Permissions(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.instancepools.Permissions
            end
            obj@JSONMapper(s, inputs);
        end
    end
end