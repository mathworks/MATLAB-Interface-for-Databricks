function df = withColumnRenamed(obj, oldName, newName)
    % WITHCOLUMNRENAMED Rename one column in dataframe
    %

    % Copyright 2024 MathWorks, Inc.

    arguments (Input)
        obj     (1,1) matlab.pyspark.sql.dataframe.Dataframe
        oldName (1,1) string
        newName (1,1) string
    end
    arguments (Output)
        df (1,1) matlab.pyspark.sql.dataframe.Dataframe
    end

    df = matlab.pyspark.sql.dataframe.Dataframe( obj.toPy.withColumnRenamed(oldName, newName));

end %function
