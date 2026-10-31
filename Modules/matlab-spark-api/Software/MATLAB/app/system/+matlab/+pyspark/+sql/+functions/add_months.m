function newCol = add_months(col, months)
    % add_months Add months to a column

    % Copyright 2024 MathWorks, Inc.


    arguments
        col (1,1) {matlab.pyspark.internal.mustBeColType}
        months (1,1)
    end

    classDays = string(class(months));
    if classDays == "matlab.pyspark.sql.column.Column" 
        months = months.toPy;
    elseif classDays == "py.pyspark.sql.connect.column.Column"
        % ok
    elseif isnumeric(months)
        months = int64(months);
    else
        error('SPARKAPI:FUNCTIONS_ADD_MONTHS', "Bad argument for add_months");
    end

    pyCol = py.pyspark.sql.functions.add_months(col.toPy, months);
    newCol = matlab.pyspark.sql.column.Column(pyCol);

end %function
