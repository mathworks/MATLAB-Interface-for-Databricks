function col = when(obj, condition, value)
    % when condition/value choice

    % Copyright 2024 MathWorks, Inc.

    arguments (Input)
        obj (1,1) matlab.pyspark.sql.column.Column
        condition (1,1) matlab.pyspark.sql.column.Column
        value(1,1) 
    end
    arguments (Output)
        col (1,1) matlab.pyspark.sql.column.Column
    end

    col = matlab.pyspark.sql.column.Column(obj.toPy.when(condition.toPy, value));

end
