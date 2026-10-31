classdef SQLWarehouse < JSONMapper
    % SQLWarehouse
    %
    % App API 2.0

    % Copyright 2026 The MathWorks, Inc.

    properties
        id string { JSONMapper.fieldName(id, "id")}
        permission databricks.datastructures.apps.SQLWarehousePermission { JSONMapper.fieldName(permission, "permission")}
    end

    methods
        function obj = SQLWarehouse(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.apps.SQLWarehouse
            end
            obj@JSONMapper(s, inputs);
        end
    end
end
