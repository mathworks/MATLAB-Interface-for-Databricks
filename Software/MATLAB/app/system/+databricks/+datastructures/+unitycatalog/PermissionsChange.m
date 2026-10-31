classdef PermissionsChange < JSONMapper
    % PermissionsChange Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.PermissionsChange Properties:
    %   principal - The username (email address) or group name
    %   add - List of privileges assigned to add to the principal
    %   remove - List of privileges assigned to remove from the principal

    % Copyright 2022-2024 The MathWorks, Inc.
    properties
        % The username (email address) or group name
        principal string
        % List of privileges assigned to add to the principal
        add string {JSONMapper.JSONArray}
        % List of privileges assigned to remove from the principal
        remove string {JSONMapper.JSONArray}
    end

    methods
        function obj = PermissionsChange(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.PermissionsChange
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
                fields.?databricks.datastructures.unitycatalog.PermissionsChange
            end
            obj = databricks.datastructures.unitycatalog.PermissionsChange;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end