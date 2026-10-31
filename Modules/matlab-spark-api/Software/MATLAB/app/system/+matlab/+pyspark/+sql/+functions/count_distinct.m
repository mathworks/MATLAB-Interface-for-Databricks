function newCol = count_distinct(col)
    % COUNT_DISTINCT Returns a new Column for distinct count of col or cols
    %
    % Examples:
    %   % Counting distinct values of a single column
    %   df = spark.createDataFrame(py.str('[(1,), (1,), (3,)]'), schema=["value"])
    %   df.select(matlab.pyspark.sql.functions.count_distinct(df.value)).show()
    %   +---------------------+
    %   |count(DISTINCT value)|
    %   +---------------------+
    %   |                    2|
    %   +---------------------+
    %
    %   % Counting distinct values of multiple columns
    %   df = spark.createDataFrame(py.str('[(1, 1), (1, 2)]'), schema=["value1", "value2"])
    %   df.select(matlab.pyspark.sql.functions.count_distinct(df.value1, df.value2)).show()
    %   +------------------------------+
    %   |count(DISTINCT value1, value2)|
    %   +------------------------------+
    %   |                             2|
    %   +------------------------------+
    %
    %   % Counting distinct values with column names as strings
    %   df = spark.createDataFrame(py.str('[(1, 1), (1, 2)]'), schema=["value1", "value2"])
    %   df.select(matlab.pyspark.sql.functions.count_distinct("value1", "value2")).show()
    %   +------------------------------+
    %   |count(DISTINCT value1, value2)|
    %   +------------------------------+
    %   |                             2|
    %   +------------------------------+

    % Copyright 2026 MathWorks, Inc.

    arguments (Repeating)
        col {matlab.pyspark.internal.mustBeColType}
    end

    col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.count_distinct(col{:}));
end
