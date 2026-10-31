function obj = format(obj, fmt)
    % FORMAT Method to specify the input data source format
    % The format method can be used to configure the DataFrameReader to use an
    % appropriate source format.
    %
    % Please refer to corresponding pyspark documentation

    % Copyright 2024 MathWorks, Inc.

    arguments (Input)
        obj (1,1) matlab.pyspark.sql.readwriter.DataFrameReader
        fmt (1,1) string
    end
    arguments (Output)
        obj (1,1) matlab.pyspark.sql.readwriter.DataFrameReader
    end

    obj.dataFrameReader.format(fmt);

end %function
