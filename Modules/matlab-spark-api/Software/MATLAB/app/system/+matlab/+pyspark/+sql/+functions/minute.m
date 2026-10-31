function newCol = minute(col)
    % minute Extract minute from a column

    % Copyright 2024 MathWorks, Inc.

    arguments
        col {matlab.pyspark.internal.mustBeColType}
    end

    col = matlab.pyspark.internal.unifyColArguments(col);
    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.minute(col));

end %function
