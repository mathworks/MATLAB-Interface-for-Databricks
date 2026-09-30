function newCol = isnan(col)
    % ISNAN An expression that returns true if the column is NaN
    %
    % Example:
    %   df = spark.createDataFrame(py.list({py.tuple({1.0, nan}), py.tuple({nan, 2.0})}), schema=["a", "b"])
    %   df.select("*", matlab.pyspark.sql.functions.isnan("a"), matlab.pyspark.sql.functions.isnan(df.b)).show()
    %   +---+---+--------+--------+
    %   |  a|  b|isnan(a)|isnan(b)|
    %   +---+---+--------+--------+
    %   |1.0|NaN|   false|    true|
    %   |NaN|2.0|    true|   false|
    %   +---+---+--------+--------+

    % Copyright 2026 MathWorks, Inc.

    arguments
        col {matlab.pyspark.internal.mustBeColType}
    end

    col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.isnan(col));
end
