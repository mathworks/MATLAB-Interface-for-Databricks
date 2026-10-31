function newCol = sqrt(col)
    % SQRT Computes the square root of the specified float value
    %
    % Examples:
    %   spark.sql("SELECT * FROM VALUES (-1), (0), (1), (4), (NULL) AS TAB(value)").select(...
    %       "*", matlab.pyspark.sql.functions.sqrt("value")).show()
    %   +-----+-----------+
    %   |value|SQRT(value)|
    %   +-----+-----------+
    %   |   -1|        NaN|
    %   |    0|        0.0|
    %   |    1|        1.0|
    %   |    4|        2.0|
    %   | NULL|       NULL|
    %   +-----+-----------+

    % Copyright 2026 MathWorks, Inc.

    arguments
        col {matlab.pyspark.internal.mustBeColType}
    end

    col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.sqrt(col));
end
