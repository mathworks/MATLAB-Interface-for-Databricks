classdef PartitionSpecification < JSONMapper
    % PartitionSpecification Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.PartitionSpecification Properties:
    %   partitions - have OR logical relationship

    % Copyright 2022-2024 The MathWorks, Inc.
    properties
        % Partitions have OR logical relationship
        partitions databricks.datastructures.unitycatalog.Partition {JSONMapper.JSONArray}
    end

    methods
        function obj = PartitionSpecification(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.PartitionSpecification
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
                fields.?databricks.datastructures.unitycatalog.PartitionSpecification
            end
            obj = databricks.datastructures.unitycatalog.PartitionSpecification;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end