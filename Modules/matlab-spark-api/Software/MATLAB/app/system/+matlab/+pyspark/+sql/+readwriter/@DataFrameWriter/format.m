function obj = format(obj, fmt)
    % FORMAT Method to specify the output data source format
    % The format method can be used to configure the DataFrameWriter to use an
    % appropriate source format.
    %
    % Built-in options include:
    %   json
    %   csv
    %   parquet
    % etc.
    %
    % For example:
    %
    %     myDataSet.write.format('parquet')...
    %         .save(outputLocation);
    %
    %
    % Please refer to corresponding pyspark documentation

    % Copyright 2024 MathWorks, Inc.
    arguments (Input)
        obj (1,1) matlab.pyspark.sql.readwriter.DataFrameWriter
        fmt (1,1) string
    end
    arguments (Output)
        obj   (1,1) matlab.pyspark.sql.readwriter.DataFrameWriter
    end

    obj.toPy.format(fmt);

end %function
