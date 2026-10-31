function newCol = cosh(col)
    % COSH Computes hyperbolic cosine of the input column
    %
    % Examples:
    %   df = spark.createDataFrame([-1; 0; 1], schema="value")
    %   df.select("*", matlab.pyspark.sql.functions.cosh(df.value)).show()
    %   +-----+------------------+
    %   |value|        COS(value)|
    %   +-----+------------------+
    %   | -1.0|0.5403023058681398|
    %   |  0.0|               1.0|
    %   |  1.0|0.5403023058681398|
    %   +-----+------------------+
    %
    %   % Compute the invalid values
    %   spark.sql("SELECT * FROM VALUES (FLOAT('NAN')), (NULL) AS TAB(value)").select(...
    %       "*", matlab.pyspark.sql.functions.cosh("value")).show()
    %
    %   +-----+-----------+
    %   |value|COSH(value)|
    %   +-----+-----------+
    %   |  NaN|        NaN|
    %   | NULL|       NULL|
    %   +-----+-----------+

    % Copyright 2026 MathWorks, Inc.

    arguments
        col {matlab.pyspark.internal.mustBeColType}
    end

    col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.cosh(col));
end
