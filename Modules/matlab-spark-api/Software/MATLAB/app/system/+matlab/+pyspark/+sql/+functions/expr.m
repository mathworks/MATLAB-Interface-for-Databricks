function newCol = expr(str)
    % EXPR Parses the expression string into the column that it represents
    %
    % Examples:
    %   df = spark.createDataFrame(["Alice"; "Bob"], schema="name")
    %   df.select("*", matlab.pyspark.sql.functions.expr("length(name)")).show()
    %   +-----+------------+
    %   | name|length(name)|
    %   +-----+------------+
    %   |Alice|           5|
    %   |  Bob|           3|
    %   +-----+------------+

    % Copyright 2026 MathWorks, Inc.

    arguments (Input)
        str string
    end

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.expr(str));
end
