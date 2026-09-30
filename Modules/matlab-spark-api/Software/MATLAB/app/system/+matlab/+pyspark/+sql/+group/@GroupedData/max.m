function df = max(obj, col)
    % max Computes the maximum for each numeric columns for each group.

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

    df = matlab.pyspark.sql.dataframe.Dataframe(obj.toPy.max(col{:}));

end
