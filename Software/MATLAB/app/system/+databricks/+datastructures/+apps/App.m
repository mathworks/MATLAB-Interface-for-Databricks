classdef App < JSONMapper
    % APP
    %
    % App API 2.0

    % Copyright 2026 The MathWorks, Inc.

    properties
        name string { JSONMapper.fieldName(name, "name")}
        permission databricks.datastructures.apps.AppPermission { JSONMapper.fieldName(permission, "permission")}
    end

    methods
        function obj = App(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.apps.App
            end
            obj@JSONMapper(s, inputs);
        end
    end
end
