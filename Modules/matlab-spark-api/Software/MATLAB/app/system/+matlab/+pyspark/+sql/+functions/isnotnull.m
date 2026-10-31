function newCol = isnotnull(col)
    % ISNOTNULL Returns true if col is not null, or false otherwise
    %
    % Examples:
    %   df = spark.createDataFrame({py.None; 1}, schema="e")
    %   df.select('*', matlab.pyspark.sql.functions.isnotnull(df.e)).show()
    %   +----+---------------+
    %   |   e|(e IS NOT NULL)|
    %   +----+---------------+
    %   |NULL|          false|
    %   | 1.0|           true|
    %   +----+---------------+
    %
    %   df.select('*', matlab.pyspark.sql.functions.isnotnull('e')).show()
    %   +----+---------------+
    %   |   e|(e IS NOT NULL)|
    %   +----+---------------+
    %   |NULL|          false|
    %   | 1.0|           true|
    %   +----+---------------+

    % Copyright 2026 MathWorks, Inc.

    arguments
        col {matlab.pyspark.internal.mustBeColType}
    end

    col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.isnotnull(col));
end
