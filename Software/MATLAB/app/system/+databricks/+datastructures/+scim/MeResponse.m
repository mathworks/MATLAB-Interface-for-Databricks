classdef MeResponse < JSONMapper
    % EMAILS SCIM user groups

    % Copyright 2024 The MathWorks, Inc.

    properties
        schemas string {JSONMapper.JSONArray}
        id string
        userName string
        emails databricks.datastructures.scim.emails {JSONMapper.JSONArray}
        name databricks.datastructures.scim.name
        displayName string
        groups databricks.datastructures.scim.groups {JSONMapper.JSONArray}
        roles databricks.datastructures.scim.roles {JSONMapper.JSONArray}
        entitlements databricks.datastructures.scim.entitlements {JSONMapper.JSONArray}
        externalId string
        active (1,1) logical
    end

    methods
        function obj = MeResponse(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.scim.MeResponse
            end
            obj@JSONMapper(s, inputs);
        end
    end
end