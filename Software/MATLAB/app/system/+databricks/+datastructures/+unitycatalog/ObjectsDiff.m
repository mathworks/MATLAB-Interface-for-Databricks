classdef ObjectsDiff < JSONMapper
    % ObjectsDiff Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.ObjectsDiff Properties:
    %   name - Name of the principal
    %   updates - List of privileges assigned to add to the principal

    % Copyright 2022-2024 The MathWorks, Inc.
    properties
        % Name of the principal
        name string
        % List of privileges assigned to add to the principal
        updates databricks.datastructures.unitycatalog.ObjectsChange {JSONMapper.JSONArray}
    end

    methods
        function obj = ObjectsDiff(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.ObjectsDiff
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
                fields.?databricks.datastructures.unitycatalog.ObjectsDiff
            end
            obj = databricks.datastructures.unitycatalog.ObjectsDiff;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end