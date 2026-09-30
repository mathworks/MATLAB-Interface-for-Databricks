function df = limit(obj, limitNum)
    % limit - Limit size of dataframe

    % (c) 2024 MathWorks, Inc.

    arguments (Input)
        obj (1,1) matlab.pyspark.sql.dataframe.Dataframe
        limitNum (1,1) int64 {mustBePositive}
    end
    arguments (Output)
        df (1,1) matlab.pyspark.sql.dataframe.Dataframe
    end

    df = matlab.pyspark.sql.dataframe.Dataframe(obj.toPy.limit(limitNum));
end