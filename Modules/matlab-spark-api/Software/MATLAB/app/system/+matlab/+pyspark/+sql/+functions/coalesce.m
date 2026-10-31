function newCol = coalesce(col)
    % coalesce Returns the first column that is not null.
    %
    % Examples:
    % df = spark.createDataFrame(py.str('[(None, None), (1, None), (None, 2)]'), schema=["a", "b"])
    % df.show()
    % +----+----+
    % |   a|   b|
    % +----+----+
    % |NULL|NULL|
    % |   1|NULL|
    % |NULL|   2|
    % +----+----+
    %
    % df.select('*', matlab.pyspark.sql.functions.coalesce("a", df.("b"))).show()
    % +----+----+--------------+
    % |   a|   b|coalesce(a, b)|
    % +----+----+--------------+
    % |NULL|NULL|          NULL|
    % |   1|NULL|             1|
    % |NULL|   2|             2|
    % +----+----+--------------+
    %
    % df.select('*', matlab.pyspark.sql.functions.coalesce(df.("a"), matlab.pyspark.sql.functions.lit(0.0))).show()
    % +----+----+----------------+
    % |   a|   b|coalesce(a, 0.0)|
    % +----+----+----------------+
    % |NULL|NULL|             0.0|
    % |   1|NULL|             1.0|
    % |NULL|   2|             0.0|
    % +----+----+----------------+

    % Copyright 2026 MathWorks, Inc.

    arguments (Input, Repeating)
        col {matlab.pyspark.internal.mustBeColType}
    end
    arguments (Output)
        newCol (1,1) matlab.pyspark.sql.column.Column
    end

    cols = matlab.pyspark.internal.unifyColArguments(col);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.coalesce(cols{:}));

end
