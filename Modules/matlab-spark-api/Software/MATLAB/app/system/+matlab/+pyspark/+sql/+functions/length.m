function newCol = length(col)
    % LENGTH Computes the character length of string data or number of bytes of binary data.
    % The length of character data includes the trailing spaces.
    % The length of binary data includes binary zeros.
    %
    % Example:
    %   spark.createDataFrame("ABC ", schema="a").select('*', matlab.pyspark.sql.functions.length('a')).show()
    %   +----+---------+
    %   |   a|length(a)|
    %   +----+---------+
    %   |ABC |        4|
    %   +----+---------+

    % Copyright 2026 MathWorks, Inc.

    arguments (Input)
        col {matlab.pyspark.internal.mustBeColType}
    end

    col = matlab.pyspark.internal.unifyColArguments(col);
    newCol = py.pyspark.sql.functions.length(col);
end