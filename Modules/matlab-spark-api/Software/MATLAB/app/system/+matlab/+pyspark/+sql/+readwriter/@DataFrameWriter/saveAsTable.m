function saveAsTable(obj, tableName)
    % SAVEASTABLE Method to save the dataset as a table
    % Use this method to save the object to storage in the specified format.
    %
    % For example:
    %
    %   outputLocation = '/delta/sampletable';
    %   DS.write.format("delta")...
    %               .option("path", outputLocation)...
    %               .saveAsTable("testTableName");
    %

    % Copyright 2024 MathWorks, Inc.

    arguments
        obj (1,1) matlab.pyspark.sql.readwriter.DataFrameWriter
        tableName (1,1) string
    end

    obj.toPy.saveAsTable(tableName);

end %function
