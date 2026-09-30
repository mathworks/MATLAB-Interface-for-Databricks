classdef Name < JSONMapper
    % NAME Class to represent name information for a user
    
    % Copyright 2025 The MathWorks, Inc.
    
    properties
        familyName string { JSONMapper.fieldName(familyName, "familyName") }
        givenName string { JSONMapper.fieldName(givenName, "givenName") }
    end

    methods
        function obj = Name(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.currentuser.Name
            end
            obj@JSONMapper(s, inputs);
        end
    end
end
