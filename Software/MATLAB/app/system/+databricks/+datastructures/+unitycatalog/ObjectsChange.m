classdef ObjectsChange < JSONMapper
    % ObjectsChange Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.ObjectsChange Properties:
    %   action - ADD or REMOVE
    %   data_object - List of privileges assigned to add to the principal

    % Copyright 2022-2024 The MathWorks, Inc.
    properties
        action databricks.datastructures.unitycatalog.UpdateAction
        % List of privileges assigned to add to the principal
        data_object databricks.datastructures.unitycatalog.ShareDataObject
    end

    methods
        function obj = ObjectsChange(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.ObjectsChange
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
                fields.?databricks.datastructures.unitycatalog.ObjectsChange
            end
            obj = databricks.datastructures.unitycatalog.ObjectsChange;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end