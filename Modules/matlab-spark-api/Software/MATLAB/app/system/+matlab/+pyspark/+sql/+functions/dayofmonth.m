function newCol = dayofmonth(col)
    % dayofmonth Extract dayofmonth from a column

    % Copyright 2024 MathWorks, Inc.

    arguments
        col {matlab.pyspark.internal.mustBeColType}
    end

    col = matlab.pyspark.internal.unifyColArguments(col);
    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.dayofmonth(col));

end %function
