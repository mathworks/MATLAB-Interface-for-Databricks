classdef emails < JSONMapper
    % EMAILS SCIM user emails

    % Copyright 2024 The MathWorks, Inc.

    properties
        ref string { JSONMapper.fieldName(ref, "$ref") }
        value string
        display string
        primary logical
        type string
    end

    methods
        function obj = emails(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.scim.emails
            end
            obj@JSONMapper(s, inputs);
        end
    end
end