classdef Database < JSONMapper
    % DATABASE
    %
    % App API 2.0

    % Copyright 2026 The MathWorks, Inc.

    properties
        databaseName string { JSONMapper.fieldName(databaseName, "database_name")}
        instanceName string { JSONMapper.fieldName(instanceName, "instance_name")}
        permission databricks.datastructures.apps.DatabasePermission { JSONMapper.fieldName(permission, "permission")}
    end

    methods
        function obj = Database(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.apps.Database
            end
            obj@JSONMapper(s, inputs);
        end
    end
end
