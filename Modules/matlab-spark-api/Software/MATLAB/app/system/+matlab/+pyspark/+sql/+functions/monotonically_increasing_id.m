function newCol = monotonically_increasing_id()
    % monotonically_increasing_id Monotonically increasing ID
    %
    % Add something to this if necessary
    
    % Copyright 2024 MathWorks, Inc.

    arguments (Output)
        newCol (1,1) matlab.pyspark.sql.column.Column
    end

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.monotonically_increasing_id());

end %function
