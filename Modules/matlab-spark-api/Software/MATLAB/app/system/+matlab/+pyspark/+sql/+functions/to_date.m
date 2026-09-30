function newCol = to_date(col, fmt)
    % to_date Convert column to date
    
    % Copyright 2024 MathWorks, Inc.

    arguments
        col {matlab.pyspark.internal.mustBeColType}
    end
    arguments (Repeating)
        fmt string
    end

    col = matlab.pyspark.internal.unifyColArguments(col);
    numFMT = numel(fmt);
    switch numFMT
        case 0
            newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.to_date(col));
        case 1
            newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.to_date(col, fmt{1}));
        otherwise
            error("SPARKAPI:TOO_MANY_ARGUMENTS", "to_date can only have one (optional) format agument");
    end

end %function
