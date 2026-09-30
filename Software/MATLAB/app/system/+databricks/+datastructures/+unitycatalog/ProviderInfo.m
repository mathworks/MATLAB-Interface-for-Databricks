classdef ProviderInfo < JSONMapper
    % ProviderInfo Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.ProviderInfo Properties:
    %   name - of Provider relative to parent metastore
    %   authentication_type - The delta sharing authentication type. Can be "TOKEN" or
    %      "DATABRICKS"
    %   comment - User-supplied free-form text
    %   owner - Username/groupname of Provider owner
    %   recipient_profile_str - Applicable for "TOKEN" authentication type only. This is the
    %      string with the profile file given to the recipient. See
    %      https://github.com/delta-io/delta-sharing/blob/main/PROTOCOL.md#profile-file-format
    %      In output mode, the bearer token is redacted.
    %   created_at - Date of Provider creation
    %   created_by - Username of Provider creator
    %   updated_at - Date of last update to Provider
    %   updated_by - Username of user who last updated Provider
    %   recipient_profile - The recipient profile. This field is only present when the
    %      authentication type is TOKEN. See
    %      https://github.com/delta-io/delta-sharing/blob/main/PROTOCOL.md#profile-file-format
    %   cloud - vendor of the provider's UC Metastore. This field is only
    %      present when the authentication type is DATABRICKS.
    %   region - Cloud region of the provider's UC Metastore. This field is only
    %      present when the authentication type is DATABRICKS.
    %   metastore_id - UUID of the provider's UC Metastore. This field is only present
    %      when the authentication type is DATABRICKS.

    % Copyright 2022-2024 The MathWorks, Inc.
    
    properties
        % Name of Provider relative to parent metastore
        name string
        % The delta sharing authentication type. Can be "TOKEN" or
        % "DATABRICKS"
        authentication_type databricks.datastructures.unitycatalog.AuthenticationType
        % User-supplied free-form text
        comment string
        % Username/groupname of Provider owner
        owner string
        % Applicable for "TOKEN" authentication type only. This is the
        % string with the profile file given to the recipient. See
        % https://github.com/delta-io/delta-sharing/blob/main/PROTOCOL.md#profile-file-format
        % In output mode, the bearer token is redacted.
        recipient_profile_str string
        % Date of Provider creation
        created_at datetime {JSONMapper.epochDatetime(created_at, 'TicksPerSecond', 1000)}
        % Username of Provider creator
        created_by string
        % Date of last update to Provider
        updated_at datetime {JSONMapper.epochDatetime(updated_at, 'TicksPerSecond', 1000)}
        % Username of user who last updated Provider
        updated_by string
        % The recipient profile. This field is only present when the
        % authentication type is TOKEN. See
        % https://github.com/delta-io/delta-sharing/blob/main/PROTOCOL.md#profile-file-format
        recipient_profile databricks.datastructures.unitycatalog.RecipientProfile
        % Cloud vendor of the provider's UC Metastore. This field is only
        % present when the authentication type is DATABRICKS.
        cloud string
        % Cloud region of the provider's UC Metastore. This field is only
        % present when the authentication type is DATABRICKS.
        region string
        % UUID of the provider's UC Metastore. This field is only present
        % when the authentication type is DATABRICKS.
        metastore_id string
    end

    methods
        function obj = ProviderInfo(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.ProviderInfo
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
                fields.?databricks.datastructures.unitycatalog.ProviderInfo
            end
            obj = databricks.datastructures.unitycatalog.ProviderInfo;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end