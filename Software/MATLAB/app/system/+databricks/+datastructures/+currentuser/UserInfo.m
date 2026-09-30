classdef UserInfo < JSONMapper
    % USERINFO Class to represent info associated with the user

    % Copyright 2025 The MathWorks, Inc.

    properties
        % If this user is active.
        active logical { JSONMapper.fieldName(active, "active") }
        % String that represents a concatenation of given and family names. For example John Smith. 
        displayName string { JSONMapper.fieldName(displayName, "displayName") }
        % All the emails associated with the Databricks user.
        emails databricks.datastructures.currentuser.Email { JSONMapper.JSONArray, JSONMapper.fieldName(emails,"emails")}
        % Entitlements assigned to the user.
        entitlements databricks.datastructures.currentuser.Entitlement { JSONMapper.JSONArray, JSONMapper.fieldName(entitlements,"entitlements")}
        % External ID is not currently supported. It is reserved for future use.
        externalId string { JSONMapper.fieldName(externalId,"externalId")}
        % groups User group info
        groups databricks.datastructures.currentuser.Group { JSONMapper.JSONArray, JSONMapper.fieldName(groups,"groups")}
        % Databricks user id
        id string { JSONMapper.fieldName(id,"id")}
        % String that represents a concatenation of given and family names. For example `John Smith`.
        name databricks.datastructures.currentuser.Name { JSONMapper.fieldName(name,"name")}
        % Corresponds to vendor instance profile/arn role.
        roles databricks.datastructures.currentuser.Role { JSONMapper.JSONArray, JSONMapper.fieldName(roles,"roles")}
        % The schema of the user.
        schemas string { JSONMapper.JSONArray, JSONMapper.fieldName(schemas,"schemas")}
        % Email address of the Databricks user.
        userName string { JSONMapper.fieldName(userName,"userName")}
    end

    methods
        function obj = UserInfo(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.currentuser.UserInfo
            end
            obj@JSONMapper(s, inputs);
        end
    end
end