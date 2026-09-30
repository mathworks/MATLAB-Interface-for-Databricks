function newCol = date_add(col, days)
    % date_add Add days to a column

    % Copyright 2024 MathWorks, Inc.


    arguments (Input)
        col (1,1) {matlab.pyspark.internal.mustBeColType}
        days (1,1)
    end
    arguments (Output)
        newCol (1,1) matlab.pyspark.sql.column.Column
    end

    classDays = string(class(days));
    if classDays == "matlab.pyspark.sql.column.Column" 
        days = days.toPy;
    elseif classDays == "py.pyspark.sql.connect.column.Column"
        % ok
    elseif isnumeric(days)
        days = int64(days);
    else
        error('SPARKAPI:FUNCTIONS_DATE_ADD', "Bad argument for date_add");
    end

    pyCol = py.pyspark.sql.functions.date_add(col.toPy, days);
    newCol = matlab.pyspark.sql.column.Column(pyCol);

end %function
