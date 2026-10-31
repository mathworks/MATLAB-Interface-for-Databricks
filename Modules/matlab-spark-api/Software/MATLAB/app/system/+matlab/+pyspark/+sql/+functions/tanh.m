function newCol = tanh(col)
    % TANH Computes hyperbolic tangent of the input column
    %
    % Examples:
    %   % Compute the hyperbolic tangent
    %   df = spark.createDataFrame([-1; 0; 1], schema="value")
    %   df.select("*", matlab.pyspark.sql.functions.tanh(df.value)).show()
    %   +-----+-------------------+
    %   |value|        TANH(value)|
    %   +-----+-------------------+
    %   | -1.0|-0.7615941559557649|
    %   |  0.0|                0.0|
    %   |  1.0| 0.7615941559557649|
    %   +-----+-------------------+
    %
    %   % Compute the hyperbolic tangent of invalid values
    %   spark.sql("SELECT * FROM VALUES (FLOAT('NAN')), (NULL) AS TAB(value)").select(...
    %       "*", matlab.pyspark.sql.functions.tanh("value")).show()
    %   +-----+-----------+
    %   |value|TANH(value)|
    %   +-----+-----------+
    %   |  NaN|        NaN|
    %   | NULL|       NULL|
    %   +-----+-----------+

    % Copyright 2026 MathWorks, Inc.

    arguments
        col {matlab.pyspark.internal.mustBeColType}
    end

    col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.tanh(col));
end
