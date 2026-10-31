function newCol = array(col)
    % array Concatenate columns to an array
    
    % Copyright 2024 MathWorks, Inc.

    arguments (Input, Repeating)
        col {matlab.pyspark.internal.mustBeColType}
    end

    arguments (Output)
        newCol (1,1) matlab.pyspark.sql.column.Column
    end

    col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.array(col));

end %function
