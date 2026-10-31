classdef Secret < JSONMapper
    % Secret
    %
    % App API 2.0

    % Copyright 2026 The MathWorks, Inc.

    properties
        key string { JSONMapper.fieldName(key, "key")}
        permission databricks.datastructures.apps.SecretPermission { JSONMapper.fieldName(permission, "permission")}
        scope string { JSONMapper.fieldName(scope, "scope")}
    end

    methods
        function obj = Secret(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.apps.Secret
            end
            obj@JSONMapper(s, inputs);
        end
    end
end
