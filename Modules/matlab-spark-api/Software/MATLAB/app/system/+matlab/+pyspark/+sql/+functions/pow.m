function newCol = pow(col1, col2)
    %  pow Power function
    
    % Copyright 2024 MathWorks, Inc.

    arguments
        col1 {matlab.pyspark.internal.mustBeColFloatType}
        col2 {matlab.pyspark.internal.mustBeColFloatType}
    end

    col1 = matlab.pyspark.internal.unifyColArguments(col1);
    col2 = matlab.pyspark.internal.unifyColArguments(col2);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.pow(col1, col2));
end
