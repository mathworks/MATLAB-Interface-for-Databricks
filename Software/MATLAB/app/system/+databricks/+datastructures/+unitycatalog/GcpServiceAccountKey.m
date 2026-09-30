classdef GcpServiceAccountKey < JSONMapper
    % GcpServiceAccountKey Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.GcpServiceAccountKey Properties:
    %   email - The email of the service account
    %   private_key_id - The ID of the service account's private key
    %   private_key - The service account's RSA private key. This field is redacted
    %      on output.

    % Copyright 2022-2024 The MathWorks, Inc.

    properties
        % The email of the service account
        email string
        % The ID of the service account's private key
        private_key_id string
        % The service account's RSA private key. This field is redacted
        % on output.
        private_key string
    end

    methods
        function obj = GcpServiceAccountKey(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.GcpServiceAccountKey
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
                fields.?databricks.datastructures.unitycatalog.GcpServiceAccountKey
            end
            obj = databricks.datastructures.unitycatalog.GcpServiceAccountKey;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end