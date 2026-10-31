function newCol = pi()
    % PI Returns Pi
    %
    % Example:
    %   spark.range(1).select(matlab.pyspark.sql.functions.pi()).show()
    %   +-----------------+
    %   |             PI()|
    %   +-----------------+
    %   |3.141592653589793|
    %   +-----------------+

    % Copyright 2026 MathWorks, Inc.

    arguments (Output)
        newCol (1,1) matlab.pyspark.sql.column.Column
    end

    newCol = py.pyspark.sql.functions.pi();
end