function newCol = hex(col)
    % HEX Computes hex value of the given column
    %
    % Examples:
    %   % Compute the hex
    %   df = spark.createDataFrame(py.str("[('ABC', 3)]"), schema=["a", "b"]);
    %   df.select('*', matlab.pyspark.sql.functions.hex('a'), matlab.pyspark.sql.functions.hex(df.b)).show()
    %   +---+---+------+------+
    %   |  a|  b|hex(a)|hex(b)|
    %   +---+---+------+------+
    %   |ABC|  3|414243|     3|
    %   +---+---+------+------+
    
    % Copyright 2026 MathWorks, Inc.

    arguments
        col {matlab.pyspark.internal.mustBeColType}
    end

    col = matlab.pyspark.internal.unifyColArguments(col);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.hex(col));
end
