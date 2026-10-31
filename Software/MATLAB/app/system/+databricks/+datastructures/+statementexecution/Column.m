classdef Column < JSONMapper
    % Column Column type information
    %
    % Column Properties:
    %   name - Name of Column.
    %   typeText - Full data type spec, SQL/catalogString text.
    %   typeName - The name of the base data type. This doesn't include details for complex types such as STRUCT, MAP or ARRAY.
    %   position - Ordinal position of column (starting at position 0).
    %   typePrecision - Specifies the number of digits in a number. This applies to the DECIMAL type.
    %   typeScale - Digits to right of decimal.
    %   typeIntervalType - Format of interval type.
    %
    % See also: https://docs.databricks.com/api/statement-execution/v1/execute-statement

    % Copyright 2023-2026, The MathWorks Inc.

    properties
        % Name of Column.
        name string
        % type_text - Full data type spec, SQL/catalogString text.
        typeText string {JSONMapper.fieldName(typeText,"type_text")}
        % type_name - The name of the base data type. This doesn't include details for complex types such as STRUCT, MAP or ARRAY.
        typeName databricks.datastructures.statementexecution.ColumnInfoType {JSONMapper.fieldName(typeName,"type_name")}
        % position - Ordinal position of column (starting at position 0).
        position int32
        % typePrecision - Specifies the number of digits in a number. This applies to the DECIMAL type.
        typePrecision int32 {JSONMapper.fieldName(typePrecision,"type_precision")}
        % typeScale - Specifies the number of digits to the right of the decimal point in a number. This applies to the DECIMAL type.
        typeScale int32 {JSONMapper.fieldName(typeScale,"type_scale")}
        % typeIntervalType - Format of interval type.
        typeIntervalType string {JSONMapper.fieldName(typeIntervalType,"type_interval_type")}
    end

    methods
        function obj = Column(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the initialize method from their constructor. This
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { JSONMapper.ConstructorArgument } = []
                inputs.?databricks.datastructures.statementexecution.Column
            end
            obj = obj.initialize(s,inputs);
        end
    end
end
