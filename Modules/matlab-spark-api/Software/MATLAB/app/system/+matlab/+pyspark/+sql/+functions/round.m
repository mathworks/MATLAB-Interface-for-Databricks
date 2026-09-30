function newCol = round(col, scale)
    % round Round a column
    
    % Copyright 2024 MathWorks, Inc.

    arguments
        col {matlab.pyspark.internal.mustBeColType}
        scale (1,1) int64 = 0
    end

    col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.round(col, scale));

end %function
