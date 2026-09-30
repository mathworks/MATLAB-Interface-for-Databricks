function col = lit(value)
    % LIT Creates a column containing a constant value
    %
    % This function will return a new column with a literal value.
    
    % Copyright 2024 MathWorks, Inc.

    switch class(value)
        case {'int64', 'int32', 'int16'}
            value = int64(value);
        case {'char', 'string'}
            value = string(value);
        case {'double', 'single'}
            value = double(value);
        case {'logical'}
            % No change needed
        otherwise
            error("SPARKAPI:SQL_FUNCTIONS_LIT", ...
                "Unsupported type, %s", class(value));
    end

    col = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.lit(value));

end %function
