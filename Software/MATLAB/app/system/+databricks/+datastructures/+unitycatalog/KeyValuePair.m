classdef KeyValuePair < JSONMapper
    % KeyValuePair Databricks Unity Catalog KeyValuePair Data Structure
    %
    % databricks.datastructures.unitycatalog.KeyValuePair Properties:
    %   key - Tag key name.
    %   value - Tag key value.

    % Copyright 2022-2024 The MathWorks, Inc.

    properties
        % Tag key name.
        key string
        % Tag key value.
        value string
    end

    methods
        function obj = KeyValuePair(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.KeyValuePair
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
                fields.?databricks.datastructures.unitycatalog.KeyValuePair
            end
            obj = databricks.datastructures.unitycatalog.KeyValuePair;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end