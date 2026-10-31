classdef groups < JSONMapper
    % EMAILS SCIM user groups

    % Copyright 2024 The MathWorks, Inc.

    properties
        ref string { JSONMapper.fieldName(ref, "$ref") }
        value string
        display string
        primary logical
        type string
    end

    methods
        function obj = groups(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.scim.groups
            end
            obj@JSONMapper(s, inputs);
        end
    end
end