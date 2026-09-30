classdef Postgres < JSONMapper
    % Postgres
    %
    % App API 2.0

    % Copyright 2026 The MathWorks, Inc.

    properties
        branch string { JSONMapper.fieldName(branch, "branch")}
        database string { JSONMapper.fieldName(database, "database")}
        permission databricks.datastructures.apps.PostgresPermission { JSONMapper.fieldName(permission, "permission")}
    end

    methods
        function obj = Postgres(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.apps.Postgres
            end
            obj@JSONMapper(s, inputs);
        end
    end
end
