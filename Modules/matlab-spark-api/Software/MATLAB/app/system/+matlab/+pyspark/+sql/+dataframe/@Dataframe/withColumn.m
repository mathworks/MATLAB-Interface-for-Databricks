function df = withColumn(obj, name, newCol)
    % withColumn - Add a new column

    % (c) 2024 MathWorks, Inc.

    arguments (Input)
        obj (1,1) matlab.pyspark.sql.dataframe.Dataframe
        name (1,1) string
        newCol (1,1) matlab.pyspark.internal.PyWrapper
    end
    arguments (Output)
        df (1,1) matlab.pyspark.sql.dataframe.Dataframe
    end

    df = matlab.pyspark.sql.dataframe.Dataframe(obj.toPy.withColumn(name, newCol.toPy));

end