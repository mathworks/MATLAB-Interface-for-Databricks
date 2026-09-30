function newCol = spark_partition_id()
    % spark_partition_id Creates a spark_partition_id column
    %
    % spark.range(0,10,1,5).select("*", matlab.pyspark.sql.functions.spark_partition_id()).show()

    % Copyright 2026 MathWorks, Inc.

    arguments (Output)
        newCol (1,1) matlab.pyspark.sql.column.Column
    end

    newCol = py.pyspark.sql.functions.spark_partition_id();

end %function
