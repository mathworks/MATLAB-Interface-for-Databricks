function parquet(obj, wPath, arg)
    % PARQUET Method to Saves the content of the DataFrame in Parquet format at the specified path.

    %
    % Please refer to corresponding pyspark documentation

    % Copyright 2024 MathWorks, Inc.

    arguments
        obj   (1,1) matlab.pyspark.sql.readwriter.DataFrameWriter
        wPath (1,1) string
    end
    arguments (Repeating)
        arg string
    end

    narginchk(2, 4);
    if nargin == 2
        % parquet(wPath)
        obj.toPy.parquet(wPath);
    elseif nargin == 3
        % parquet(wPath, mode)
        obj.toPy.parquet(wPath, arg{1});
    elseif nargin == 4
        % parquet(wPath, mode, partitionBy)
        obj.toPy.parquet(wPath, arg{1}, arg{2});
    end

end %function
