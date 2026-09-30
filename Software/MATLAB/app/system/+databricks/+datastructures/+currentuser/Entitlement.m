classdef Entitlement < JSONMapper
    % ENTITLEMENT Class to represent entitlement information for a user
    
    % Copyright 2025 The MathWorks, Inc.
    
    properties
        ref string { JSONMapper.fieldName(ref, "$ref") }
        display string { JSONMapper.fieldName(display, "display") }
        primary logical { JSONMapper.fieldName(primary, "primary")}
        type string { JSONMapper.fieldName(type, "type") }
        value string { JSONMapper.fieldName(value, "value") }
    end

    methods
        function obj = Entitlement(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.currentuser.Entitlement
            end
            obj@JSONMapper(s, inputs);
        end
    end
end