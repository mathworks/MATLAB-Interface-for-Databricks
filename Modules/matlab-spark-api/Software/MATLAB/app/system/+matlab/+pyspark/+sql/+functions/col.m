function c = col(colName)
    % col - Get column by name

    % (c) 2024 MathWorks, Inc.

    arguments
        colName (1,1) string
    end

    c = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.col(colName));

end