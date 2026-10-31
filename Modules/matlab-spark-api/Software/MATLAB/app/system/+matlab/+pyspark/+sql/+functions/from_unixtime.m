function newCol = from_unixtime(col, fmt)
    % from_unixtime Convert column from unix time
    
    % Copyright 2024 MathWorks, Inc.

    col = matlab.pyspark.internal.unifyColArguments(col);

    switch nargin
        case 1
            newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.from_unixtime(col));
        otherwise
            mustBeTextScalar(fmt);
            newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.from_unixtime(col, fmt));
    end

end %function
