function newCol = count(col)
    % COUNT Aggregate function: returns the number of items in a group
    %
    % Examples:
    %   df = spark.createDataFrame([missing; "a"; "b"; "c"], schema="alphabets")
    %   df.select(matlab.pyspark.sql.functions.count(matlab.pyspark.sql.functions.expr("*"))).show()
    %   +--------+
    %   |count(1)|
    %   +--------+
    %   |       4|
    %   +--------+
    %
    %   df.select(matlab.pyspark.sql.functions.count(df.alphabets)).show()
    %   +----------------+
    %   |count(alphabets)|
    %   +----------------+
    %   |               3|
    %   +----------------+
    %
    %   % Python syntax
    %   df = spark.createDataFrame(py.str('([(1, "apple"), (2, "banana"), (3, None)])'), schema=["id", "fruit"])
    %   % Convert list of tuples
    %   df = spark.createDataFrame(py.list({py.tuple({1, "apple"}), py.tuple({2, "banana"}), py.tuple({3, py.None})}), schema=["id", "fruit"])
    %   df.select(matlab.pyspark.sql.functions.count(matlab.pyspark.sql.functions.expr("*"))).show()
    %   +--------+
    %   |count(1)|
    %   +--------+
    %   |       3|
    %   +--------+
    %
    %   % Count non-null values in multiple columns
    %   df.select(matlab.pyspark.sql.functions.count(df.id), matlab.pyspark.sql.functions.count(df.fruit)).show()
    %   +---------+------------+
    %   |count(id)|count(fruit)|
    %   +---------+------------+
    %   |        3|           2|
    %   +---------+------------+

    % Copyright 2026 MathWorks, Inc.

    arguments
        col {matlab.pyspark.internal.mustBeColType}
    end

    col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.count(col));
end
