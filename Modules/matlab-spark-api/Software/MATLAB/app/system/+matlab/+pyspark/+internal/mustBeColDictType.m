function mustBeColDictType(arg)
    % mustBeColType Ensure string or column
    %
    % This function returns no values, but errors if the argument is of the
    % wrong type. It can be used in arguments section of a function.

    % Copyright 2024-2026 MathWorks, Inc.

    switch string(class(arg))
        case "cell"
            return;
        case "struct"
            return;
        case "string"
            return;
        case "char"
            return;
        case "matlab.pyspark.sql.column.Column"
            return;
        case "py.pyspark.sql.connect.column.Column"
            return;
        otherwise
            error("SPARKAPI:BADCOLDICTTYPEARGUMENT", ...
            "Invalid column type: %s", class(arg));
    end
end