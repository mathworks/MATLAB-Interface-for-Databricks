function newCol = isnull(col)
    % ISNULL An expression that returns true if the column is null
    %
    % Example:
    %   df = spark.createDataFrame(py.list({py.tuple({1, py.None}), py.tuple({py.None, 2})}), schema = ["a", "b"])
    %   df.select("*", matlab.pyspark.sql.functions.isnull("a"), matlab.pyspark.sql.functions.isnull(df.b)).show()
    %   +----+----+-----------+-----------+
    %   |   a|   b|(a IS NULL)|(b IS NULL)|
    %   +----+----+-----------+-----------+
    %   | 1.0|NULL|      false|       true|
    %   |NULL| 2.0|       true|      false|
    %   +----+----+-----------+-----------+

    % Copyright 2026 MathWorks, Inc.

    arguments
        col {matlab.pyspark.internal.mustBeColType}
    end

    col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.isnull(col));
end
