classdef PermissionsDiff < JSONMapper
    % PermissionsDiff Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.PermissionsDiff Properties:
    %   changes - List of changes to make to a securable’s permissions

    % Copyright 2022-2024 The MathWorks, Inc.
    properties
        % List of changes to make to a securable’s permissions
        changes databricks.datastructures.unitycatalog.PermissionsChange {JSONMapper.JSONArray}
    end

    methods
        function obj = PermissionsDiff(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.PermissionsDiff
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
                fields.?databricks.datastructures.unitycatalog.PermissionsDiff
            end
            obj = databricks.datastructures.unitycatalog.PermissionsDiff;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end