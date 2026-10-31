function newCol = log2(col)
    % LOG2 Returns Base-2 logarithm of col
    %
    % Example:
    %   spark.range(10).select("*", matlab.pyspark.sql.functions.log2('id')).show()
    %   +---+------------------+
    %   | id|          LOG2(id)|
    %   +---+------------------+
    %   |  0|              NULL|
    %   |  1|               0.0|
    %   |  2|               1.0|
    %   |  3| 1.584962500721...|
    %   |  4|               2.0|
    %   |  5| 2.321928094887...|
    %   |  6| 2.584962500721...|
    %   |  7| 2.807354922057...|
    %   |  8|               3.0|
    %   |  9|3.1699250014423...|
    %   +---+------------------+

    % Copyright 2026 MathWorks, Inc.

    arguments (Input)
        col {matlab.pyspark.internal.mustBeColType}
    end

    arguments (Output)
        newCol (1,1) matlab.pyspark.sql.column.Column
    end

    col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = py.pyspark.sql.functions.log2(col);
end