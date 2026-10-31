function df = sum(obj, col)
    % sum Computes the sum for each numeric columns for each group.

    % (c) 2024 MathWorks, Inc.

    arguments (Input)
        obj (1,1) matlab.pyspark.sql.group.GroupedData
    end
    arguments (Input, Repeating)
        col (1,1) string
    end
    arguments (Output)
        df (1,1) matlab.pyspark.sql.dataframe.Dataframe
    end

    df = matlab.pyspark.sql.dataframe.Dataframe(obj.toPy.sum(col{:}));

end
