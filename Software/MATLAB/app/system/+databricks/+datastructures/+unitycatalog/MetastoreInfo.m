classdef MetastoreInfo < JSONMapper
    % MetastoreInfo Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.MetastoreInfo Properties:
    %   name - of metastore
    %   storage_root - Metastore storage root path. On creation, the new metastore’s ID
    %      (UUID) is appended to the provided storage_root, so the output
    %      storage_root is not the same as the input storage_root.
    %   default_data_access_config_id - DEPRECATED Not implemented
    %   storage_root_credential_id - Unique identifier of the Storage Credential used by default to access
    %      the storage_root area of cloud storage.
    %   owner - Username/groupname of Metastore owner
    %   delta_sharing_enabled - DEPRECATED Not implemented
    %   delta_sharing_scope - Delta Sharing Scope (default: INTERNAL)
    %   delta_sharing_recipient_token_lifetime_in_seconds - The lifetime of delta sharing recipient token in seconds
    %      (no default; must be specified when delta_sharing_scope is set
    %      to INTERNAL_AND_EXTERNAL).
    %   delta_sharing_organization_name - The organization name of a Delta Sharing entity. The name will be
    %      used in Databricks-to-Databricks Delta Sharing as the official name.
    %   privilege_model_version - Privilege model version. This is of the form major.minor.
    %   metastore_id - Unique identifier for metastore
    %   cloud - vendor of Metastore home shard, e.g. “aws”, “azure”
    %   region - Cloud region of the Metastore home shard, e.g. “us-west-2”, “westus”
    %   global_metastore_id - Globally unique metastore ID across clouds and regions.
    %      E.g., “aws:us-east-1:8dd1e334-c7df-44c9-a359-f86f9aae8919”
    %   created_at - Date of metastore creation
    %   created_by - Username of metastore creator
    %   updated_at - Date of last update to metastore
    %   updated_by - Username of user who last modified metastore
   

    % Copyright 2022-2024 The MathWorks, Inc.
    
    properties
        % Name of metastore
        name string
        % Metastore storage root path. On creation, the new metastore’s ID
        % (UUID) is appended to the provided storage_root, so the output
        % storage_root is not the same as the input storage_root. 
        storage_root string
        % default_data_access_config_id DEPRECATED Not implemented
        default_data_access_config_id string
        % Unique identifier of the Storage Credential used by default to access
        % the storage_root area of cloud storage.
        storage_root_credential_id string
        % Username/groupname of Metastore owner
        owner string
        % delta_sharing_enabled DEPRECATED Not implemented
        delta_sharing_enabled logical 
        % Delta Sharing Scope (default: INTERNAL)
        delta_sharing_scope databricks.datastructures.unitycatalog.DeltaSharingScope
        % The lifetime of delta sharing recipient token in seconds
        % (no default; must be specified when delta_sharing_scope is set
        % to INTERNAL_AND_EXTERNAL).
        delta_sharing_recipient_token_lifetime_in_seconds int32
        % The organization name of a Delta Sharing entity. The name will be
        % used in Databricks-to-Databricks Delta Sharing as the official name.
        delta_sharing_organization_name string
        % Privilege model version. This is of the form major.minor.
        privilege_model_version string
        
        % Output-only properties
        
        % Unique identifier for metastore
        metastore_id string
        % Cloud vendor of Metastore home shard, e.g. “aws”, “azure”
        cloud string
        % Cloud region of the Metastore home shard, e.g. “us-west-2”, “westus”
        region string
        % Globally unique metastore ID across clouds and regions.
        % E.g., “aws:us-east-1:8dd1e334-c7df-44c9-a359-f86f9aae8919”
        global_metastore_id string
        % Date of metastore creation
        created_at datetime {JSONMapper.epochDatetime(created_at, 'TicksPerSecond', 1000)}
        % Username of metastore creator
        created_by string
        % Date of last update to metastore
        updated_at datetime {JSONMapper.epochDatetime(updated_at, 'TicksPerSecond', 1000)}
        % Username of user who last modified metastore
        updated_by string
    end

    methods
        function obj = MetastoreInfo(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.MetastoreInfo
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
                fields.?databricks.datastructures.unitycatalog.MetastoreInfo
            end
            obj = databricks.datastructures.unitycatalog.MetastoreInfo;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end