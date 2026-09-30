function newCol = exp(col)
    % EXP Computes the exponential of the given value
    %
    % Examples:
    %   df = spark.sql("SELECT id AS value FROM RANGE(5)")
    %   df.select("*", matlab.pyspark.sql.functions.exp(df.value)).show()
    %   +-----+------------------+
    %   |value|        EXP(value)|
    %   +-----+------------------+
    %   |    0|               1.0|
    %   |    1| 2.718281828459045|
    %   |    2|  7.38905609893065|
    %   |    3|20.085536923187668|
    %   |    4|54.598150033144236|
    %   +-----+------------------+

    % Copyright 2026 MathWorks, Inc.

    arguments (Input)
        col {matlab.pyspark.internal.mustBeColType}
    end
    arguments (Output)
        newCol (1,1) matlab.pyspark.sql.column.Column
    end

    col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.exp(col));
end