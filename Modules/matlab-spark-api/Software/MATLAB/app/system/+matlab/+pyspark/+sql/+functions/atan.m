function newCol = atan(col)
    % ATAN inverse tangent of the input column
    %
    % Examples:
    %   % Compute the inverse tangent
    %   df = spark.createDataFrame([-0.5; 0.0; 0.5], schema="value")
    %   df.select("*", matlab.pyspark.sql.functions.atan(df.value)).show()
    %   +-----+-------------------+
    %   |value|        ATAN(value)|
    %   +-----+-------------------+
    %   | -0.5|-0.4636476090008061|
    %   |  0.0|                0.0|
    %   |  0.5| 0.4636476090008061|
    %   +-----+-------------------+
    %
    %   % Compute the inverse tangent of invalid values
    %   spark.sql("SELECT * FROM VALUES (FLOAT('NAN')), (NULL) AS TAB(value)").select(...
    %       "*", matlab.pyspark.sql.functions.atan("value")).show()
    %   +-----+-----------+
    %   |value|ATAN(value)|
    %   +-----+-----------+
    %   |  NaN|        NaN|
    %   | NULL|       NULL|
    %   +-----+-----------+

    % Copyright 2024-2026 MathWorks, Inc.

    arguments
        col {matlab.pyspark.internal.mustBeColType}
    end

    col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.atan(col));
end
