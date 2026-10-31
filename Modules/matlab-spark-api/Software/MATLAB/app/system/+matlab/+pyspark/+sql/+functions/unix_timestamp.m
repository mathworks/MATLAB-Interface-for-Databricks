function newCol = unix_timestamp(col, fmt)
    % unix_timestamp Convert column to timestamp

    % Copyright 2024 MathWorks, Inc.

    switch nargin
        case 0
            newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.unix_timestamp());
        case 1
            col = matlab.pyspark.internal.unifyColArguments(col);
            newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.unix_timestamp(col));
        otherwise
            col = matlab.pyspark.internal.unifyColArguments(col);
            mustBeTextScalar(fmt);
            newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.unix_timestamp(col, fmt));
    end

end %function
