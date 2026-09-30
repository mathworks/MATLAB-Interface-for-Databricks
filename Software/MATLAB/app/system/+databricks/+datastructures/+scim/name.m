classdef name < JSONMapper
    % EMAILS SCIM user name

    % Copyright 2024 The MathWorks, Inc.

    properties
        givenName string
        familyName string
    end

    methods
        function obj = name(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.scim.name
            end
            obj@JSONMapper(s, inputs);
        end
    end
end