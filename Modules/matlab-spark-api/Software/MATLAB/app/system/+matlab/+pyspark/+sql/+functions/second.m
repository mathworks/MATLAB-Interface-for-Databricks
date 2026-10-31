function newCol = second(col)
    % second Extract second from a column

    % Copyright 2024 MathWorks, Inc.

    arguments
        col {matlab.pyspark.internal.mustBeColType}
    end

    col = matlab.pyspark.internal.unifyColArguments(col);
    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.second(col));

end %function
