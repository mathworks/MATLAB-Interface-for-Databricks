function obj = mode(obj, saveMode)
    % MODE Specify save mode for writer
    %
    % It may be necessary to use this method instead of
    %   .option("mode", "some-mode"),
    % as saveAsTable will look at the mode, but not at options.
    %
    % Built-in options include:  
    % append | overwrite | ignore | error or errorifexists
    % 
    % For example:
    %
    %     myDataSet.write ...
    %         .mode("overwrite") ...
    %         .saveAsTable(outputLocation);
    
    %  Copyright 2023-2024 MathWorks, Inc.
    
    arguments (Input)
        obj (1,1) matlab.pyspark.sql.readwriter.DataFrameWriter
        saveMode (1,1) string
    end
    arguments (Output)
        obj   (1,1) matlab.pyspark.sql.readwriter.DataFrameWriter
    end

    obj.toPy.mode(saveMode);
    
end %function
