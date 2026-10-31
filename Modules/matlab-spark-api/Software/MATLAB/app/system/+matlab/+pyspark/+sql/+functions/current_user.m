function newCol = current_user()
    % CURRENT_TIMEZONE Returns the current user
    %
    % Example:
    %   spark.range(1).select(matlab.pyspark.sql.functions.current_user()).show()
    %   +--------------------+
    %   |      current_user()|
    %   +--------------------+
    %   |     joe@example.com|
    %   +--------------------+

    % Copyright 2026 MathWorks, Inc.

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.current_user());
end