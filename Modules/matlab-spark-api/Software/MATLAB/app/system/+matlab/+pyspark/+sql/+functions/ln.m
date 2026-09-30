function newCol = ln(col)
    % LN Returns the natural logarithm of the argument
    %
    % Example:
    %   spark.range(10).select("*", matlab.pyspark.sql.functions.ln('id')).show()

    % Copyright 2026 MathWorks, Inc.

    arguments (Input)
        col {matlab.pyspark.internal.mustBeColType}
    end

    arguments (Output)
        newCol (1,1) matlab.pyspark.sql.column.Column
    end

    col = matlab.pyspark.internal.unifyColArguments(col);
    newCol = py.pyspark.sql.functions.ln(col);
end