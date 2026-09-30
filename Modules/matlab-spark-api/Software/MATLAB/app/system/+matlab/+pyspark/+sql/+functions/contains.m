function newCol = contains(left, right)
    % CONTAINS The value is True if right is found inside left
    % Returns a boolean. Returns NULL if either input expression is NULL.
    % Otherwise, returns False. Both left or right must be of STRING or BINARY type.
    %
    % Examples:
    %   % df = spark.createDataFrame(py.str('[("Spark SQL", "Spark")]'), schema=["a", "b"]);
    %   % MATLAB string syntax
    %   df = spark.createDataFrame(["Spark SQL", "Spark"], schema=["a",
    %   "b"]);
    %   df.select(contains(df.a, df.b).alias('r')).collect()
    %   Row(r=True)
    %
    %
    %   df = spark.createDataFrame(py.str('[("414243", "4243",)]'), schema=["c", "d"])
    %   df = df.select(matlab.pyspark.sql.functions.to_binary("c").alias("c"), matlab.pyspark.sql.functions.to_binary("d").alias("d"))
    %   df.printSchema()
    %   df.select(matlab.pyspark.sql.functions.contains("c", "d"), matlab.pyspark.sql.functions.contains("d", "c")).show()
    %   +--------------+--------------+
    %   |contains(c, d)|contains(d, c)|
    %   +--------------+--------------+
    %   |          true|         false|
    %   +--------------+--------------+
    
    % Copyright 2026 MathWorks, Inc.

    arguments (Input)
        left {matlab.pyspark.internal.mustBeColType}
        right {matlab.pyspark.internal.mustBeColType}
    end

    left = matlab.pyspark.internal.unifyColArguments(left);
    right = matlab.pyspark.internal.unifyColArguments(right);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.contains(left, right));
end
