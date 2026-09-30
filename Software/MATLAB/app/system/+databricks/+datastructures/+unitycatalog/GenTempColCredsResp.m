classdef GenTempColCredsResp < JSONMapper
    % AzureUserDelegationSAS Databricks Data Structure
    %
    % Properties:
    %   aws_temp_credentials - AWS temporary credentials for API authentication
    %
    %   aad_token - Azure Active Directory token, essentially the Oauth token for
    %               Azure Service Principal or Managed Identity. Read more at
    %               https://learn.microsoft.com/en-us/azure/databricks/dev-tools/api/latest/aad/service-prin-aad-token
    %
    %   azure_user_delegation_sas - Azure temporary credentials for API authentication
    %
    %   expiry_time - Server time when the credential will expire, in epoch milliseconds
    %
    %   r2_temp_credentials - R2 temporary credentials for API authentication
    %
    %   url - The URL of the storage path accessible by the temporary credential
    
    % Copyright 2026 The MathWorks, Inc.

    properties
        aws_temp_credentials databricks.datastructures.unitycatalog.AwsTempCredentials
        azure_add databricks.datastructures.unitycatalog.AzureADD
        azure_user_delegation_sas databricks.datastructures.unitycatalog.AzureUserDelegationSAS
        expiry_time datetime { JSONMapper.epochDatetime(expiry_time,'TicksPerSecond',1000)}
        r2_temp_credentials databricks.datastructures.unitycatalog.R2TempCredentials
        url string
    end

    methods
        function obj = GenTempColCredsResp(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.GenTempColCredsResp
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
                fields.?databricks.datastructures.unitycatalog.GenTempColCredsResp
            end
            obj = databricks.datastructures.unitycatalog.GenTempColCredsResp;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end