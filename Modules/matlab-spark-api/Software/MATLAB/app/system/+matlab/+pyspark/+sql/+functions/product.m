function newCol = product(col)
    % product Aggregate function: returns the product of the values in a group.
    %
    % df = spark.sql("SELECT id % 3 AS mod3, id AS value FROM RANGE(10)");
    % df.groupBy('mod3').agg(matlab.pyspark.sql.functions.product('value')).orderBy('mod3').show();

    % Copyright 2026 MathWorks, Inc.

    arguments
        col {matlab.pyspark.internal.mustBeColType}
    end

    col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.product(col));

end %function
