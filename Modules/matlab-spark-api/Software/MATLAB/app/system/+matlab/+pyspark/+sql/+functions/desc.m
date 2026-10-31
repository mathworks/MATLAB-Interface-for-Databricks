function newCol = desc(col)
    % desc Returns sorted column, descending
    %
    % Examples:
    %   % Sort DataFrame by ‘id’ column in descending order.
    %   df = spark.createDataFrame(py.str("[(4, 'B'), (3, 'A'), (2, 'C')]"), schema=["id", "value"]);
    %   df.sort(matlab.pyspark.sql.functions.desc("id")).show()
    %   +---+-----+
    %   | id|value|
    %   +---+-----+
    %   |  4|    B|
    %   |  3|    A|
    %   |  2|    C|
    %   +---+-----+
    %
    %   % Use desc in orderBy function to sort the DataFrame.
    %   df = spark.createDataFrame(py.str("[(4, 'B'), (3, 'A'), (2, 'C')]"), schema=["id", "value"]);
    %   df.orderBy(matlab.pyspark.sql.functions.desc("value")).show()
    %   +---+-----+
    %   | id|value|
    %   +---+-----+
    %   |  2|    C|
    %   |  4|    B|
    %   |  3|    A|
    %   +---+-----+
    %
    %   % Combine asc with desc to sort by multiple columns.
    %   df = spark.createDataFrame(py.str("[(2, 'A', 4), (1, 'B', 3), (3, 'A', 2)]"), schema= ["id", "group", "value"]);
    %   df.sort(sf.desc("group"), sf.asc("value")).show
    %   +---+-----+-----+
    %   | id|group|value|
    %   +---+-----+-----+
    %   |  1|    B|    3|
    %   |  3|    A|    2|
    %   |  2|    A|    4|
    %   +---+-----+-----+
    %
    %   % Implement desc from column expression.
    %   df = spark.createDataFrame(py.str("[(4, 'B'), (3, 'A'), (2, 'C')]"), schema=["id", "value"]);
    %   df.sort(df.id.desc()).show()
    %   +---+-----+
    %   | id|value|
    %   +---+-----+
    %   |  4|    B|
    %   |  3|    A|
    %   |  2|    C|
    %   +---+-----+
    %
    %
    % See also: https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/api/pyspark.sql.functions.desc.html
    
    % Copyright 2024-2026 MathWorks, Inc.

    arguments
        col {matlab.pyspark.internal.mustBeColType}
    end

    col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.desc(col));
end
