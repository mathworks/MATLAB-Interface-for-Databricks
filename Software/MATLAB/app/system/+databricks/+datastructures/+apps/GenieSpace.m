classdef GenieSpace < JSONMapper
    % GenieSpace
    %
    % App API 2.0

    % Copyright 2026 The MathWorks, Inc.

    properties
        name string { JSONMapper.fieldName(name, "name")}
        permission databricks.datastructures.apps.GenieSpacePermission { JSONMapper.fieldName(permission, "permission")}
        spaceId string { JSONMapper.fieldName(spaceId, "space_id")}
    end

    methods
        function obj = GenieSpace(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.apps.GenieSpace
            end
            obj@JSONMapper(s, inputs);
        end
    end
end
