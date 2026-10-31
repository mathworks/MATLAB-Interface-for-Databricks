function newCol = asinh(col)
    % ASINH Computes the inverse hyperbolic sine of the given column or expression
    %
    % Examples:
    %   % Compute the inverse hyperbolic sine
    %   df = spark.createDataFrame(py.str('[(-0.5,), (0.0,), (0.5,)]'), schema="value");
    %   df.select("*", matlab.pyspark.sql.functions.asinh(df.value)).show()
    %   +-----+--------------------+
    %   |value|        ASINH(value)|
    %   +-----+--------------------+
    %   | -0.5|-0.48121182505960336|
    %   |  0.0|                 0.0|
    %   |  0.5| 0.48121182505960347|
    %   +-----+--------------------+
    %
    %   % Compute the inverse hyperbolic sine of invalid values
    %   spark.sql("SELECT * FROM VALUES (FLOAT('NAN')), (NULL) AS TAB(value)").select("*", matlab.pyspark.sql.functions.asinh("value")).show()
    %   +-----+------------+
    %   |value|ASINH(value)|
    %   +-----+------------+
    %   |  NaN|         NaN|
    %   | NULL|        NULL|
    %   +-----+------------+

    % Copyright 2026 MathWorks, Inc.

    arguments (Input)
        col {matlab.pyspark.internal.mustBeColType}
    end
    arguments (Output)
        newCol (1,1) matlab.pyspark.sql.column.Column
    end

    col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.asinh(col));
end