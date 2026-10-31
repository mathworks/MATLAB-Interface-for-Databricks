classdef CatalogInfo < JSONMapper
    % CatalogInfo Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.CatalogInfo Properties:
    %   name - of Catalog relative to parent metastore
    %   comment - User-supplied free-form text
    %   ucproperties - Extensible Catalog properties
    %   owner - Username/groupname of Catalog owner
    %   provider_name - For Delta Sharing Catalogs: the name of the delta sharing
    %      provider
    %   share_name - For Delta Sharing Catalogs: the name of the share under the share
    %      provider
    %   metastore_id - Unique identifier of the parent Metastore
    %   created_at - Date of Catalog creation
    %   created_by - Username of Catalog creator
    %   updated_at - Date of last update to Catalog
    %   updated_by - Username of user who last updated Catalog

    % Copyright 2022-2024 The MathWorks, Inc.

    properties
        % Name of Catalog relative to parent metastore
        name string
        % User-supplied free-form text
        comment string
        % Extensible Catalog properties
        ucproperties JSONMapperMap {JSONMapper.fieldName(ucproperties,"properties")}
        % Username/groupname of Catalog owner
        owner string
        % For Delta Sharing Catalogs: the name of the delta sharing provider
        provider_name string
        % For Delta Sharing Catalogs: the name of the share under the share provider
        share_name string
        % Unique identifier of the parent metastore
        metastore_id string
        % Date of Catalog creation
        created_at datetime {JSONMapper.epochDatetime(created_at,'TicksPerSecond',1000)}
        % Username of Catalog creator
        created_by string
        % Date of last update to Catalog
        updated_at datetime {JSONMapper.epochDatetime(updated_at,'TicksPerSecond',1000)}
        % Username of user who last updated Catalog
        updated_by string
    end

    methods
        function obj = CatalogInfo(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.CatalogInfo
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
                fields.?databricks.datastructures.unitycatalog.CatalogInfo
            end
            obj = databricks.datastructures.unitycatalog.CatalogInfo;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end