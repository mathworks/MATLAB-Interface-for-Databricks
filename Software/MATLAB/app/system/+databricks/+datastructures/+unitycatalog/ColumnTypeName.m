classdef ColumnTypeName < JSONEnum
    % ColumnTypeName Enumeration of the type_name field within ColumnInfo
    %
    % Enumeration Values:
    %   BOOLEAN
    %   BYTE
    %   SHORT
    %   INT
    %   LONG
    %   FLOAT
    %   DOUBLE
    %   DATE
    %   TIMESTAMP
    %   STRING
    %   BINARY
    %   DECIMAL
    %   INTERVAL
    %   ARRAY
    %   STRUCT
    %   MAP
    %   CHAR
    %   NULL
    %   TIMESTAMP_NTZ

    % Copyright 2022-2025 The MathWorks, Inc.

    enumeration
        BOOLEAN ("BOOLEAN")
        BYTE ("BYTE")
        SHORT ("SHORT")
        INT ("INT")
        LONG ("LONG")
        FLOAT ("FLOAT")
        DOUBLE ("DOUBLE")
        DATE ("DATE")
        TIMESTAMP ("TIMESTAMP")
        TIMESTAMP_NTZ ("TIMESTAMP_NTZ")
        STRING ("STRING")
        BINARY ("BINARY")
        DECIMAL ("DECIMAL")
        INTERVAL ("INTERVAL")
        ARRAY ("ARRAY")
        STRUCT ("STRUCT")
        MAP ("MAP")
        CHAR ("CHAR")
        NULL ("NULL")
    end
end
