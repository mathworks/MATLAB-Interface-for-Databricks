function rgds = groupBy(obj, arg)
    % GROUPBY Group dataset by certain columns
    %
    % This will return a new RelationalGroupDataset
    %

    % Copyright 2024 MathWorks, Inc.

    arguments (Input)
        obj (1,1) matlab.pyspark.sql.dataframe.Dataframe
    end
    arguments (Input, Repeating)
        arg {matlab.pyspark.internal.mustBeColType}
    end
    arguments (Output)
        rgds (1,1) matlab.pyspark.sql.group.GroupedData
    end

    arg = matlab.pyspark.internal.unifyColArguments(arg);

    rgds = matlab.pyspark.sql.group.GroupedData(obj.toPy.groupBy(arg{:}));

end %function
