classdef Partition < JSONMapper
    % Partition Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.Partition Properties:
    %   values - Partition Values have AND logical relationship

    % Copyright 2022-2024 The MathWorks, Inc.
    properties
        % Partition Values have AND logical relationship
        values databricks.datastructures.unitycatalog.PartitionValues {JSONMapper.JSONArray}
    end

    methods
        function obj = Partition(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.Partition
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
                fields.?databricks.datastructures.unitycatalog.Partition
            end
            obj = databricks.datastructures.unitycatalog.Partition;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end