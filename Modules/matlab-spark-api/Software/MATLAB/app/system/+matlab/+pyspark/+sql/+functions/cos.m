function newCol = cos(col)
    % COS Computes cosine of the input column
    %
    % Examples:
    %   % Compute the cosine
    %   spark.sql("SELECT * FROM VALUES (PI()), (PI() / 4), (PI() / 16) AS TAB(value)").select(...
    %       "*", matlab.pyspark.sql.functions.cos("value")).show()
    %
    %   +-------------------+------------------+
    %   |              value|        COS(value)|
    %   +-------------------+------------------+
    %   |  3.141592653589793|              -1.0|
    %   | 0.7853981633974483|0.7071067811865476|
    %   |0.19634954084936207|0.9807852804032304|
    %   +-------------------+------------------+
    %
    %   % Compute the cosine of invalid values
    %   spark.sql("SELECT * FROM VALUES (FLOAT('NAN')), (NULL) AS TAB(value)").select(...
    %       "*", matlab.pyspark.sql.functions.cos("value")).show()
    %   +-----+----------+
    %   |value|COS(value)|
    %   +-----+----------+
    %   |  NaN|       NaN|
    %   | NULL|      NULL|
    %   +-----+----------+

    % Copyright 2026 MathWorks, Inc.

    arguments
        col {matlab.pyspark.internal.mustBeColType}
    end

    col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.cos(col));
end
