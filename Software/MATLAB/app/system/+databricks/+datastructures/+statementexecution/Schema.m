classdef Schema < JSONMapper
    % SCHEMA

    % Copyright 2026, The MathWorks Inc.

    properties
        columnCount int32 {JSONMapper.fieldName(columnCount,"column_count")}
        columns databricks.datastructures.statementexecution.Column {JSONMapper.JSONArray}
    end
    
    methods
        function obj = Schema(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.statementexecution.Schema
            end
            obj@JSONMapper(s, inputs);
        end
    end
end
