function newCol = min(col)
    % min Minimum value
    
    % Copyright 2024 MathWorks, Inc.

    arguments (Input)
        col {matlab.pyspark.internal.mustBeColType}
    end
    arguments (Output)
        newCol (1,1) matlab.pyspark.sql.column.Column
    end

    col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.min(col));

end %function
