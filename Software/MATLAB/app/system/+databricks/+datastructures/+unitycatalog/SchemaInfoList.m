classdef SchemaInfoList < JSONMapper
    % SCHEMAINFOLIST Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.SchemaInfoList Properties:
    %   schemas - list of schemas

    % Copyright 2022-2024 The MathWorks, Inc.

    properties
        % List of schemas
        schemas databricks.datastructures.unitycatalog.SchemaInfo
    end

    methods
        function obj = SchemaInfoList(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.SchemaInfoList
            end
            obj@JSONMapper(s, inputs);
        end
    end
end