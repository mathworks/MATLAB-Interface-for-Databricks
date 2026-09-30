classdef ConnectionType < JSONEnum
    % ConnectionType The type of connection enumeration.
    %
    % Enumeration Values:
    %   UNKNOWN_CONNECTION_TYPE
    %   MYSQL
    %   POSTGRESQL
    %   SNOWFLAKE
    %   REDSHIFT
    %   SQLDW
    %   SQLSERVER
    %   DATABRICKS
    %   SALESFORCE
    %   BIGQUERY
    %   WORKDAY_RAAS
    %   HIVE_METASTORE
    %   GA4_RAW_DATA
    %   SERVICENOW
    %   SALESFORCE_DATA_CLOUD
    %   GLUE
    %   ORACLE 
    %   TERADATA
    %   HTTP
    %   POWER_BI

    % Copyright 2026 The MathWorks, Inc.

    enumeration
        UNKNOWN_CONNECTION_TYPE ("UNKNOWN_CONNECTION_TYPE")
        MYSQL ("MYSQL")
        POSTGRESQL ("POSTGRESQL")
        SNOWFLAKE ("SNOWFLAKE")
        REDSHIFT ("REDSHIFT")
        SQLDW ("SQLDW")
        SQLSERVER ("SQLSERVER")
        DATABRICKS ("DATABRICKS")
        SALESFORCE ("SALESFORCE")
        BIGQUERY ("BIGQUERY")
        WORKDAY_RAAS ("WORKDAY_RAAS")
        HIVE_METASTORE ("HIVE_METASTORE")
        GA4_RAW_DATA ("GA4_RAW_DATA")
        SERVICENOW ("SERVICENOW")
        SALESFORCE_DATA_CLOUD ("SALESFORCE_DATA_CLOUD")
        GLUE ("GLUE")
        ORACLE ("ORACLE")
        TERADATA ("TERADATA")
        HTTP ("HTTP")
        POWER_BI ("POWER_BI")
    end
end
