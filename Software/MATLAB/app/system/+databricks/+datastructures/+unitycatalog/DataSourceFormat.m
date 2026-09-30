classdef DataSourceFormat < JSONEnum
    % DataSourceFormat Enumeration of the table_type field within TableInfo
    %
    % Enumeration Values:
    %   DELTA
    %   CSV
    %   JSON
    %   AVRO
    %   PARQUET
    %   ORC
    %   TEXT
    %   UNITY_CATALOG
    %   DELTASHARING

    % Copyright 2022 The MathWorks, Inc.

    enumeration
        DELTA ("DELTA")
        CSV ("CSV")
        JSON ("JSON")
        AVRO ("AVRO")
        PARQUET ("PARQUET")
        ORC ("ORC")
        TEXT ("TEXT")
        UNITY_CATALOG ("UNITY_CATALOG")
        DELTASHARING ("DELTASHARING")
    end
end
