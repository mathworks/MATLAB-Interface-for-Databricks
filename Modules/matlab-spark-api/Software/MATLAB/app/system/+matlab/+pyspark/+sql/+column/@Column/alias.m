function col = alias(obj, alias)
    % alias Returns the column aliased with a new name or names
    %
    % Example:
    %   R = spark.range(10);
    %   R.select(R.('id').alias('new_Id')).show(3)

    % Copyright 2025 MathWorks, Inc.

    arguments (Input)
        obj (1,1) matlab.pyspark.sql.column.Column
        alias string {mustBeTextScalar}
    end
    arguments (Output)
        col (1,1) matlab.pyspark.sql.column.Column
    end

    col = matlab.pyspark.sql.column.Column(obj.toPy.alias(alias));
end