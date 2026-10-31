function newCol = first(col, ignoreNulls)
    % FIRST Aggregate function: returns the first value in a group
    %
    % The function by default returns the first values it sees.
    % It will return the first non-null value it sees when ignoreNulls
    % is set to true. If all values are null, then null is returned.
    %
    % The function is non-deterministic because its results depends on the order
    % of the rows which may be non-deterministic after a shuffle.
    %
    % Examples:
    %   df = spark.createDataFrame(py.str('[("Alice", 2), ("Bob", 5), ("Alice", None)]'), schema=["name", "age"])
    %   df = df.orderBy(df.age)
    %   df.groupBy("name").agg(matlab.pyspark.sql.functions.first("age")).orderBy("name").show()
    %   +-----+----------+
    %   | name|first(age)|
    %   +-----+----------+
    %   |Alice|      NULL|
    %   |  Bob|         5|
    %   +-----+----------+
    %
    %   df.groupBy("name").agg(matlab.pyspark.sql.functions.first("age", true)).orderBy("name").show()
    %   +-----+----------+
    %   | name|first(age)|
    %   +-----+----------+
    %   |Alice|         2|
    %   |  Bob|         5|
    %   +-----+----------+

    % Copyright 2026 MathWorks, Inc.

    arguments (Input)
        col {matlab.pyspark.internal.mustBeColType}
        ignoreNulls (1,1) logical = false
    end

    col = matlab.pyspark.internal.unifyColArguments(col);
    
    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.first(col, py.bool(ignoreNulls)));
end