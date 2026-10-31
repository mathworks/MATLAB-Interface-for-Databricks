function newCol = concat(col)
    % concat Concatenates several columns
    %
    % Examples:
    %   % Concatenating string columns
    %   df = spark.createDataFrame(["abcd", "123"], schema=["s", "d"]);
    %   df.select(matlab.pyspark.sql.functions.concat(df.s, df.d)).show()
    %   +------------+
    %   |concat(s, d)|
    %   +------------+
    %   |     abcd123|
    %   +------------+
    %
    %   % Concatenating array columns
    %   df = spark.createDataFrame(py.str("[([1, 2], [3, 4], [5]), ([1, 2], None, [3])]"), schema=["a", "b", "c"]);
    %   df.select(matlab.pyspark.sql.functions.concat(df.a, df.b, df.c)).show()
    %   +---------------+
    %   |concat(a, b, c)|
    %   +---------------+
    %   |[1, 2, 3, 4, 5]|
    %   |           NULL|
    %   +---------------+
    %
    % See also: https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/api/pyspark.sql.functions.concat.html


    % Copyright 2024-2026 MathWorks, Inc.

    arguments (Repeating)
        col {matlab.pyspark.internal.mustBeColType}
    end

    col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.concat(col{:}));
end