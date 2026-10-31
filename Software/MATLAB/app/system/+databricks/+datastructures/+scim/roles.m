classdef roles < JSONMapper
    % EMAILS SCIM user roles

    % Copyright 2024 The MathWorks, Inc.

    properties
        ref string { JSONMapper.fieldName(ref, "$ref") }
        value string
        display string
        primary logical
        type string
    end

    methods
        function obj = roles(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.scim.roles
            end
            obj@JSONMapper(s, inputs);
        end
    end
end