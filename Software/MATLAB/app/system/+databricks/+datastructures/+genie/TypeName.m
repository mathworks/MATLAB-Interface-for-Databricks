
classdef TypeName < JSONEnum
    % TYPENAME Data type enum
    % The name of the base data type. This doesn't include details for complex types
    % such as STRUCT, MAP or ARRAY.
    %
    % Example:
    %   f = databricks.datastructures.genie.TypeName.BOOLEAN;
    %
    % See also: https://docs.databricks.com/api/workspace/genie/executemessageattachmentquery#statement_response-manifest-schema-columns-type_name

    % (c) 2025 The MathWorks Inc.

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
