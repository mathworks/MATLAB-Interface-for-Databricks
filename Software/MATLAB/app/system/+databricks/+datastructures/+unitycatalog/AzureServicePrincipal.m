classdef AzureServicePrincipal < JSONMapper
    % AzureServicePrincipal Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.AzureServicePrincipal Properties:
    %   directory_id - The directory ID corresponding to the Azure Active Directory
    %      (AAD) tenant of the application
    %   application_id - The application ID of the application registration within the
    %      referenced AAD tenant
    %   client_secret - The client secret generated for the above app ID in AAD. This
    %      field is redacted on output.

    % Copyright 2022-2024 The MathWorks, Inc.

    properties
        % The directory ID corresponding to the Azure Active Directory
        % (AAD) tenant of the application
        directory_id string
        % The application ID of the application registration within the
        % referenced AAD tenant
        application_id string
        % The client secret generated for the above app ID in AAD. This
        % field is redacted on output.
        client_secret string
    end

    methods
        function obj = AzureServicePrincipal(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.AzureServicePrincipal
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
                fields.?databricks.datastructures.unitycatalog.AzureServicePrincipal
            end
            obj = databricks.datastructures.unitycatalog.AzureServicePrincipal;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end