function cols = columns(obj)
    % columns - Return column names

    % (c) 2024 MathWorks, Inc.

    arguments (Input)
        obj (1,1) matlab.pyspark.sql.dataframe.Dataframe
    end
    arguments (Output)
        cols string
    end

    cols = string(obj.toPy.columns);

end