classdef entitlements < JSONMapper
    % EMAILS SCIM user entitlements

    % Copyright 2024 The MathWorks, Inc.

    properties
        ref string { JSONMapper.fieldName(ref, "$ref") }
        value string
        display string
        primary logical
        type string
    end

    methods
        function obj = entitlements(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.scim.entitlements
            end
            obj@JSONMapper(s, inputs);
        end
    end
end