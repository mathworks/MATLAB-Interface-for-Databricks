classdef Column < JSONMapper
    % COLUMN

    % Copyright 2025 The MathWorks, Inc.

    properties
        % The name of the column.
        name string { JSONMapper.fieldName(name, "name")}
        % The ordinal position of the column (starting at position 0).
        position int32 { JSONMapper.fieldName(position, "position") }
        % The format of the interval type.
        typeIntervalType string { JSONMapper.fieldName(typeIntervalType, "type_interval_type") }
        % The name of the base data type. This doesn't include details for complex types such as STRUCT, MAP or ARRAY.
        typeName databricks.datastructures.genie.TypeName { JSONMapper.fieldName(typeName, "type_name") }
        % Specifies the number of digits in a number. This applies to the DECIMAL type.
        typePrecision int32 { JSONMapper.fieldName(typePrecision, "type_precision") }
        % Specifies the number of digits to the right of the decimal point in a number. This applies to the DECIMAL type.
        typeScale int64 { JSONMapper.fieldName(typeScale, "type_scale") }
        % The full SQL type specification.
        typeText string { JSONMapper.fieldName(typeText, "type_text") }
    end

    methods
        function obj = Column(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.genie.Column
            end
            obj@JSONMapper(s, inputs);
        end
    end
end