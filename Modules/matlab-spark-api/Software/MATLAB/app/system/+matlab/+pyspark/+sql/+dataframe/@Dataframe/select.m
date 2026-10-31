function df = select(obj, arg)
    % SELECT Method to select columns by name
    %
    % SELECT(obj,columns) will return a new dataset that contains only the
    % Example:
    %
    %     % Create a dataset
    %     myLocation = '/test/*.parquet');
    %     myDataSet = spark...
    %         .read.format('parquet')...
    %         .option('header','true')...
    %         .option('inferSchema','true')...
    %         .load(myLocation);
    %
    %     % Select a subset of the Dataset with just a few columns
    %     newDataSet = myDataSet.select("UniqueCarrier", "Day", "Month");
    %

    % Copyright 2024 MathWorks, Inc.

    arguments (Input)
        obj (1,1) matlab.pyspark.sql.dataframe.Dataframe
    end
    arguments (Input, Repeating)
        arg {matlab.pyspark.internal.mustBeColType}
    end
    arguments (Output)
        df (1,1) matlab.pyspark.sql.dataframe.Dataframe
    end
    
    arg = matlab.pyspark.internal.unifyColArguments(arg);

    df = matlab.pyspark.sql.dataframe.Dataframe(obj.toPy.select(arg{:}));

end 

