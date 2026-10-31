classdef Role < JSONMapper
    % ROLE Class to represent role information for a user
    
    % Copyright 2025 The MathWorks, Inc.
    
    properties
        ref string { JSONMapper.fieldName(ref, "$ref") }
        display string { JSONMapper.fieldName(display, "display") }
        primary logical { JSONMapper.fieldName(primary, "primary")}
        type string { JSONMapper.fieldName(type, "type") }
        value string { JSONMapper.fieldName(value, "value") }
    end

    methods
        function obj = Role(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.currentuser.Role
            end
            obj@JSONMapper(s, inputs);
        end
    end
end