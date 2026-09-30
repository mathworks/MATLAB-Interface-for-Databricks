classdef ProviderShare < JSONMapper
    % ProviderShare Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.ProviderShare Properties:
    %   name - The name of the Provider Share.

    % Copyright 2022-2024 The MathWorks, Inc.
    properties
        % The name of the Provider Share.
        name string 
    end

    methods
        function obj = ProviderShare(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.ProviderShare
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
                fields.?databricks.datastructures.unitycatalog.ProviderShare
            end
            obj = databricks.datastructures.unitycatalog.ProviderShare;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end