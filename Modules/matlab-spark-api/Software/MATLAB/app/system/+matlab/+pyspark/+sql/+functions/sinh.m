function newCol = sinh(col)
    % SINH Computes hyperbolic sine of the input column
    %
    % Examples:
    %   % Compute the hyperbolic sine
    %   df = spark.createDataFrame([-1; 0; 1], schema="value")
    %   df.select(matlab.pyspark.sql.functions.sinh("value")).show()
    %   +-------------------+
    %   |        SINH(value)|
    %   +-------------------+
    %   |-1.1752011936438014|
    %   |                0.0|
    %   | 1.1752011936438014|
    %   +-------------------+
    %
    %   % Compute the hyperbolic sine of invalid values
    %   spark.sql("SELECT * FROM VALUES (FLOAT('NAN')), (NULL) AS TAB(value)").select(...
    %       "*", matlab.pyspark.sql.functions.sinh("value")).show()
    %   +-----+-----------+
    %   |value|SINH(value)|
    %   +-----+-----------+
    %   |  NaN|        NaN|
    %   | NULL|       NULL|
    %   +-----+-----------+

    % Copyright 2026 MathWorks, Inc.

    arguments
        col {matlab.pyspark.internal.mustBeColType}
    end

    col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.sinh(col));
end
