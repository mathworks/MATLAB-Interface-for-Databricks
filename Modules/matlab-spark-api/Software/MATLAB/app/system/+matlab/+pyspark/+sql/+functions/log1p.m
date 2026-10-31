function newCol = log1p(col)
    % LOG1P Natural logarithm of col plus 1
    %
    % Examples:
    %   spark.range(1).select(matlab.pyspark.sql.functions.log1p(matlab.pyspark.sql.functions.e())).show()
    %
    %   % Same as:
    %   spark.range(1).select(matlab.pyspark.sql.functions.log(matlab.pyspark.sql.functions.e() + 1)).show()

    % Copyright 2026 MathWorks, Inc.

    arguments (Input)
        col {matlab.pyspark.internal.mustBeColType}
    end

    arguments (Output)
        newCol (1,1) matlab.pyspark.sql.column.Column
    end

    col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = py.pyspark.sql.functions.log1p(col);
end