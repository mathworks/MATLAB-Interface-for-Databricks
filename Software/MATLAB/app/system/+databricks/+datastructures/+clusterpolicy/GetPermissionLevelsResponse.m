classdef GetPermissionLevelsResponse < JSONMapper
    % GETPERMISSIONLEVELSRESPONSE Gets the permission levels that a user can have on an object response
    %
    % Properties
    %   permissionLevels: Specific permission levels

    % See: https://docs.databricks.com/api/workspace/clusterpolicies/getpermissionlevels#permission_levels-permission_level

    % Copyright 2024 The MathWorks, Inc.

    properties
        % Canonical unique identifier for the Cluster Policy
        permissionLevels databricks.datastructures.clusterpolicy.PermissionLevel { JSONMapper.fieldName(permissionLevels, "permission_levels"), JSONMapper.JSONArray }
    end

    methods
        function obj = GetPermissionLevelsResponse(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.clusterpolicy.GetPermissionLevelsResponse
            end
            obj@JSONMapper(s, inputs);
        end
    end
end
