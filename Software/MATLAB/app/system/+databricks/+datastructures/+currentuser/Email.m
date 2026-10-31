classdef Email < JSONMapper
    % EMAIL Class to represent email information for a user
    
    % Copyright 2025 The MathWorks, Inc.
    
    properties
        ref string { JSONMapper.fieldName(ref, "$ref") }
        display string { JSONMapper.fieldName(display, "display") }
        primary logical { JSONMapper.fieldName(primary, "primary")}
        type string { JSONMapper.fieldName(type, "type") }
        value string { JSONMapper.fieldName(value, "value") }
    end

    methods
        function obj = Email(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.currentuser.Email
            end
            obj@JSONMapper(s, inputs);
        end
    end
end