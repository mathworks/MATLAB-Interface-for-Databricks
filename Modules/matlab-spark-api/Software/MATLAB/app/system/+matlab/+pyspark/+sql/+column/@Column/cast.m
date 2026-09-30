function col = cast(obj, castType)
    % COL Cast the type of a column
    %
    % Example:
    %
    %     % C1 is a column with a number but in string form
    %
    %     % Cast it to an integer
    %     newCol = C1.cast('int');

    % Copyright 2024 MathWorks, Inc.

    arguments (Input)
        obj (1,1) matlab.pyspark.sql.column.Column
        castType (1,1) string
    end
    arguments (Output)
        col (1,1) matlab.pyspark.sql.column.Column
    end

    col = matlab.pyspark.sql.column.Column(obj.toPy.cast(castType));

end
