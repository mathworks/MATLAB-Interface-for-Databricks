function newCol = percent_rank()
    % percent_rank Creates a percent_rank column
    %
    % import matlab.pyspark.sql.Window
    % df = spark.createDataFrame('[1, 1, 2, 3, 3, 4]', schema='value');
    % w = Window.orderBy("value");
    % df.withColumn("pr", matlab.pyspark.sql.functions.percent_rank().over(w)).show()
    
    % Copyright 2026 MathWorks, Inc.

    arguments (Output)
        newCol (1,1) matlab.pyspark.sql.column.Column
    end

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.percent_rank());

end %function
