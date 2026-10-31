classdef MetastoreAssignment < JSONMapper
    % MetastoreAssignment Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.MetastoreAssignment Properties:
    %   metastore_id - Unique identifier for metastore
    %   default_catalog_name - Default catalog used for this assignment

    % Copyright 2022-2024 The MathWorks, Inc.
    properties
        % Unique identifier for metastore
        metastore_id string
        % Default catalog used for this assignment
        default_catalog_name string
    end

    methods
        function obj = MetastoreAssignment(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.MetastoreAssignment
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
                fields.?databricks.datastructures.unitycatalog.MetastoreAssignment
            end
            obj = databricks.datastructures.unitycatalog.MetastoreAssignment;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end