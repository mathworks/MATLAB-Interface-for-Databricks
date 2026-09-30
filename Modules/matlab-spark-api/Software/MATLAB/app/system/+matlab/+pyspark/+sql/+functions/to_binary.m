function newCol = to_binary(col, format)
    % TO_BINARY Converts the input col to a binary value based on the supplied format
    % The format can be a case-insensitive string literal of “hex”, “utf-8”, “utf8”,
    % or “base64”.
    % By default, the binary format for conversion is “hex” if format is omitted.
    % A scalar text format argument will be converted using matlab.pyspark.sql.functions.lit().
    %
    % Examples:
    %   % Convert string to binary with encoding specified
    %   df = spark.createDataFrame("abc", schema="e")
    %   df.select(matlab.pyspark.sql.functions.to_binary(df.e, matlab.pyspark.sql.functions.lit("utf-8")).alias('r')).collect()
    %   [Row(r=bytearray(b'abc'))]
    %
    %   % Convert string to binary with encoding specified
    %   df = spark.createDataFrame("abc", schema="e")
    %   df.select(matlab.pyspark.sql.functions.to_binary(df.e, "utf-8").alias('r')).collect()
    %   [Row(r=bytearray(b'abc'))]
    %
    %   % Convert string to binary without encoding specified
    %   df = spark.createDataFrame("414243", schema="e");
    %   df.select(matlab.pyspark.sql.functions.to_binary(df.e).alias('r')).collect()
    %   [Row(r=bytearray(b'ABC'))]

    % Copyright 2026 MathWorks, Inc.

    arguments (Input)
        col {matlab.pyspark.internal.mustBeColType}
        format {matlab.pyspark.internal.mustBeColType} = string.empty
    end

    col = matlab.pyspark.internal.unifyColArguments(col);
    
    if isempty(format)
        newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.to_binary(col));
    else
        if ischar(format)
            format = string(format);
        end
        if isStringScalar(format)
            format = matlab.pyspark.sql.functions.lit(format);
        end
        format = matlab.pyspark.internal.unifyColArguments(format);
        newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.to_binary(col, format));
    end
end
