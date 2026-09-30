function obj = sortBy(obj, cols)
    % SORTBY Specify sort order for saving
    %
    % DS.write.bucketBy(15, "Name").sortBy("id").mode("overwrite").saveAsTable("default.sorting_1");
    %
    % DS.write.bucketBy(33, "Name").sortBy("Other").mode("overwrite").saveAsTable("default.sorting_2");

    %  Copyright 2024 MathWorks, Inc.

    arguments (Input)
        obj (1,1) matlab.pyspark.sql.readwriter.DataFrameWriter
        cols string
    end
    arguments (Output)
        obj   (1,1) matlab.pyspark.sql.readwriter.DataFrameWriter
    end

    obj.toPy.sortBy(cols);

end %function
