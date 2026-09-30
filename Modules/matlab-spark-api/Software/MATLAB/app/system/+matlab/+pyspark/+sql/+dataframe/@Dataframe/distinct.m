function df = distinct(obj)
    % distinct - Returns a new DataFrame containing the distinct rows in this DataFrame.
    %

    % (c) 2024 MathWorks, Inc.

    arguments (Input)
        obj (1,1) matlab.pyspark.sql.dataframe.Dataframe
    end
    arguments (Output)
        df (1,1) matlab.pyspark.sql.dataframe.Dataframe
    end

    df = matlab.pyspark.sql.dataframe.Dataframe(obj.toPy.distinct());

end