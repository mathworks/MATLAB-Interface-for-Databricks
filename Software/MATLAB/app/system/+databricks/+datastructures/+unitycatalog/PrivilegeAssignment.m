classdef PrivilegeAssignment < JSONMapper
    % PrivilegeAssignment Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.PrivilegeAssignment Properties:
    %   principal - The username (email address) or group name
    %   privileges - List of privileges assigned to the principal

    % Copyright 2022-2024 The MathWorks, Inc.
    properties
        % The username (email address) or group name
        principal string
        % List of privileges assigned to the principal
        privileges string {JSONMapper.JSONArray}
    end

    methods
        function obj = PrivilegeAssignment(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.PrivilegeAssignment
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
                fields.?databricks.datastructures.unitycatalog.PrivilegeAssignment
            end
            obj = databricks.datastructures.unitycatalog.PrivilegeAssignment;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end