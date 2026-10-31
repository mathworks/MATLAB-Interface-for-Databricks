classdef ColumnInfoType < JSONEnum
    % ColumnInfoType SQL column type names
    %
    % ColumnInfoType enumerates the base SQL data types returned in
    % statement execution result schemas.

    % Copyright 2023-2026, MathWorks Inc.

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
        STRING ("STRING")
        BINARY ("BINARY")
        DECIMAL ("DECIMAL")
        INTERVAL ("INTERVAL")
        ARRAY ("ARRAY")
        STRUCT ("STRUCT")
        MAP ("MAP")
        CHAR ("CHAR")
        NULL ("NULL")
        USER_DEFINED_TYPE ("USER_DEFINED_TYPE")
    end
end
