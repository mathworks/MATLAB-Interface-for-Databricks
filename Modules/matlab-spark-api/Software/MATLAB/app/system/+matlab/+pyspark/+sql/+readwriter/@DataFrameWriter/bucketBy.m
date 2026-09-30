function obj = bucketBy(obj, numBuckets, colNames)
    % BUCKETBY Specify bucketing with sortBy
    %
    %
    % DS.write.bucketBy(15, "Name").sortBy("id").mode("overwrite").saveAsTable("default.sorting_1");
    %
    % DS.write.bucketBy(33, "Name").sortBy("Other").mode("overwrite").saveAsTable("default.sorting_2");

    %  Copyright 2024 MathWorks, Inc.

    arguments (Input)
        obj   (1,1) matlab.pyspark.sql.readwriter.DataFrameWriter
        numBuckets (1,1) int64
        colNames string
    end
    arguments (Output)
        obj   (1,1) matlab.pyspark.sql.readwriter.DataFrameWriter
    end
    
    obj.toPy.bucketBy(numBuckets, colNames);

end %function
