classdef RecipientInfo < JSONMapper
    % RecipientInfo Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.RecipientInfo Properties:
    %   name - of Recipient relative to parent metastore
    %   authentication_type - The delta sharing authentication type. Can be "TOKEN" or
    %      "DATABRICKS"
    %   comment - User-supplied free-form text
    %   owner - Username/groupname of Recipient owner
    %   data_recipient_global_metastore_id - The global UC metastore id provided by the data recipient. This
    %      field is only present when the authentication type is DATABRICKS.
    %      The identifier is of format <cloud>:<region>:<metastore-uuid>.
    %   ip_access_list - IP Access List. This field is only applicable for the TOKEN
    %      authentication type.
    %   created_at - Date of Recipient creation
    %   created_by - Username of Recipient creator
    %   updated_at - Date of last update to Recipient
    %   updated_by - Username of user who last updated Recipient
    %   tokens - Recipient Tokens. This field is only present when the
    %      authentication type is TOKEN.
    %   cloud - vendor of the recipient's UC Metastore. This field is only
    %      present when the authentication type is DATABRICKS.
    %   region - Cloud region of the recipient's UC Metastore. This field is only
    %      present when the authentication type is DATABRICKS.
    %   metastore_id - UUID of the recipient's UC Metastore. This field is only present
    %      when the authentication type is DATABRICKS.

    % Copyright 2022-2024 The MathWorks, Inc.
    
    properties
        % Name of Recipient relative to parent metastore
        name string
        % The delta sharing authentication type. Can be "TOKEN" or
        % "DATABRICKS"
        authentication_type databricks.datastructures.unitycatalog.AuthenticationType
        % User-supplied free-form text
        comment string
        % Username/groupname of Recipient owner
        owner string
        % The global UC metastore id provided by the data recipient. This
        % field is only present when the authentication type is DATABRICKS.
        % The identifier is of format <cloud>:<region>:<metastore-uuid>.
        data_recipient_global_metastore_id string
        % IP Access List. This field is only applicable for the TOKEN
        % authentication type.
        ip_access_list databricks.datastructures.unitycatalog.IpAccessList {JSONMapper.JSONArray}
        % Date of Recipient creation
        created_at datetime {JSONMapper.epochDatetime(created_at, 'TicksPerSecond', 1000)}
        % Username of Recipient creator
        created_by string
        % Date of last update to Recipient
        updated_at datetime {JSONMapper.epochDatetime(updated_at, 'TicksPerSecond', 1000)}
        % Username of user who last updated Recipient
        updated_by string
        % Recipient Tokens. This field is only present when the
        % authentication type is TOKEN.
        tokens databricks.datastructures.unitycatalog.RecipientTokenInfo {JSONMapper.JSONArray}
        % Cloud vendor of the recipient's UC Metastore. This field is only
        % present when the authentication type is DATABRICKS.
        cloud string
        % Cloud region of the recipient's UC Metastore. This field is only
        % present when the authentication type is DATABRICKS.
        region string
        % UUID of the recipient's UC Metastore. This field is only present
        % when the authentication type is DATABRICKS.
        metastore_id string
    end

    methods
        function obj = RecipientInfo(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.RecipientInfo
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
                fields.?databricks.datastructures.unitycatalog.RecipientInfo
            end
            obj = databricks.datastructures.unitycatalog.RecipientInfo;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end