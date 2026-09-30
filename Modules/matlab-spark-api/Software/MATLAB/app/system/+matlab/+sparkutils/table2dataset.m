function ds = table2dataset( T, spark, options )
    % TABLE2DATASET Function to create Spark dataset from MATLAB table
    %
    % It takes as arguments a MATLAB table, the spark session reference, and
    % an optional schema object, and converts the table into a Dataset object.
    %
    % This function should be used for tests, not for large tables.
    %
    % To use it, at least a table and a spark session are needed:
    %
    %   dataset = matlab.sparkutils.table2dataset(matlabTable, sparkSession);
    %
    % When the optional third input argument (schema) is not provided, the
    % Column data types are automatically mapped as follows (also see the 
    % createSparkSchemaFromMatlabType in the functions folder):
    %
    %   MATLAB            Spark     Notes
    %   ======            ======    =====
    %   char              String    converting back to MATLAB results in string, not char
    %   string            String    <missing> value interpreted as the String \0
    %   double            Double
    %   single            Float
    %   int8              Byte
    %   int16             Short
    %   int32             Integer
    %   int64             Long
    %   logical           Boolean
    %   struct            Struct
    %   table             Struct    converting back to MATLAB results in struct, not table
    %   containers.Map    Map
    %   cell              WrappedArray
    %   datetime          Timestamp
    %   duration          CalendarInterval
    %   (any other type)  *** NOT SUPPORTED ***
    %
    % An optional third argument (schema) can also be specified. This is useful
    % when a schema object is already available, for example the schema of a
    % pre-existing Spark dataset.
    %
    %   dataset = spark.read.format("parquet").load("/my/files")
    %   T = table(dataset);
    %   T = runAlgorithm(T);
    %   schema = dataset.schema;
    %   dataset = matlab.sparkutils.table2dataset(matlabTable, sparkSession, schema);
    %
    % The optional schema argument can also be specified as a cell-array of
    % chars or a string array, representing case-insensitive column data types.
    % Only the following basic data types are supported:
    %
    %   string or char, double, single or float, int8 or byte, int16 or short,
    %   int32 or int or integer, int64 or long, logical or boolean, duration,
    %   datetime or timestamp.
    %
    % This list does not include complex data types such as struct, map,
    % or table. If your data contains such data types, either use the 2-inputs
    % variant of this function in order to auto-generate the schema, or use a
    % schema-object from a pre-existing dataset object.
    
    % TODO: implement & use MATLAB schema wrapper class

    % Copyright 2020-2025 MathWorks, Inc.

    arguments
        T table
        spark (1,1) matlab.pyspark.sql.session.SparkSession
        options.schema 
    end

    % TODO: schema currently not supported

    % Imposed by py.pandas.DataFrame
    if isMATLABReleaseOlderThan("R2024a")
        error('PYSPARK:TABLE2DATASET:UNSUPPORTED_RELEASE', "table2dataset is supported in MATLAB R2024a and greater.");
    end

    df = spark.toPy.createDataFrame(py.pandas.DataFrame(T));
    ds = matlab.pyspark.sql.dataframe.Dataframe(df);
end
