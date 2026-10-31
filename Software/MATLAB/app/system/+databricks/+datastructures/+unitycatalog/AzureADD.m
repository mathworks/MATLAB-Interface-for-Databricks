classdef AzureADD < JSONMapper
    % AzureADD Databricks Data Structure
    %
    % Properties:
    %   aad_token - Azure Active Directory token, essentially the Oauth token for
    %               Azure Service Principal or Managed Identity. Read more at
    %               https://learn.microsoft.com/en-us/azure/databricks/dev-tools/api/latest/aad/service-prin-aad-token
    
    % Copyright 2026 The MathWorks, Inc.

    properties
        % Opaque token that contains claims that you can use in Azure Active Directory to access cloud services.
        aad_token string
    end

    methods
        function obj = AzureADD(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.AzureADD
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
                fields.?databricks.datastructures.unitycatalog.AzureADD
            end
            obj = databricks.datastructures.unitycatalog.AzureADD;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end