classdef Space < JSONMapper
    % SPACE Class to represent a Genie space

    % Copyright 2025 The MathWorks, Inc.

    properties
        description string { JSONMapper.fieldName(description, "description") }
        spaceId string { JSONMapper.fieldName(spaceId, "space_id") }
        title string { JSONMapper.fieldName(title, "title") }
    end

    methods
        function obj = Space(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.genie.Space
            end
            obj@JSONMapper(s, inputs);
        end
    end
end