function text(obj, filePath)
    % TEXT Method to save the DataFrame content to a given text file
    % The DataFrame must have only one column that is of string type.
    % Each row becomes a new line in the output file.
    % The text files will be encoded as UTF-8.
    % Text-specific options for writing text files can be used
    % For example:
    %
    % For example:
    %   sparkDataSet.write.text('/mypath/sampletext.txt');

    % Copyright 2023-2024 MathWorks, Inc.
    arguments
        obj (1,1) matlab.pyspark.sql.readwriter.DataFrameWriter
        filePath (1,1) string
    end

    obj.toPy.text(filePath);   

end %function
