classdef PartitionValues < JSONMapper
    % PartitionValues Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.PartitionValues Properties:
    %   name - The name of the partition column. Must be distinct within a
    %      single partition
    %   value - The value of the partition column. When this value is not set, it
    %      means `null` value.
    %   op - The operator to apply for the value. Can be "EQUAL" or "LIKE".

    % Copyright 2022-2024 The MathWorks, Inc.
    properties
        % The name of the partition column. Must be distinct within a
        % single partition
        name string
        % The value of the partition column. When this value is not set, it
        % means `null` value.
        value string
        % The operator to apply for the value. Can be "EQUAL" or "LIKE".
        op string
    end

    methods
        function obj = PartitionValues(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.PartitionValues
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
                fields.?databricks.datastructures.unitycatalog.PartitionValues
            end
            obj = databricks.datastructures.unitycatalog.PartitionValues;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end