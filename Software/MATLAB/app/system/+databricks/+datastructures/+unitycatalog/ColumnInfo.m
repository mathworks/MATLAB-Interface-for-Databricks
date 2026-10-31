classdef ColumnInfo < JSONMapper
    % ColumnInfo Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.ColumnInfo Properties:
    %   name - User-visible name of column
    %   type_name - Name of (outer) type; see Column Type  Name above
    %   type_text - Column type spec (with metadata) as SQL text
    %   type_json - Column type spec (with metadata) as JSON string
    %   type_precision - Digits of precision; applies to DECIMAL columns
    %   type_scale - Digits to right of decimal; applies to DECIMAL columns
    %   type_interval_type - Format of INTERVAL columns
    %   position - Ordinal position of column, starting at 0.
    %   comment - User-supplied free-form text
    %   nullable - Whether field is nullable (Default: true)
    %   partition_index - Partition ID

    % Copyright 2022-2024 The MathWorks, Inc.

    properties
        % User-visible name of column
        name string
        % Name of (outer) type; see Column Type  Name above
        type_name databricks.datastructures.unitycatalog.ColumnTypeName
        % Column type spec (with metadata) as SQL text
        type_text string
        % Column type spec (with metadata) as JSON string
        type_json string
        % Digits of precision; applies to DECIMAL columns
        type_precision int32
        % Digits to right of decimal; applies to DECIMAL columns
        type_scale int32
        % Format of INTERVAL columns
        type_interval_type string
        % Ordinal position of column, starting at 0.
        position int32
        % User-supplied free-form text
        comment string
        % Whether field is nullable (Default: true)
        nullable logical
        % Partition ID
        partition_index int16
    end

    methods
        function obj = ColumnInfo(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.ColumnInfo
            end
            obj@JSONMapper(s, inputs);
        end
    end

    methods (Static)
        function obj = fromInputs(fields)
            % FROMINPUTS creates an instance of the class with specific
            % properties set to specific values. For each property that is
            % to be set, provide the property name and desired value as 
            % Name-Value pairs.
            arguments
                fields.?databricks.datastructures.unitycatalog.ColumnInfo
            end
            obj = databricks.datastructures.unitycatalog.ColumnInfo;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end