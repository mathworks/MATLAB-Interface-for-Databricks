function newCol = current_timezone()
    % CURRENT_TIMEZONE Returns the current session local timezone
    %
    % Example:
    %   spark.range(1).select(matlab.pyspark.sql.functions.current_timezone()).show()
    %   +------------------+
    %   |current_timezone()|
    %   +------------------+
    %   |           Etc/UTC|
    %   +------------------+

    % Copyright 2026 MathWorks, Inc.

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.current_timezone());
end