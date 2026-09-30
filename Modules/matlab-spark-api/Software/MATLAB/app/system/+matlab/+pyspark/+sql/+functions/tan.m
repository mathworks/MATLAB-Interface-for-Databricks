function newCol = tan(col)
    % TAN Computes tangent of the input column
    %
    % Examples:
    %   % Compute the tangent
    %   spark.sql("SELECT * FROM VALUES (0.0), (PI() / 4), (PI() / 6) AS TAB(value)").select(...
    %       "*", matlab.pyspark.sql.functions.tan("value")).show()
    %   +------------------+------------------+
    %   |             value|        TAN(value)|
    %   +------------------+------------------+
    %   |               0.0|               0.0|
    %   |0.7853981633974483|0.9999999999999999|
    %   |0.5235987755982988|0.5773502691896257|
    %   +------------------+------------------+
    %
    %   % Compute the tangent of invalid values
    %   spark.sql("SELECT * FROM VALUES (FLOAT('NAN')), (NULL) AS TAB(value)").select(...
    %       "*", matlab.pyspark.sql.functions.tan("value")).show()
    %   +-----+----------+
    %   |value|TAN(value)|
    %   +-----+----------+
    %   |  NaN|       NaN|
    %   | NULL|      NULL|
    %   +-----+----------+

    % Copyright 2026 MathWorks, Inc.

    arguments
        col {matlab.pyspark.internal.mustBeColType}
    end

    col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.tan(col));
end
