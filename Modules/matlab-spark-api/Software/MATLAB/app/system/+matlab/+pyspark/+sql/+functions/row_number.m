function newCol = row_number()
    % row_number Creates a row_number column
    %
    % import matlab.pyspark.sql.Window    
    % df = spark.range(3)
    % w = Window.orderBy(df.id.desc())
    % df.withColumn("desc_order", matlab.pyspark.sql.functions.row_number().over(w)).show()

    % Copyright 2026 MathWorks, Inc.

    arguments (Output)
        newCol (1,1) matlab.pyspark.sql.column.Column
    end

    newCol = py.pyspark.sql.functions.row_number();

end %function
