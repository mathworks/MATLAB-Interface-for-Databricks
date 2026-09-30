function newCol = e()
    % E Returns Euler’s number
    %
    % Example:
    %   spark.range(1).select(matlab.pyspark.sql.functions.e()).show()
    %   +-----------------+
    %   |              E()|
    %   +-----------------+
    %   |2.718281828459045|
    %   +-----------------+

    % Copyright 2026 MathWorks, Inc.

    arguments (Output)
        newCol (1,1) matlab.pyspark.sql.column.Column
    end

    newCol = py.pyspark.sql.functions.e();
end