function newCol = atan2(col1, col2)
    % ATAN2 Compute the angle in radians between the positive x-axis of a plane and the point given by the coordinates
    %
    % Example:
    %   spark.range(1).select(py.pyspark.sql.functions.atan2(...
    %       py.pyspark.sql.functions.lit(1),...
    %       py.pyspark.sql.functions.lit(2))).show()
    %
    %   +------------------+
    %   |   ATAN2(1.0, 2.0)|
    %   +------------------+
    %   |0.4636476090008061|
    %   +------------------+

    % Copyright 2026 MathWorks, Inc.

    arguments
        col1 {matlab.pyspark.internal.mustBeColFloatType}
        col2 {matlab.pyspark.internal.mustBeColFloatType}
    end

    col1 = matlab.pyspark.internal.unifyColArguments(col1);
    col2 = matlab.pyspark.internal.unifyColArguments(col2);

    newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.atan2(col1, col2));
end
