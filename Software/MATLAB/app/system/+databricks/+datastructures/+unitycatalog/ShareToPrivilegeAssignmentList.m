classdef ShareToPrivilegeAssignmentList < JSONMapper
    % ShareToPrivilegeAssignmentList Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.ShareToPrivilegeAssignmentList Properties:
    %   permissions_out - List of permissions

    % Copyright 2022-2024 The MathWorks, Inc.

    properties
        % List of permissions
        permissions_out databricks.datastructures.unitycatalog.ShareToPrivilegeAssignment
    end

    methods
        function obj = ShareToPrivilegeAssignmentList(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.ShareToPrivilegeAssignmentList
            end
            obj@JSONMapper(s, inputs);
        end
    end
end