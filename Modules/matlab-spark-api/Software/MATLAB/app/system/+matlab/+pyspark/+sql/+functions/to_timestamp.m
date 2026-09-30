function newCol = to_timestamp(col, fmt)
    % to_timestamp Convert column to timestamp
    
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
            newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.to_timestamp(col));
        case 1
            newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.to_timestamp(col, fmt{1}));
        otherwise
            error("SPARKAPI:TOO_MANY_ARGUMENTS", "to_timestamp can only have one (optional) format agument");
    end

end %function
