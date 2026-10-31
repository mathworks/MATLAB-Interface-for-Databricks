function newCol = from_utc_timestamp(col, tz)
    % from_utc_timestamp Convert time/date from UTC to TZ
    
    % Copyright 2024 MathWorks, Inc.

    arguments
        col {matlab.pyspark.internal.mustBeColType}
        tz {matlab.pyspark.internal.mustBeColType}
    end

    col = matlab.pyspark.internal.unifyColArguments(col);
    tz = matlab.pyspark.internal.unifyColArguments(tz);
    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.from_utc_timestamp(col, tz));

end %function
