classdef RecipientProfile < JSONMapper
    % RecipientProfile Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.RecipientProfile Properties:
    %   share_credentials_version - This field is only present when the authentication type is TOKEN.
    %      The file format version of the profile file. This version will be
    %      increased whenever non-forward-compatible changes are made to the
    %      profile format. When a client is running an unsupported profile
    %      file format version, it should show an error message instructing
    %      the user to upgrade to a newer version of their client.
    %   endpoint - The url of the sharing server.

    % Copyright 2022-2024 The MathWorks, Inc.

    properties
        % This field is only present when the authentication type is TOKEN.
        % The file format version of the profile file. This version will be
        % increased whenever non-forward-compatible changes are made to the
        % profile format. When a client is running an unsupported profile
        % file format version, it should show an error message instructing
        % the user to upgrade to a newer version of their client.
        share_credentials_version int32
        % The url of the sharing server.
        endpoint string
    end

    methods
        function obj = RecipientProfile(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.RecipientProfile
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
                fields.?databricks.datastructures.unitycatalog.RecipientProfile
            end
            obj = databricks.datastructures.unitycatalog.RecipientProfile;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end