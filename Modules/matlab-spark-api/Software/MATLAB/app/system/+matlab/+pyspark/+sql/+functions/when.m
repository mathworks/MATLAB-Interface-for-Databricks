function col = when(condition, value)
    % when condition/value choice

    % Copyright 2024 MathWorks, Inc.

    arguments
        condition (1,1) matlab.pyspark.sql.column.Column
        value (1,1) 
    end

    if isa(value, 'matlab.pyspark.internal.PyWrapper')
        value = value.toPy;
    end

    col = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.when(condition.toPy, value));

end
