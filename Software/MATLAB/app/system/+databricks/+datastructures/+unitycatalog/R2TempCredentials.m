classdef R2TempCredentials < JSONMapper
    % R2TempCredentials R2 temporary credentials for API authentication
    %  See also: https://developers.cloudflare.com/r2/api/s3/tokens/.
    %
    % Properties:
    %       access_key_id - The access key ID that identifies the temporary credentials.
    %   secret_access_key - The secret access key associated with the access key.
    %       session_token - The generated JWT that users must pass to use the temporary credentials.
    
    % Copyright 2026 The MathWorks, Inc.

    properties
        % The access key ID that identifies the temporary credentials.
        access_key_id string
        % The secret access key associated with the access key.
        secret_access_key string
        % The generated JWT that users must pass to use the temporary credentials.
        session_token string
    end

    methods
        function obj = R2TempCredentials(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.R2TempCredentials
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
                fields.?databricks.datastructures.unitycatalog.R2TempCredentials
            end
            obj = databricks.datastructures.unitycatalog.R2TempCredentials;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end