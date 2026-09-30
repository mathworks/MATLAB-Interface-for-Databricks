function newCol = date_sub(col, days)
    % date_sub Sbutract days from a column

    % Copyright 2024 MathWorks, Inc.


    arguments
        col (1,1) {matlab.pyspark.internal.mustBeColType}
        days (1,1)
    end

    classDays = string(class(days));
    if classDays == "matlab.pyspark.sql.column.Column" 
        days = days.toPy;
    elseif classDays == "py.pyspark.sql.connect.column.Column"
        % ok
    elseif isnumeric(days)
        days = int64(days);
    else
        error('SPARKAPI:FUNCTIONS_DATE_SUB', "Bad argument for date_sub");
    end

    pyCol = py.pyspark.sql.functions.date_sub(col.toPy, days);
    newCol = matlab.pyspark.sql.column.Column(pyCol);

end %function
