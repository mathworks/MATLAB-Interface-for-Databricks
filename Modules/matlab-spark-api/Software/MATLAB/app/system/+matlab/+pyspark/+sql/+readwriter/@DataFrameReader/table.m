function ds = table(obj, tableName)
    % TABLE Use DataFrameReader to get a table from Spark
    %
    % TABLE(obj, "my_table") will return a new dataset from the
    % corresponding Spark table.
    %

    % Copyright 2024 MathWorks, Inc.

    arguments (Input)
        obj (1,1) matlab.pyspark.sql.readwriter.DataFrameReader
        tableName (1,1) string
    end
    arguments (Output)
        ds (1,1) matlab.pyspark.sql.dataframe.Dataframe
    end

    try
        pyDataset = obj.toPy.table(tableName);
    catch err
        error('SPARK:ERROR', 'Spark error: %s', err.message);
    end
    
    ds = matlab.pyspark.sql.dataframe.Dataframe(pyDataset);

end %function
