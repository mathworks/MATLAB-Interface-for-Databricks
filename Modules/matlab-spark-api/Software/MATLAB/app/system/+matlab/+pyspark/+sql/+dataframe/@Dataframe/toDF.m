function df = toDF(obj, cols)
    % toDF - Rename columns of a Dataframe

    % (c) 2024 MathWorks, Inc.

    arguments (Input)
        obj (1,1) matlab.pyspark.sql.dataframe.Dataframe
        cols string
    end
    arguments (Output)
        df (1,1) matlab.pyspark.sql.dataframe.Dataframe
    end
    args = cellstr(cols);

    df = matlab.pyspark.sql.dataframe.Dataframe(obj.toPy.toDF(args{:}));

end