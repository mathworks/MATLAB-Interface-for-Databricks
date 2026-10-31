function newCol = log(arg1, arg2)
    % LOG Returns the first argument-based logarithm of the second argument
    % If there is only one argument, then this takes the natural logarithm of
    % the argument.
    %
    % Arguments:
    %   arg1: Column, text or numeric
    %   base number or actual number (in this case base is e)
    %
    %   arg2: Column, text or numeric, optional
    %   number to calculate logarithm for
    %
    % Examples:
    %   df = spark.sql("SELECT * FROM VALUES (1), (2), (4) AS t(value)")
    %   df.select("*", matlab.pyspark.sql.functions.log(2.0, df.value)).show()
    %   +-----+---------------+
    %   |value|LOG(2.0, value)|
    %   +-----+---------------+
    %   |    1|            0.0|
    %   |    2|            1.0|
    %   |    4|            2.0|
    %   +-----+---------------+
    %
    %   df = spark.sql("SELECT * FROM VALUES (1), (2), (0), (-1), (NULL) AS t(value)")
    %   df.select("*", matlab.pyspark.sql.functions.log(3.0, df.value)).show()
    %   +-----+------------------+
    %   +-----+------------------+
    %   |value|   LOG(3.0, value)|
    %   +-----+------------------+
    %   |    1|               0.0|
    %   |    2|0.6309297535714575|
    %   |    0|              NULL|
    %   |   -1|              NULL|
    %   | NULL|              NULL|
    %   +-----+------------------+
    %
    %   df = spark.sql("SELECT * FROM VALUES (1), (2), (4) AS t(value)")
    %   df.select("*", matlab.pyspark.sql.functions.log(df.value)).show()
    %   +-----+------------------+
    %   |value|         ln(value)|
    %   +-----+------------------+
    %   |    1|               0.0|
    %   |    2|0.6931471805599453|
    %   |    4|1.3862943611198906|
    %   +-----+------------------+

    % Copyright 2026 MathWorks, Inc.

    arguments (Input)
        arg1 {matlab.pyspark.internal.mustBeColFloatType}
        arg2 {matlab.pyspark.internal.mustBeColFloatType} = string.empty
    end

    arg1 = matlab.pyspark.internal.unifyColArguments(arg1);

    if isstring(arg2) && isempty(arg2)
        newCol = py.pyspark.sql.functions.log(arg1);
    else
        arg2 = matlab.pyspark.internal.unifyColArguments(arg2);
        newCol = py.pyspark.sql.functions.log(arg1, arg2);
    end
end