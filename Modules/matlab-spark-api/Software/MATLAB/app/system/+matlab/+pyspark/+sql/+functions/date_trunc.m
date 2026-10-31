function newCol = date_trunc(fmt, col)
    % date_trunc Returns timestamp truncated to the unit specified by the format.
    %
    % df = spark.createDataFrame(py.str("[('1997-02-28 05:02:11',)]"), schema="ts")
    % df.select('*', matlab.pyspark.sql.functions.date_trunc('year', df.ts)).show()
    % +-------------------+--------------------+
    % |                 ts|date_trunc(year, ts)|
    % +-------------------+--------------------+
    % |1997-02-28 05:02:11| 1997-01-01 00:00:00|
    % +-------------------+--------------------+
    %
    % df.select('*', matlab.pyspark.sql.functions.date_trunc('mon', 'ts')).show()
    % +-------------------+-------------------+
    % |                 ts|date_trunc(mon, ts)|
    % +-------------------+-------------------+
    % |1997-02-28 05:02:11|1997-02-01 00:00:00|
    % +-------------------+-------------------+

    % Copyright 2026 MathWorks, Inc.

    arguments (Input)
        fmt (1,1) string {mustBeNonzeroLengthText}
        col {matlab.pyspark.internal.mustBeColType}
    end
    arguments (Output)
        newCol (1,1) matlab.pyspark.sql.column.Column
    end

    col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.date_trunc(fmt, col));

end %function
