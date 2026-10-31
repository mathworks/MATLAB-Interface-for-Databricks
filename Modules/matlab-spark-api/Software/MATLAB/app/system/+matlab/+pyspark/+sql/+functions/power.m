function newCol = power(col1, col2)
    % POWER Returns the value of the first argument raised to the power of the second argument
    %   col1: the base number
    %   col2: the exponent number
    %
    % Example:
    %   spark.range(5).select("*", matlab.pyspark.sql.functions.power("id", 2)).show()
    %   +---+--------------+
    %   | id|POWER(id, 2.0)|
    %   +---+--------------+
    %   |  0|           0.0|
    %   |  1|           1.0|
    %   |  2|           4.0|
    %   |  3|           9.0|
    %   |  4|          16.0|
    %   +---+--------------+

    % Copyright 2026 MathWorks, Inc.

    arguments
        col1 {matlab.pyspark.internal.mustBeColFloatType}
        col2 {matlab.pyspark.internal.mustBeColFloatType}
    end

    col1 = matlab.pyspark.internal.unifyColArguments(col1);
    col2 = matlab.pyspark.internal.unifyColArguments(col2);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.power(col1, col2));
end
