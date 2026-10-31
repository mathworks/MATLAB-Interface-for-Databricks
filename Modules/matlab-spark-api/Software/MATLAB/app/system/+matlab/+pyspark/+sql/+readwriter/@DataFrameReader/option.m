function obj = option(obj, key, value)
    % OPTION Method to specify input options for the underlying data source
    % The configuration of the underlying input options control how the data
    % source is handled.
    % 
    % For example, to indicate that the input CSV has a header lines and is
    % clean enough to infer the schema:
    % 
    %     myDataSet = spark...
    %         .read.format('csv')...
    %         .option('header','true')...
    %         .option('inferSchema','true')...
    %         .load(inputLocation);


    %  Copyright 2024 MathWorks, Inc.

    arguments (Input)
        obj   (1,1) matlab.pyspark.sql.readwriter.DataFrameReader
        key   (1,1) string
        value (1,1) string
    end
    arguments (Output)
        obj (1,1) matlab.pyspark.sql.readwriter.DataFrameReader
    end
    
    obj.toPy.option(key, value);

end 
