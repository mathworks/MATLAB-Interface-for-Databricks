function newCol = column(colName)
    % column Return a column from a name

    % Copyright 2024 MathWorks, Inc.

    arguments
        colName (1,1) {mustBeTextScalar}
    end

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.column(colName));

end %function
