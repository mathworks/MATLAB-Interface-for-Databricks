function df = range(obj, start, arg)
    % range - Return a dataframe range
    %
    % obj, start, end_, step, numPartitions

    % (c) 2024 MathWorks, Inc.

    arguments (Input)
        obj (1,1) matlab.pyspark.sql.session.SparkSession
        start (1,1) int64
    end
    arguments (Input, Repeating)
        arg int64
    end
    arguments (Output)
        df (1,1) matlab.pyspark.sql.dataframe.Dataframe
    end

    df = matlab.pyspark.sql.dataframe.Dataframe(obj.sparkSession.range(start, arg{:}));
end