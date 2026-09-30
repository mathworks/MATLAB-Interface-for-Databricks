classdef ShareToPrivilegeAssignment < JSONMapper
    % ShareToPrivilegeAssignment Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.ShareToPrivilegeAssignment Properties:
    %   share_name - The share name.
    %   privilege_assignments - The privileges assigned to the principal.

    % Copyright 2022-2024 The MathWorks, Inc.
    
    properties
        % The share name.
        share_name string
        % The privileges assigned to the principal.
        privilege_assignments databricks.datastructures.unitycatalog.PrivilegeAssignment {JSONMapper.JSONArray}
    end

    methods
        function obj = ShareToPrivilegeAssignment(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.ShareToPrivilegeAssignment
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
                fields.?databricks.datastructures.unitycatalog.ShareToPrivilegeAssignment
            end
            obj = databricks.datastructures.unitycatalog.ShareToPrivilegeAssignment;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end      
end