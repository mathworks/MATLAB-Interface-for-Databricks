function newCol = array_min(col)
    % ARRAY_MIN Returns the minimum value of the array
    %
    % Examples:
    %   % Basic usage with integer array
    %   df = spark.createDataFrame(py.str('[([2, 1, 3],), ([None, 10, -1],)]'), schema="data")
    %   df.select(matlab.pyspark.sql.functions.array_min(df.data)).show()
    %   +---------------+
    %   |array_min(data)|
    %   +---------------+
    %   |              1|
    %   |             -1|
    %   +---------------+
    %
    %   % Usage with string array
    %   df = spark.createDataFrame(py.str("[(['apple', 'banana', 'cherry'],)]"), schema="data")
    %   df.select(matlab.pyspark.sql.functions.array_min(df.data)).show()
    %   +---------------+
    %   |array_min(data)|
    %   +---------------+
    %   |          apple|
    %   +---------------+
    %
    %   % Usage with mixed type array
    %   df = spark.createDataFrame(py.str("[(['apple', 1, 'cherry'],)]"), schema='data')
    %   df.select(matlab.pyspark.sql.functions.array_min(df.data)).show()
    %   +---------------+
    %   |array_min(data)|
    %   +---------------+
    %   |              1|
    %   +---------------+
    %
    %   % Usage with array of arrays
    %   df = spark.createDataFrame(py.str("[([[2, 1], [3, 4]],)]"), schema='data')
    %   df.select(matlab.pyspark.sql.functions.array_min(df.data)).show()
    %   +---------------+
    %   |array_min(data)|
    %   +---------------+
    %   |         [2, 1]|
    %   +---------------+

    % Copyright 2026 MathWorks, Inc.

    arguments (Input)
        col {matlab.pyspark.internal.mustBeColType}
    end

    col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.array_min(col));
end
