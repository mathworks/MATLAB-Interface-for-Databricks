function df = filter(obj, colArg)
    % filter Filter rows in a dataframe
    %

    % Copyright 2024 MathWorks, Inc.

    arguments (Input)
        obj (1,1) matlab.pyspark.sql.dataframe.Dataframe
        colArg (1,1) {matlab.pyspark.internal.mustBeColType}
    end
    arguments (Output)
        df (1,1) matlab.pyspark.sql.dataframe.Dataframe
    end

    arg = matlab.pyspark.internal.unifyColArguments(colArg);

    df = matlab.pyspark.sql.dataframe.Dataframe(obj.toPy.filter(arg));

end

