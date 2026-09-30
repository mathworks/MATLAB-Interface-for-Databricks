function newCol = acosh(col)
    % ACOSH Computes the inverse hyperbolic cosine of the given column or expression
    %
    % Examples:
    %   % Create a sample DataFrame
    %   value = [1.0; 2.0; 5.0];
    %   T = table(value);
    %   df = matlab.sparkutils.table2dataset(T, spark);
    %
    %   % Apply acosh function
    %   df.select(matlab.pyspark.sql.functions.acosh(df.col("value")).alias("acosh_value")).show()
    %   +------------------+
    %   |       acosh_value|
    %   +------------------+
    %   |               0.0|
    %   |1.3169578969248166|
    %   |2.2924316695611777|
    %   +------------------+
    %
    %   %  Compute the inverse hyperbolic cosine
    %   df = spark.createDataFrame([1; 2], schema="value")
    %   df.select("*", matlab.pyspark.sql.functions.acosh(df.value)).show()
    %   +-----+------------------+
    %   |value|      ACOSH(value)|
    %   +-----+------------------+
    %   |  1.0|               0.0|
    %   |  2.0|1.3169578969248166|
    %   +-----+------------------+
    %
    %   %  Compute the inverse hyperbolic cosine of invalid values
    %   spark.sql("SELECT * FROM VALUES (-0.5), (0.5), (NULL) AS TAB(value)").select("*", matlab.pyspark.sql.functions.acosh("value")).show()
    %   +-----+------------+
    %   |value|ACOSH(value)|
    %   +-----+------------+
    %   | -0.5|         NaN|
    %   |  0.5|         NaN|
    %   | NULL|        NULL|
    %   +-----+------------+

    % Copyright 2026 MathWorks, Inc.

    arguments (Input)
        col {matlab.pyspark.internal.mustBeColType}
    end

    col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.acosh(col));
end