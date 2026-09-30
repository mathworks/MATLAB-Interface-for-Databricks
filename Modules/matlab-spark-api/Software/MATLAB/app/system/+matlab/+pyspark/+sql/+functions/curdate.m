function newCol = curdate()
    % CURDATE Returns the current date at the start of query evaluation as a DateType column
    % All calls of current_date within the same query return the same value.
    %
    % Example:
    %   spark.range(1).select(matlab.pyspark.sql.functions.curdate()).show() 
    %   +--------------+
    %   |current_date()|
    %   +--------------+
    %   |    2026-04-29|
    %   +--------------+

    % Copyright 2026 MathWorks, Inc.

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.curdate());
end