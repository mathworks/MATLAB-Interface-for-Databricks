function df = count(obj)
    % count Counts the number of records for each group.

    % (c) 2024 MathWorks, Inc.

    arguments (Input)
        obj (1,1) matlab.pyspark.sql.group.GroupedData
    end
    arguments (Output)
        df (1,1) matlab.pyspark.sql.dataframe.Dataframe
    end

    df = matlab.pyspark.sql.dataframe.Dataframe(obj.toPy.count());

end
