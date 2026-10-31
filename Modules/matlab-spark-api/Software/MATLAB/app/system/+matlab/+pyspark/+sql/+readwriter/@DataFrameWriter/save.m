function save(obj, wPath)
    % SAVE Method to save the dataset to external storage systems
    % Use this method to save the object to storage in the specified format.
    %
    % For example:
    %
    %   outputLocation = '/delta/sampletable';
    %   sparkDataSet...
    %     .write.format("delta")...
    %     .save(outputLocation);
    %

    % Copyright 2024 MathWorks, Inc.

    arguments
        obj   (1,1) matlab.pyspark.sql.readwriter.DataFrameWriter
        wPath (1,1) string
    end

    obj.toPy.save(wPath);

end %function
