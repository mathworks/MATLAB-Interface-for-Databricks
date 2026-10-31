classdef TableInfo < JSONMapper
    % TableInfo Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.TableInfo Properties:
    %   name - of Table relative to parent Schema
    %   catalog_name - Name of parent Catalog
    %   schema_name - Name of parent Schema relative to parent Catalog
    %   table_type - Distinguishes a view vs. managed/external Table
    %   data_source_format - See Data Source Format spec
    %   columns - Sequence of Table columns
    %   storage_location - URL of storage location for Table data (* REQ for EXTERNAL
    %      Tables. For Managed Tables, if the path is provided it needs to
    %      be a Staging Table path that has been generated through the
    %      Staging Table API, otherwise should be empty)
    %   storage_credential_name - For EXTERNAL Tables only: the name of storage credential to use
    %      (may not be changed via UpdateTable endpoint).
    %   view_definition - SQL text defining the view (for table_type == "VIEW")
    %   sql_path - List of schemes whose objects can be referenced without
    %      qualification (ref)
    %   comment - User-supplied free-form text
    %   owner - Username/groupname of Table owner
    %   ucproperties - Extensible Table properties
    %   metastore_id - Unique identifier of the parent Metastore
    %   full_name - Fully-qualified name of Table as <catalog>.<schema>.<table>
    %   created_at - Date of Table creation
    %   created_by - Username of Table creator
    %   updated_at - Date of last update to Table
    %   updated_by - Username of user who last updated Table

    % Copyright 2022-2025 The MathWorks, Inc.

    properties
        % Name of Table relative to parent Schema
        name string
        % Name of parent Catalog
        catalog_name string
        % Name of parent Schema relative to parent Catalog
        schema_name string
        % Distinguishes a view vs. managed/external Table
        table_type databricks.datastructures.unitycatalog.TableType
        % See Data Source Format spec
        data_source_format databricks.datastructures.unitycatalog.DataSourceFormat
        % Sequence of Table columns
        columns databricks.datastructures.unitycatalog.ColumnInfo {JSONMapper.JSONArray}
        % URL of storage location for Table data (* REQ for EXTERNAL
        % Tables. For Managed Tables, if the path is provided it needs to
        % be a Staging Table path that has been generated through the
        % Staging Table API, otherwise should be empty)
        storage_location string
        % For EXTERNAL Tables only: the name of storage credential to use
        % (may not be changed via UpdateTable endpoint).
        storage_credential_name string
        % SQL text defining the view (for table_type == "VIEW")
        view_definition string
        % List of schemes whose objects can be referenced without
        % qualification (ref)
        sql_path string
        % User-supplied free-form text
        comment string
        % Username/groupname of Table owner
        owner string
        % Extensible Table properties
        ucproperties JSONMapperMap {JSONMapper.fieldName(ucproperties,"properties")}
        % Unique identifier of the parent Metastore
        metastore_id string
        % Fully-qualified name of Table as <catalog>.<schema>.<table>
        full_name string
        % Date of Table creation
        created_at datetime {JSONMapper.epochDatetime(created_at, 'TicksPerSecond', 1000)}
        % Username of Table creator
        created_by string
        % Date of last update to Table
        updated_at datetime {JSONMapper.epochDatetime(updated_at, 'TicksPerSecond', 1000)}
        % Username of user who last updated Table
        updated_by string
        
    end

    methods
        function obj = TableInfo(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.TableInfo
            end
            obj@JSONMapper(s, inputs);
        end
    end
end