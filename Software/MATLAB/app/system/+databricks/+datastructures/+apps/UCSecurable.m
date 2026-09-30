classdef UCSecurable < JSONMapper
    % UCSecurable
    %
    % App API 2.0

    % Copyright 2026 The MathWorks, Inc.

    properties
        permission databricks.datastructures.apps.UCSecurablePermission { JSONMapper.fieldName(permission, "permission")}
        securableFullName string { JSONMapper.fieldName(securableFullName, "securable_full_name")}
        securableKind string { JSONMapper.fieldName(securableKind, "securable_kind")}
        securableType databricks.datastructures.apps.UCSecurableType { JSONMapper.fieldName(securableType, "securable_type")}
    end

    methods
        function obj = UCSecurable(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.apps.UCSecurable
            end
            obj@JSONMapper(s, inputs);
        end
    end
end
