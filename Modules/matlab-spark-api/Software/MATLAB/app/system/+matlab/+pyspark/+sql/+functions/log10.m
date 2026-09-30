function newCol = log10(col)
    % LOG10 Returns Base-10 logarithm of col
    %
    % Examples:
    %   % Compute the logarithm in Base 10
    %   df = spark.createDataFrame(py.str("[(1,), (10,), (100,)]"), schema = ["value"])
    %   df.select("*", matlab.pyspark.sql.functions.log10(df.value)).show()
    %   +-----+------------+
    %   |value|LOG10(value)|
    %   +-----+------------+
    %   |    1|         0.0|
    %   |   10|         1.0|
    %   |  100|         2.0|
    %   +-----+------------+
    %
    %   % Compute the logarithm in Base 10 of invalid values
    %   spark.sql("SELECT * FROM VALUES (-1), (0), (FLOAT('NAN')), (NULL) AS TAB(value)").select("*",  matlab.pyspark.sql.functions.log10("value")).show()
    %   +-----+------------+
    %   |value|LOG10(value)|
    %   +-----+------------+
    %   | -1.0|        NULL|
    %   |  0.0|        NULL|
    %   |  NaN|         NaN|
    %   | NULL|        NULL|
    %   +-----+------------+

    % Copyright 2026 MathWorks, Inc.

    arguments (Input)
        col {matlab.pyspark.internal.mustBeColType}
    end

    col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = py.pyspark.sql.functions.log10(col);
end