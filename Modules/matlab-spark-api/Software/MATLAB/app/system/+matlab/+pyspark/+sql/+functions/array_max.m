function newCol = array_max(col)
    % ARRAY_MAX Returns the maximum value of the array
    %
    % Examples:
    %   % Basic usage with integer array
    %   df = spark.createDataFrame(py.str('[([2, 1, 3],), ([None, 10, -1],)]'), schema="data")
    %   df.select(matlab.pyspark.sql.functions.array_max(df.data)).show()
    %   +---------------+
    %   |array_max(data)|
    %   +---------------+
    %   |              3|
    %   |             10|
    %   +---------------+
    %
    %   % Usage with string array
    %   df = spark.createDataFrame(py.str("[(['apple', 'banana', 'cherry'],)]"), schema="data")
    %   df.select(matlab.pyspark.sql.functions.array_max(df.data)).show()
    %   +---------------+
    %   |array_max(data)|
    %   +---------------+
    %   |         cherry|
    %   +---------------+
    %
    %   % Usage with mixed type array
    %   df = spark.createDataFrame(py.str("[(['apple', 1, 'cherry'],)]"), schema='data')
    %   df.select(matlab.pyspark.sql.functions.array_max(df.data)).show()
    %   +---------------+
    %   |array_max(data)|
    %   +---------------+
    %   |         cherry|
    %   +---------------+
    %
    %   % Usage with array of arrays
    %   df = spark.createDataFrame(py.str("[([[2, 1], [3, 4]],)]"), schema='data')
    %   df.select(matlab.pyspark.sql.functions.array_max(df.data)).show()
    %   +---------------+
    %   |array_max(data)|
    %   +---------------+
    %   |         [3, 4]|
    %   +---------------+

    % Copyright 2026 MathWorks, Inc.

    arguments (Input)
        col {matlab.pyspark.internal.mustBeColType}
    end

    col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.array_max(col));
end
