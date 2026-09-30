classdef ExternalLocationInfo < JSONMapper
    % ExternalLocationInfo Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.ExternalLocationInfo Properties:
    %   name - of External Location (must be unique within the parent
    %      Metastore)
    %   comment - User-supplied free-form text
    %   owner - Username/groupname of External Location owner
    %   url - Path URL in cloud storage, of the form: AWS:
    %      "s3://bucket-host/[bucket-dir]" Azure: "abfss://host/[path]" GCP:
    %      "gs://bucket-host/[path]"
    %   credential_name - Name of the Storage Credential to use with this External Location
    %   read_only - Whether the External Location is read-only (default: false)
    %   force - update even if changing url invalidates dependent external
    %      tables (default: false)
    %   skip_validation - Whether to skip Storage Credential validation during update of
    %      the External Location (default: false)
    %   metastore_id - Unique identifier of the parent Metastore
    %   created_at - Date of External Location creation
    %   created_by - Username of External Location creator
    %   updated_at - Date of last update to External Location
    %   updated_by - Username of user who last updated External Location

    % Copyright 2022-2024 The MathWorks, Inc.

    properties
        % Name of External Location (must be unique within the parent
        % Metastore)
        name string
        % User-supplied free-form text
        comment string
        % Username/groupname of External Location owner
        owner string 
        % Path URL in cloud storage, of the form: AWS:
        % "s3://bucket-host/[bucket-dir]" Azure: "abfss://host/[path]" GCP:
        % "gs://bucket-host/[path]"
        url string
        % Name of the Storage Credential to use with this External Location
        credential_name string 
        % Whether the External Location is read-only (default: false)
        read_only logical
        % Force update even if changing url invalidates dependent external
        % tables (default: false)
        force logical
        % Whether to skip Storage Credential validation during update of
        % the External Location (default: false)
        skip_validation logical
        % Unique identifier of the parent Metastore
        metastore_id string
        % Date of External Location creation
        created_at datetime {JSONMapper.epochDatetime(created_at, 'TicksPerSecond', 1000)}
        % Username of External Location creator
        created_by string
        % Date of last update to External Location
        updated_at datetime {JSONMapper.epochDatetime(updated_at, 'TicksPerSecond', 1000)}
        % Username of user who last updated External Location
        updated_by string 
    end

    methods
        function obj = ExternalLocationInfo(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.ExternalLocationInfo
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
                fields.?databricks.datastructures.unitycatalog.ExternalLocationInfo
            end
            obj = databricks.datastructures.unitycatalog.ExternalLocationInfo;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end