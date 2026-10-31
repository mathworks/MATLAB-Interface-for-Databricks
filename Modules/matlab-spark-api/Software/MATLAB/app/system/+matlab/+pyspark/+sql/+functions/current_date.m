function newCol = current_date()
    %  current_date Current date
    
    % Copyright 2024 MathWorks, Inc.

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.current_date());

end %function
