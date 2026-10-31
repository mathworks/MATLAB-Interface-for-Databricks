function obj = schema(obj, schemaInfo)
    % SCHEMA Specify the schema to be used when loading data.
    %
    % For example, to indicate that the input CSV has a header lines and is
    % clean enough to infer the schema:
    %
    %     myDataSet = spark...
    %         .read.format('json')...
    %         .schema("`time` TIMESTAMP, `action` STRING") ...
    %         .load(inputLocation);

    % Copyright 2024 MathWorks, Inc.

    arguments (Input)
        obj (1,1) matlab.pyspark.sql.readwriter.DataFrameReader
        schemaInfo (1,1) string
    end
    arguments (Output)
        obj (1,1) matlab.pyspark.sql.readwriter.DataFrameReader
    end

    obj.toPy.schema(schemaInfo);

end 
