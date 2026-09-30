function newCol = date_format(col, fmt)
    % date_format Convert time/date column to string column
    
    % Copyright 2024 MathWorks, Inc.

    arguments
        col {matlab.pyspark.internal.mustBeColType}
        fmt string
    end

    col = matlab.pyspark.internal.unifyColArguments(col);
    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.date_format(col, fmt));
end %function
