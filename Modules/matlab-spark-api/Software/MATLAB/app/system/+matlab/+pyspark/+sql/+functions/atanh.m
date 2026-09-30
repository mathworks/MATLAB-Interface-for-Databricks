function newCol = atanh(col)
    % ATANH Computes inverse hyperbolic tangent of the input column.
    %
    % Examples:
    %   % Create a sample DataFrame
    %   value = [1.0; 2.0; 5.0];
    %   T = table(value);
    %   df = matlab.sparkutils.table2dataset(T, spark);
    %
    %   % Apply atanh function
    %   df.select(matlab.pyspark.sql.functions.atanh(df.col("value")).alias("atanh_value")).show()
    %   +-----------+
    %   |atanh_value|
    %   +-----------+
    %   |   Infinity|
    %   |        NaN|
    %   |        NaN|
    %   +-----------+
    %
    %
    %   % Compute the inverse hyperbolic sine
    %   df = spark.createDataFrame([-0.5; 0.0; 0.5], schema="value")
    %   df.select("*", matlab.pyspark.sql.functions.atanh(df.value)).show()
    %   +-----+-------------------+
    %   |value|       ATANH(value)|
    %   +-----+-------------------+
    %   | -0.5|-0.5493061443340548|
    %   |  0.0|                0.0|
    %   |  0.5| 0.5493061443340548|
    %   +-----+-------------------+
    %
    %
    %   % Compute the inverse hyperbolic sine of invalid values
    %   spark.sql("SELECT * FROM VALUES (-2), (2), (FLOAT('NAN')), (NULL) AS TAB(value)").select("*", matlab.pyspark.sql.functions.atanh("value")).show()
    %   +-----+------------+
    %   |value|ATANH(value)|
    %   +-----+------------+
    %   | -2.0|         NaN|
    %   |  2.0|         NaN|
    %   |  NaN|         NaN|
    %   | NULL|        NULL|
    %   +-----+------------+

    % Copyright 2026 MathWorks, Inc.

    arguments (Input)
        col {matlab.pyspark.internal.mustBeColType}
    end

    col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.atanh(col));
end