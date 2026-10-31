function dfr = read(obj)
    % read  Get a DataFrameReader
    %
    % Please refer to corresponding pyspark documentation

    % (c) 2024 MathWorks, Inc.

    arguments (Input)
        obj (1,1) matlab.pyspark.sql.session.SparkSession
    end
    arguments (Output)
        dfr (1,1) matlab.pyspark.sql.readwriter.DataFrameReader
    end

    dfr = matlab.pyspark.sql.readwriter.DataFrameReader(obj.sparkSession.read);

end