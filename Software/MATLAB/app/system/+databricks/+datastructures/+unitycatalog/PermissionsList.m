classdef PermissionsList < JSONMapper
    % PermissionsList Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.PermissionsList Properties:
    %   privilege_assignments - List of privileges assigned to the principal

    % Copyright 2022-2024 The MathWorks, Inc.
    properties
        % List of privileges assigned to the principal
        privilege_assignments databricks.datastructures.unitycatalog.PrivilegeAssignment {JSONMapper.JSONArray}
    end

    methods
        function obj = PermissionsList(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.PermissionsList
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
                fields.?databricks.datastructures.unitycatalog.PermissionsList
            end
            obj = databricks.datastructures.unitycatalog.PermissionsList;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end