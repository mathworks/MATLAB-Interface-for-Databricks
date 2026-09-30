function newCol = cot(col)
    % COT Computes cotangent of the input column
    %
    % Examples:
    %   % Compute the cotangent
    %   spark.sql("SELECT * FROM VALUES (PI() / 4), (PI() / 16) AS TAB(value)").select(...
    %       "*", matlab.pyspark.sql.functions.cot("value")).show()
    %   +-------------------+------------------+
    %   |              value|        COT(value)|
    %   +-------------------+------------------+
    %   | 0.7853981633974483|1.3246090892520057|
    %   |0.19634954084936207|1.0193385817707588|
    %   +-------------------+------------------+
    %
    %   % Compute the cotangent of invalid values
    %   spark.sql("SELECT * FROM VALUES (0.0), (FLOAT('NAN')), (NULL) AS TAB(value)").select("*", matlab.pyspark.sql.functions.cot("value")).show()
    %   +-----+----------+
    %   |value|COT(value)|
    %   +-----+----------+
    %   |  0.0|  Infinity|
    %   |  NaN|       NaN|
    %   | NULL|      NULL|
    %   +-----+----------+

    % Copyright 2026 MathWorks, Inc.

    arguments
        col {matlab.pyspark.internal.mustBeColType}
    end

    col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.cot(col));
end
