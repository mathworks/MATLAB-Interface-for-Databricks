classdef SchemaInfo < JSONMapper
    % SCHEMAINFO Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.SchemaInfo Properties:
    %   name - of Schema relative to parent catalog
    %   catalog_name - Name of parent Catalog
    %   comment - User-supplied free-form text
    %   owner - Username/groupname of Schema owner
    %   ucproperties - Extensible Schema properties
    %   metastore_id - Unique identifier of the parent Metastore
    %   full_name - Fully-qualified name of Schema as <catalog>.<schema>
    %   created_at - Date of Schema creation
    %   created_by - Username of Schema creator
    %   updated_at - Date of last update to Schema
    %   updated_by - Username of user who last updated Schema

    % Copyright 2022-2024 The MathWorks, Inc.

    properties
        % Name of Schema relative to parent catalog	
        name string
        % Name of parent Catalog	
        catalog_name string
        % User-supplied free-form text	
        comment string
        % Username/groupname of Schema owner	
        owner string
        % Extensible Schema properties
        ucproperties JSONMapperMap {JSONMapper.fieldName(ucproperties,"properties")}
        % Unique identifier of the parent Metastore	
        metastore_id string
        % Fully-qualified name of Schema as <catalog>.<schema>	
        full_name string
        % Date of Schema creation	
        created_at datetime {JSONMapper.epochDatetime(created_at, 'TicksPerSecond', 1000)}
        % Username of Schema creator	
        created_by string
        % Date of last update to Schema	
        updated_at datetime {JSONMapper.epochDatetime(updated_at, 'TicksPerSecond', 1000)}
        % Username of user who last updated Schema
        updated_by string      
    end

    methods
        function obj = SchemaInfo(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.SchemaInfo
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
                fields.?databricks.datastructures.unitycatalog.SchemaInfo
            end
            obj = databricks.datastructures.unitycatalog.SchemaInfo;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end    
end