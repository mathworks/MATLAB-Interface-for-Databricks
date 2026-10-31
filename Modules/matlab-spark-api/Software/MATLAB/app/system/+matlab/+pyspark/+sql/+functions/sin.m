function newCol = sin(col)
    % SIN Computes sin of the input column
    %
    % Examples:
    %   % Compute the sine
    %   spark.sql("SELECT * FROM VALUES (0.0), (PI() / 2), (PI() / 4) AS TAB(value)").select(...
    %       "*", matlab.pyspark.sql.functions.sin("value")).show()
    %   +------------------+------------------+
    %   |             value|        SIN(value)|
    %   +------------------+------------------+
    %   |               0.0|               0.0|
    %   |1.5707963267948966|               1.0|
    %   |0.7853981633974483|0.7071067811865475|
    %   +------------------+------------------+ 
    %
    %   % Compute the sine of invalid values
    %   spark.sql("SELECT * FROM VALUES (FLOAT('NAN')), (NULL) AS TAB(value)").select(...
    %       "*", matlab.pyspark.sql.functions.sin("value")).show()
    %   +-----+----------+
    %   |value|SIN(value)|
    %   +-----+----------+
    %   |  NaN|       NaN|
    %   | NULL|      NULL|
    %   +-----+----------+

    % Copyright 2026 MathWorks, Inc.

    arguments
        col {matlab.pyspark.internal.mustBeColType}
    end

    col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.sin(col));
end
