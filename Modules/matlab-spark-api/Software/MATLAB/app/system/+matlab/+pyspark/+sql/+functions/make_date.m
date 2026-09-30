function newCol = make_date(year, month, day)
    % make_date Create date column
    
    % Copyright 2024 MathWorks, Inc.

    arguments (Input)
        year {matlab.pyspark.internal.mustBeColType}
        month {matlab.pyspark.internal.mustBeColType}
        day {matlab.pyspark.internal.mustBeColType}
    end

    arguments (Output)
        newCol (1,1) matlab.pyspark.sql.column.Column
    end
  % col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.make_date(year.toPy, month.toPy, day.toPy));

end %function
