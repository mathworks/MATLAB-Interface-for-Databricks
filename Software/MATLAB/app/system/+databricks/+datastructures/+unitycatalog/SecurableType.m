classdef SecurableType < JSONEnum
    % SecurableType The type of Unity Catalog securable.
    
    % Enumeration Values:
    %   CATALOG
    %   SCHEMA
    %   TABLE
    %   STORAGE_CREDENTIAL
    %   EXTERNAL_LOCATION
    %   FUNCTION
    %   SHARE
    %   PROVIDER
    %   RECIPIENT
    %   CLEAN_ROOM
    %   METASTORE
    %   PIPELINE
    %   VOLUME
    %   CONNECTION
    %   CREDENTIAL
    %   EXTERNAL_METADATA
    %   STAGING_TABLE
    
    % Copyright 2026 The MathWorks, Inc.

    enumeration
        CATALOG ("CATALOG")
        SCHEMA ("SCHEMA")
        TABLE ("TABLE")
        STORAGE_CREDENTIAL ("STORAGE_CREDENTIAL")
        EXTERNAL_LOCATION ("EXTERNAL_LOCATION")
        FUNCTION ("FUNCTION")
        SHARE ("SHARE")
        PROVIDER ("PROVIDER")
        RECIPIENT ("RECIPIENT")
        CLEAN_ROOM ("CLEAN_ROOM")
        METASTORE ("METASTORE")
        PIPELINE ("PIPELINE")
        VOLUME ("VOLUME")
        CONNECTION ("CONNECTION")
        CREDENTIAL ("CREDENTIAL")
        EXTERNAL_METADATA ("EXTERNAL_METADATA")
        STAGING_TABLE ("STAGING_TABLE")
    end
end
