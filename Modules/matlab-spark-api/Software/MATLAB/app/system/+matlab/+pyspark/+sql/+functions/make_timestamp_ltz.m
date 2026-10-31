function newCol = make_timestamp_ltz(options)
    % make_timestamp_ltz Create a timestamp column
    % 
    % This function exclusively uses named arguments. Any errors due to
    % using invalid combinations, e.g. 'date' and 'year', will be handled
    % by the underlying Spark libraries
    %
    % Example:
    % data = {...
    %     {2023, 1, 2, 14, 20, 12.345, 'UTC'};...
    %     {2023, 1, 2, 14, 20, 12.345, 'America/New_York'};...
    %     {2023, 1, 2, 14, 20, 12.345, 'Europe/Berlin'};...
    %     {2023, 1, 2, 14, 20, 12.345, 'Asia/Calcutta'}...
    %     };
    % columns = {'year', 'month', 'day', 'hour', 'min', 'sec', 'tz'};
    % df = spark.createDataFrame(data, schema=columns);
    % df = df.withColumn("ts_no_tz", matlab.pyspark.sql.functions.make_timestamp_ntz(years="year", month="month", days="day", hours="hour", mins="min", secs="sec"));
    % df = df.withColumn("ts_with_tz", matlab.pyspark.sql.functions.make_timestamp_ltz(years="year", month="month", days="day", hours="hour", mins="min", secs="sec", timezone="tz"));
    % df.show(10, false)
    %
    % See also https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/api/pyspark.sql.functions.make_timestamp_ltz.html

    % Copyright 2026 MathWorks, Inc.

    arguments
        options.years (1,1) {matlab.pyspark.internal.mustBeColType}
        options.months (1,1) {matlab.pyspark.internal.mustBeColType}
        options.days (1,1) {matlab.pyspark.internal.mustBeColType}
        options.hours (1,1) {matlab.pyspark.internal.mustBeColType}
        options.mins (1,1) {matlab.pyspark.internal.mustBeColType}
        options.secs (1,1) {matlab.pyspark.internal.mustBeColType}
        options.timezone (1,1) {matlab.pyspark.internal.mustBeColType}
    end

    args = matlab.utils.addArgs(options, ["years", "months", "days", "hours", "mins", "secs", "timezone"]);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.make_timestamp_ltz(pyargs(args{:})));
end
