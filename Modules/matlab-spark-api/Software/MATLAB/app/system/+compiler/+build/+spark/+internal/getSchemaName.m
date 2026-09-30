function schemaName = getSchemaName(fullFileName)
    % getSchemaName Get the Schema name for a file/function

    % Copyright 2024-2025 The MathWorks, Inc.

    arguments
        fullFileName (1,1) string
    end

    schemaName = regexprep(fullFileName, "(.*)\.m$", "$1.schema");
end