function newCol = current_timestamp()
    % CURRENT_TIMESTAMP Returns the current timestamp at the start of query evaluation as a TimestampType column
    % All calls of current_timestamp within the same query return the same value.
    %
    % Example:
    %   spark.range(1).select(matlab.pyspark.sql.functions.current_timestamp()).show()
    %   +-------------------+
    %   |current_timestamp()|
    %   +-------------------+
    %   |2026-04-29 10:56:08|
    %   +-------------------+
    
    % Copyright 2024-2026 MathWorks, Inc.

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.current_timestamp());
end
