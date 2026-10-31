classdef StorageCredentialInfo < JSONMapper
    % StorageCredentialInfo Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.StorageCredentialInfo Properties:
    %   name - of Storage Credential (must be unique within the parent
    %      Metastore)
    %   comment - User-supplied free-form text
    %   owner - Username/groupname of Storage Credential owner
    %   skip_validation - Specifies whether a Storage Credential with the specified
    %      configuration should be tested (for access to cloud storage)
    %      before the object is created/updated. Default: false
    %   aws_iam_role - Credential details for AWS
    %   azure_service_principal - Credential details for Azure
    %   gcp_service_account_key - Credential details for GCP
    %   id - Output-only
    %      Unique identifier of the Storage Credential
    %   metastore_id - Unique identifier of the parent Metastore
    %   created_at - Date of Storage Credential creation
    %   created_by - Username of Storage Credential creator
    %   updated_at - Date of last update to Storage Credential
    %   updated_by - Username of user who last updated Storage Credential

    % Copyright 2022-2024 The MathWorks, Inc.

    properties
        % Name of Storage Credential (must be unique within the parent
        % Metastore)
        name string
        % User-supplied free-form text
        comment string
        % Username/groupname of Storage Credential owner
        owner string
        % Specifies whether a Storage Credential with the specified
        % configuration should be tested (for access to cloud storage)
        % before the object is created/updated. Default: false
        skip_validation logical
        
        % Credential details for AWS
        aws_iam_role databricks.datastructures.unitycatalog.AwsIamRole
        % Credential details for Azure
        azure_service_principal databricks.datastructures.unitycatalog.AzureServicePrincipal
        % Credential details for GCP
        gcp_service_account_key databricks.datastructures.unitycatalog.GcpServiceAccountKey

        
        % Output-only
        % Unique identifier of the Storage Credential
        id string
        % Unique identifier of the parent Metastore
        metastore_id string
        % Date of Storage Credential creation
        created_at datetime {JSONMapper.epochDatetime(created_at, 'TicksPerSecond', 1000)}
        % Username of Storage Credential creator
        created_by string
        % Date of last update to Storage Credential
        updated_at datetime {JSONMapper.epochDatetime(updated_at, 'TicksPerSecond', 1000)}
        % Username of user who last updated Storage Credential
        updated_by string
    end

    methods
        function obj = StorageCredentialInfo(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.StorageCredentialInfo
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
                fields.?databricks.datastructures.unitycatalog.StorageCredentialInfo
            end
            obj = databricks.datastructures.unitycatalog.StorageCredentialInfo;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end  
end