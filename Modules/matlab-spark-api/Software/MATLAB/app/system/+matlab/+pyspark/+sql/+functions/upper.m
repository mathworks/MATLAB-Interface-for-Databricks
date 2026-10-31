function newCol = upper(col)
    % upper Converts a string expression to upper case.
    %
    % Example:
    %   df = spark.createDataFrame(["Spark"; "PySpark"; "Pandas API"], schema="STRING");
    %   df.select("*", matlab.pyspark.sql.functions.upper("STRING")).show()
    %   +----------+-------------+
    %   |    STRING|upper(STRING)|
    %   +----------+-------------+
    %   |     Spark|        SPARK|
    %   |   PySpark|      PYSPARK|
    %   |Pandas API|   PANDAS API|
    %   +----------+-------------+
    
    % Copyright 2026 MathWorks, Inc.

    arguments (Input)
        col {matlab.pyspark.internal.mustBeColType}
    end
    arguments (Output)
        newCol matlab.pyspark.sql.column.Column
    end

    col = matlab.pyspark.internal.unifyColArguments(col);
    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.upper(col));
end
