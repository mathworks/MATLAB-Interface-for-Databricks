classdef AwsTempCredentials < JSONMapper
    % AwsTempCredentials Databricks Data Structure
    %
    % Properties:
    %       access_key_id - The access key ID that identifies the temporary credentials.
    %        access_point - The Amazon Resource Name (ARN) of the S3 access point for temporary credentials related the external location.
    %   secret_access_key - The secret access key that can be used to sign AWS API requests.
    %       session_token - The token that users must pass to AWS API to use the temporary credentials.
    
    % Copyright 2026 The MathWorks, Inc.

    properties
        % The access key ID that identifies the temporary credentials.
        access_key_id string
        % The Amazon Resource Name (ARN) of the S3 access point for temporary credentials related the external location.
        access_point string
        % The secret access key that can be used to sign AWS API requests.
        secret_access_key string
        % The token that users must pass to AWS API to use the temporary credentials.
        session_token string
    end

    methods
        function obj = AwsTempCredentials(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.AwsTempCredentials
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
                fields.?databricks.datastructures.unitycatalog.AwsTempCredentials
            end
            obj = databricks.datastructures.unitycatalog.AwsTempCredentials;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end