classdef Schema < JSONMapper
    % SCHEMA

    % Copyright 2025 The MathWorks, Inc.

    properties
        columnCount int32 { JSONMapper.fieldName(columnCount, "column_count") }
        columns databricks.datastructures.genie.Column { JSONMapper.fieldName(columns, "columns"), JSONMapper.JSONArray}
    end

    methods
        function obj = Schema(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.genie.Schema
            end
            obj@JSONMapper(s, inputs);
        end
    end
end
