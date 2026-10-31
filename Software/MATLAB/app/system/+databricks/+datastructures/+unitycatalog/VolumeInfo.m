classdef VolumeInfo < JSONMapper
    % VolumeInfo Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.VolumeInfo Properties:
    %   catalog_name - The identifier of the catalog
    %   schema_name - The identifier of the schema
    %   name - Volume name
    %   full_name - Full name of volume e.g. main.default.my_volume
    %   volume_type - databricks.datastructures.unitycatalog.VolumeType
    %   owner - Owner of the volume
    %   volume_id - ID of the volume
    %   metastore_id - ID of the metastore
    %   created_at - Date of volume creation
    %   created_by - Username of volume creator
    %   updated_at - Date of last update to volume
    %   updated_by - Username of user who last updated volume
    %   storage_location - Underlying volume storage location
    %   comment - Comment field, user-supplied free-form text

    % Copyright 2024 The MathWorks, Inc.

    properties
        % The identifier of the catalog
        catalog_name string
        % The identifier of the schema
        schema_name string
        % Volume name
        name string
        % Full name of volume e.g. main.default.my_volume
        full_name string
        % Type of volume e.g. EXTERNAL or MANAGED
        volume_type databricks.datastructures.unitycatalog.VolumeType
        % Owner of the volume
        owner string
        % ID of the volume
        volume_id string
        % ID of the metastore
        metastore_id string
        % Date of volume creation
        created_at datetime {JSONMapper.epochDatetime(created_at, 'TicksPerSecond', 1000)}
        % Username of volume creator
        created_by string
        % Date of last update to volume
        updated_at datetime {JSONMapper.epochDatetime(updated_at, 'TicksPerSecond', 1000)}
        % Username of user who last updated volume
        updated_by string
        % Underlying volume storage location
        storage_location string
        % Comment field, user-supplied free-form text
        comment string
    end

    methods
        function obj = VolumeInfo(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.VolumeInfo
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
                fields.?databricks.datastructures.unitycatalog.VolumeInfo
            end
            obj = databricks.datastructures.unitycatalog.VolumeInfo;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end    
end