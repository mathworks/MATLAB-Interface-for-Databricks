classdef ServingEndpoint < JSONMapper
    % ServingEndpoint
    %
    % App API 2.0

    % Copyright 2026 The MathWorks, Inc.

    properties
        name string { JSONMapper.fieldName(name, "name")}
        permission databricks.datastructures.apps.ServingEndpointPermission { JSONMapper.fieldName(permission, "permission")}
    end

    methods
        function obj = ServingEndpoint(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.apps.ServingEndpoint
            end
            obj@JSONMapper(s, inputs);
        end
    end
end
