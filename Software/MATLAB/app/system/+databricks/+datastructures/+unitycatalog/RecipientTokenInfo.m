classdef RecipientTokenInfo < JSONMapper
    % RecipientTokenInfo Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.RecipientTokenInfo Properties:
    %   id - Unique id of the Recipient Token.
    %   activation_url - Full activation url to retrieve the access token. It will be
    %      empty if the token is already retrieved.
    %   expiration_time - Expiration timestamp of the token in epoch milliseconds.
    %   created_at - Date of Recipient Token creation
    %   created_by - Username of Recipient Token creator
    %   updated_at - Date of last update to Recipient Token
    %   updated_by - Username of user who last updated Recipient Token

    % Copyright 2022-2024 The MathWorks, Inc.
    
    properties
        % Unique id of the Recipient Token.
        id string
        % Full activation url to retrieve the access token. It will be
        % empty if the token is already retrieved.
        activation_url string
        % Expiration timestamp of the token in epoch milliseconds.
        expiration_time datetime {JSONMapper.epochDatetime(expiration_time, 'TicksPerSecond', 1000)}
        % Date of Recipient Token creation
        created_at datetime {JSONMapper.epochDatetime(created_at, 'TicksPerSecond', 1000)}
        % Username of Recipient Token creator
        created_by string
        % Date of last update to Recipient Token
        updated_at datetime {JSONMapper.epochDatetime(updated_at, 'TicksPerSecond', 1000)}
        % Username of user who last updated Recipient Token
        updated_by string
    end

    methods
        function obj = RecipientTokenInfo(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.RecipientTokenInfo
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
                fields.?databricks.datastructures.unitycatalog.RecipientTokenInfo
            end
            obj = databricks.datastructures.unitycatalog.RecipientTokenInfo;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end