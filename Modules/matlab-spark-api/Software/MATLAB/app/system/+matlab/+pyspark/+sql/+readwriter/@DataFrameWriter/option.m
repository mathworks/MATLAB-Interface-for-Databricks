function obj = option(obj, key, value)
    % OPTION Method to specify options for writer
    %
    % Built-in options include:
    % "mode": append | overwrite | ignore | error or errorifexists
    % "mode": SaveMode.Overwrite | SaveMode.Append | SaveMode.Ignore | SaveMode.ErrorIfExists
    % "path": "path_to_write_to"
    % For example:
    %
    %     myDataSet.write.format('parquet')...
    %         .option("mode", "overwrite") ...
    %         .save(outputLocation);
    %
    % Please note: If using the saveAsTable method, please use the mode
    % method on the DataFrameWriter object, as saveAsTable doesn't use
    % options.
    %
    % See also mode

    %  Copyright 2024 MathWorks, Inc.

    arguments (Input)
        obj   (1,1) matlab.pyspark.sql.readwriter.DataFrameWriter
        key   (1,1) string
        value (1,1) string
    end
    arguments (Output)
        obj   (1,1) matlab.pyspark.sql.readwriter.DataFrameWriter
    end

    obj.toPy.option(key, value);

end %function
