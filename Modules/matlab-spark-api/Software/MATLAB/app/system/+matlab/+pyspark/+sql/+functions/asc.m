function newCol = asc(col)
    % asc Returns sorted column, ascending
    %
    % Examples:
    %   % Sort DataFrame by ‘id’ column in ascending order.
    %   df = spark.createDataFrame(py.str("[(4, 'B'), (3, 'A'), (2, 'C')]"), schema=["id", "value"]);
    %   df.sort(matlab.pyspark.sql.functions.asc("id")).show()
    %   +---+-----+
    %   | id|value|
    %   +---+-----+
    %   |  2|    C|
    %   |  3|    A|
    %   |  4|    B|
    %   +---+-----+
    %
    %   % Use asc in orderBy function to sort the DataFrame.
    %   df = spark.createDataFrame(py.str("[(4, 'B'), (3, 'A'), (2, 'C')]"), schema=["id", "value"]);
    %   df.orderBy(matlab.pyspark.sql.functions.asc("value")).show()
    %   +---+-----+
    %   | id|value|
    %   +---+-----+
    %   |  3|    A|
    %   |  4|    B|
    %   |  2|    C|
    %   +---+-----+
    %
    %   % Combine asc with desc to sort by multiple columns.
    %   df = spark.createDataFrame(py.str("[(2, 'A', 4), (1, 'B', 3), (3, 'A', 2)]"), schema=["id", "group", "value"]);
    %   df.sort(matlab.pyspark.sql.functions.asc("group"), matlab.pyspark.sql.functions.desc("value")).show()
    %   +---+-----+-----+
    %   | id|group|value|
    %   +---+-----+-----+
    %   |  2|    A|    4|
    %   |  3|    A|    2|
    %   |  1|    B|    3|
    %   +---+-----+-----+
    %
    %   % Implement asc from column expression.
    %   df = spark.createDataFrame(py.str("[(4, 'B'), (3, 'A'), (2, 'C')]"), schema = ["id", "value"]);
    %   df.sort(df.id.asc()).show()
    %   +---+-----+
    %   | id|value|
    %   +---+-----+
    %   |  2|    C|
    %   |  3|    A|
    %   |  4|    B|
    %   +---+-----+
    %
    % See also: https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/api/pyspark.sql.functions.asc.html


    % Copyright 2024-2026 MathWorks, Inc.

    arguments
        col {matlab.pyspark.internal.mustBeColType}
    end

    col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.asc(col));
end